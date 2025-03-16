using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;



public partial class Cost : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static dynamic AddEditCost(long id, string PaidFrom, string PaidPrice, string CostType, string PaidType, string RefNumber, string desc, string PaidTo, string PaidDate)
    {
        try
        {
            PaidDate = PaidDate.ToEnglishNumber();
            PaidFrom = PaidFrom.ToDecodeNumber();
            CostType = CostType.ToDecodeNumber();
            PaidType = PaidType.ToDecodeNumber();
            PaidTo = PaidTo.ToDecodeNumber();
            if (PaidFrom.IsNullOrEmpty() || PaidFrom.ToInt() <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شخص پرداخت کننده را مشخص کنید"
                };
            }
            if (CostType.IsNullOrEmpty() || CostType.ToInt() <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "موضوع پرداخت را مشخص کنید"
                };
            }
            if (PaidType.IsNullOrEmpty() || PaidType.ToInt() <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "طریقه پرداخت را مشخص کنید"
                };
            }
            if (PaidDate.IsNullOrEmpty() || !PaidDate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "تاریخ پرداخت را مشخص کنید"
                };
            }
            int? hasError = 0;
            long? resultId = 0;
            long? CauserID = LoginedUser.Id;
            string mes = "";
            if (id == 0)
            {
                AdakDB.Db.usp_Cost_Add(CostType.ToLong(), PaidPrice.ToDecimal(), PaidDate, PaidType.ToLong(), RefNumber, PaidTo.ToLong(), desc, PaidFrom.ToLong(), CauserID, ref mes, ref hasError, ref resultId);
            }
            else
            {
                AdakDB.Db.usp_Cost_Edit(id, CostType.ToLong(), PaidPrice.ToDecimal(), PaidDate, PaidType.ToLong(), RefNumber, PaidTo.ToLong(), desc, PaidFrom.ToLong(), CauserID, ref mes, ref hasError);
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
    public static dynamic EditCost(long id)
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
            var pInfo = AdakDB.Db.usp_Cost_Select_By_Id(id).SingleOrDefault();
            pInfo = pInfo ?? new Bank.usp_Cost_Select_By_IdResult();
            return new
            {
                Result = true,
                CostType = pInfo.Co_CostType.ToCodeNumber(),
                PaidType = pInfo.Co_PaidType.ToCodeNumber(),
                PaidFrom = pInfo.Co_PaidFrom.ToCodeNumber(),
                PaidTo = (pInfo.Co_PaidTo ?? 0).ToCodeNumber(),
                Desc = pInfo.Co_Desc,
                RefNumber = pInfo.Co_RefNumber,
                PaidDate = pInfo.Co_Date,
                PaidPrice = pInfo.Co_Price,
                CostTitle = pInfo.CostTitle,
                PaidFromFullName = pInfo.PaidFromFullName
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
            int page, int perPage, string fromDate, string toDate, string PaidTypeId, string searchText,
            string causerId, string CostTypeId, string PaidFromId, string PaidToId
            )
    {
        perPage = perPage == 0 ? 10 : perPage;
        searchText = searchText.Trim();
        int? countt = 0;
        PaidTypeId = PaidTypeId.ToDecodeNumber();
        causerId = causerId.ToDecodeNumber();
        CostTypeId = CostTypeId.ToDecodeNumber();
        PaidFromId = PaidFromId.ToDecodeNumber();
        PaidToId = PaidToId.ToDecodeNumber();

        string TextAfterPrice = Settings.TextAfterPrice;
        
        var data = AdakDB.Db.usp_Cost_Select_For_Grid(fromDate.ToEnglishNumber(), toDate.ToEnglishNumber(), PaidTypeId.ToLong(), CostTypeId.ToLong(), PaidFromId.ToLong(), PaidToId.ToLong(), searchText, page, perPage, ref countt, causerId.ToLong()).ToList();
        data = data ?? new List<Bank.usp_Cost_Select_For_GridResult>();
        List<CostForGrid> list = new List<CostForGrid>();
        string SumPriceCost = data.Sum(a=>a.Co_Price).ShowPrice(TextAfterPrice);
        data.ForEach(x => list.Add(new CostForGrid()
        {
            PaidFromFullName = x.PaidFromFullName,
            PaidToFullName = x.PaidToFullName.IsNullOrEmpty() ? "" : x.PaidToFullName,
            CostType = x.CostTitle,
            PaidType = x.PaidTypeTitle,
            PaidDate = x.Co_Date,
            PaidPrice = x.Co_Price.ShowPrice(TextAfterPrice),
            RefNumber = x.Co_RefNumber.IsNullOrEmpty() ? "" : x.Co_RefNumber,
            CauserName = x.CauserName,
            Date_A_Time = x.Co_CreationTime.ToShamsi() + " - " + x.Co_CreationTime.Value.TimeOfDay.ToString().Substring(0, 5),
            Actions = @"
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#model_AddEditCost' onclick='EditCost(" + x.Co_ID + @")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='DeleteCost(" + x.Co_ID + @")' title='حذف'>🗑</button>
                </div>
                "
        })); ;
        //  < div class='menu-item px-3'><a data-bs-toggle='modal' data-bs-target='#m_SetFactor' onclick='GetInfoForEditFactor(" + x.F_Id + @")' class='menu-link px-3'>ویرایش</a></div>
        //<div class='menu-item px-3'><a onclick = 'FactorDelete(" + x.F_Id + @")' class='menu-link px-3'>حذف</a></div>

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
    public static dynamic DeleteCost(long id)
    {
        if (id == 0)
        {
            return new
            {
                Result = false,
                Message = "شناسه هزینه مشخص نیست"
            };
        }
        var db = AdakDB.Db;
        int? haserror = 0;
        string mes = "";
        db.usp_Cost_Delete(id, LoginedUser.Id, ref mes, ref haserror);
        return new
        {
            Result = haserror == 0,
            Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
        };
    }

    [WebMethod]
    public static string GetLoginedUserIdCoded()
    {
        return LoginedUser.Id.ToCodeNumber();
    }
    public class CostForGrid
    {
        public string PaidFromFullName { get; set; }
        public string PaidToFullName { get; set; }
        public string PaidDate { get; set; }
        public string PaidPrice { get; set; }
        public string CostType { get; set; }
        public string PaidType { get; set; }
        public string RefNumber { get; set; }
        public string CauserName { get; set; }
        public string Date_A_Time { get; set; }
        public string Actions { get; set; }

    }
}
