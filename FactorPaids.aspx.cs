using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class FactorPaids : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string fromDate, string toDate, string familyId, string searchText, string PaidType)
    {
        perPage = perPage == 0 ? 10 : perPage;
        searchText = searchText.Trim();
        int? countt = 0;
        familyId = familyId.ToDecodeNumber();
        PaidType = PaidType.ToDecodeNumber();
        string TextAfterPrice = Settings.TextAfterPrice;
        var data = AdakDB.Db.usp_Paids_Select_Grid(searchText, fromDate.ToEnglishNumber(), toDate.ToEnglishNumber(), familyId.ToLong(), PaidType.ToLong(), page, perPage, ref countt, LoginedUser.Id).ToList();
        List<PaidForGrid> list = new List<PaidForGrid>();
        string SumPricePaids = data.Sum(a => a.Pa_Price).ShowPrice(TextAfterPrice);
        int i = 1;
        data.ForEach(x => list.Add(new PaidForGrid()
        {
            Row = i++,
            FamilyTitle = x.FamilyTiyle,
            PaidPrice = x.Pa_Price.ShowPrice(TextAfterPrice),
            PaidType = x.PaidTypeTitle,
            RefNumber = x.Pa_RefNumber,
            Causer = x.CauserName,
            CashBankTitle=x.CashBankTitle,
            SubjectText = x.Pa_Desc.IsNullOrEmpty()?"": x.Pa_Desc,
            Date_A_TimePaid = x.Pa_DateS + " " + x.Pa_CreationTime.TimeOfDay.ToString().Substring(0,5),
            Actions = @"
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-delete' onclick='PaidDelete(" + x.Pa_Id + @")' title='حذف'>🗑</button>
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
            Message = SumPricePaids,
            Data = new ForGrid.DataTableModel()
            {
                recordsTotal = countt ?? 0,
                recordsFiltered = countt ?? 0,
                data = list
            }
        };
    }
    [WebMethod]
    public static dynamic PaidDelete(long id)
    {
        if (id == 0)
        {
            return new
            {
                Result = false,
                Message = "شناسه پرداخت مشخص نیست"
            };
        }
        var db = AdakDB.Db;
        int? haserror = 0;
        string mes = "";
        db.usp_Paids_Delete(id,LoginedUser.Id, ref mes, ref haserror);
        return new
        {
            Result = haserror == 0,
            Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
        };
    }
}
public class PaidForGrid
{
    public int Row { get; set; }
    public string FamilyTitle { get; set; }
    public string PaidPrice { get; set; }
    public string PaidType { get; set; }
    public string RefNumber { get; set; }
    public string Causer { get; set; }
    public string Date_A_TimePaid { get; set; }
    public string Actions { get; set; }
    public string SubjectText { get; set; }
    public string CashBankTitle { get; set; }


}
