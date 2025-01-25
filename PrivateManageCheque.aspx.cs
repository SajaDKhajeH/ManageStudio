using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PrivateManageCheque : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (LoginedUser.Id <= 0)
        {
            Response.Redirect("Logout.aspx");
        }
        if (LoginedUser.Role != DefaultDataIDs.Role_Admin)
        {
            Response.Redirect("Logout.aspx");
        }
        if (LoginedUser.Id != 1)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
    [WebMethod]
    public static dynamic AddEditCheque(long id, bool c_Recive, bool c_Pay, string c_Price, string c_ReciveDate, string c_ChequeNumber, string c_Owner, string c_WillDate, string c_forsubject, string c_desc, bool c_Registered, bool c_Spent, string c_bank)
    {
        try
        {
            c_ReciveDate = c_ReciveDate.ToEnglishNumber();
            c_WillDate = c_WillDate.ToEnglishNumber();
            c_bank = c_bank.ToDecodeNumber();
            if (c_ReciveDate.IsNullOrEmpty() || !c_ReciveDate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "تاریخ ثبت را مشخص کنید"
                };
            }
            if (c_WillDate.IsNullOrEmpty() || !c_WillDate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "تاریخ سررسید را مشخص کنید"
                };
            }
            if (c_Price.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ چک را مشخص کنید"
                };
            }
            if (c_Price.ToDecimal() <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ چک را مشخص کنید"
                };
            }
            int? hasError = 0;
            long? resultId = 0;
            long? CauserID = LoginedUser.Id;
            string mes = "";
            if (id == 0)
            {
                AdakDB.Db.usp_PrivateCheque_Add_New(c_ReciveDate, c_desc, c_WillDate, c_forsubject, c_ChequeNumber, c_Recive, c_Price.ToDecimal(), c_Owner, c_Registered, CauserID, ref mes, ref hasError, ref resultId, c_bank.ToLong(), c_Spent);
            }
            else
            {
                AdakDB.Db.usp_PrivateCheque_Edit_new(id, c_ReciveDate, c_desc, c_WillDate, c_forsubject, c_ChequeNumber, c_Recive, c_Price.ToDecimal(), c_Owner, c_Registered, CauserID, ref mes, ref hasError, c_bank.ToLong(), c_Spent);
            }
            if (hasError == 1)
            {
                return new
                {
                    Result = false,
                    Message = mes
                };
            }
            return new
            {
                Result = true,
                Message = "ثبت اطلاعات با موفقیت انجام شد"
            };

        }
        catch (Exception ex)
        {
            return new { Result = false, Message = "error" };
        }

    }
    [WebMethod]
    public static dynamic EditCheque(long id)
    {
        try
        {
            if (id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه هزینه مشخص نیست"
                };
            }
            var pInfo = AdakDB.Db.usp_PrivateCheque_Select_ById(id).SingleOrDefault();
            pInfo = pInfo ?? new Bank.usp_PrivateCheque_Select_ByIdResult();
            return new
            {
                Result = true,
                ChequeInfo = pInfo,
                BankId = pInfo.C_Bank.ToCodeNumber()
            };

        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,

            };
        }

    }
    [WebMethod]
    public static OperationResult<ForGrid.DataTableModel> ForGrid(
            int page, int perPage, string fromDate, string toDate, string filter_Registered,
            string filter_Recived, string searchText, string spent, string bank
            )
    {
        perPage = perPage == 0 ? 10 : perPage;
        searchText = searchText.Trim();
        int? countt = 0;

        string TextAfterPrice = "ریال";
        bool? registerd = filter_Registered == "0" ? new bool?() : filter_Registered == "1";
        bool? Recived = filter_Recived == "0" ? new bool?() : filter_Recived == "1";
        bool? Spent = spent == "0" ? new bool?() : spent == "1";
        var data = AdakDB.Db.usp_PrivateCheque_Select_For_Grid_New(searchText, page, perPage, ref countt, LoginedUser.Id, fromDate.ToEnglishNumber(), toDate.ToEnglishNumber(), registerd, Recived, Spent, bank.ToDecodeNumber().ToLong()).ToList();
        data = data ?? new List<Bank.usp_PrivateCheque_Select_For_Grid_NewResult>();
        List<ChequeForGrid> list = new List<ChequeForGrid>();
        string SumPriceCost = data.Sum(a => a.C_Price).ShowPrice(TextAfterPrice);
        data.ForEach(x => list.Add(new ChequeForGrid()
        {
            C_Price = x.C_Price.ShowPrice(TextAfterPrice),
            C_ChequeNumber = x.C_ChequeNumber,
            C_Desc = x.C_Desc,
            C_ForSubject = x.C_ForSubject,
            C_IsRecive = x.C_IsRecive ? "دریافتی" : "پرداختی",
            C_Owner = x.C_Owner,
            BankTitle = x.BankTitle.IsNullOrEmpty()?"": x.BankTitle,
            Spent = x.C_Spent ?? false ? "خرج شده" : "خرج نشده",
            C_ReciveDate = x.C_ReciveDate,
            C_WillReciveDate = x.C_WillReciveDate,
            C_Registered = x.C_Registered ?? false ? "ثبت شده" : "ثبت نشده",
            Actions = @"
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#model_AddEditCheque' onclick='EditCheque(" + x.C_Id + @")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='DeleteCheque(" + x.C_Id + @")' title='حذف'>🗑</button>
                </div>
                "
        })); ;
        if (list == null)
        {
            return new OperationResult<ForGrid.DataTableModel>
            {
                Success = false,
                Message = "اطلاعات برای نمایش وجود ندارد",
                Data = new ForGrid.DataTableModel() { }
            };
        }
        return new OperationResult<ForGrid.DataTableModel>
        {
            Success = true,
            Message = SumPriceCost,

            Data = new ForGrid.DataTableModel()
            {
                recordsTotal = countt ?? 0,
                recordsFiltered = countt ?? 0,
                data = list
            }
        };
    }
    [WebMethod]
    public static dynamic DeleteChqeue(long id)
    {
        if (id == 0)
        {
            return new
            {
                Result = false,
                Message = "شناسه چک مشخص نیست"
            };
        }
        var db = AdakDB.Db;
        int? haserror = 0;
        string mes = "";
        db.usp_PrivateCheque_Delete(id, LoginedUser.Id, ref mes, ref haserror);
        return new
        {
            Result = haserror == 0,
            Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
        };
    }

}
public class ChequeForGrid
{
    public string C_ReciveDate { get; set; }
    public string BankTitle { get; set; }
    public string Spent { get; set; }
    public string C_Desc { get; set; }
    public string C_WillReciveDate { get; set; }
    public string C_ForSubject { get; set; }
    public string C_ChequeNumber { get; set; }
    public string C_IsRecive { get; set; }
    public string C_Price { get; set; }
    public string C_Owner { get; set; }
    public string C_Registered { get; set; }
    public string Actions { get; set; }

}