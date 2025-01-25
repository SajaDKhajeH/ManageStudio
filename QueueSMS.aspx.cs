using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QueueSMS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static OperationResult<ForGrid.DataTableModel> ForGrid(
            int page, int perPage, string SearchText, string Fromdate, string Todate, string FamilyId, string CauserId, bool OnlyQueued, string TypeId
            )
    {
        Fromdate = Fromdate.ToEnglishNumber();
        Todate = Todate.ToEnglishNumber();
        FamilyId = FamilyId.ToDecodeNumber();
        CauserId = CauserId.ToDecodeNumber();
        TypeId = TypeId.ToDecodeNumber();
        int? countt = 0;
        var data = AdakDB.Db.usp_SMS_Select_ForGrid(SearchText, CauserId.ToLong(), Fromdate, Todate, FamilyId.ToLong(), OnlyQueued, page, perPage, ref countt, TypeId.ToLong()).ToList();
        data = data ?? new List<Bank.usp_SMS_Select_ForGridResult>();
        List<SMSQueueForGrid> list = new List<SMSQueueForGrid>();
        data.ForEach(x => list.Add(new SMSQueueForGrid()
        {
            FamilyTitle = x.FamilyTitle,
            TypeTitle = x.TypeTitle,
            CauserName = x.CauserName,
            Mobile = x.S_Mobile,
            SendedTime = x.S_SendedTime == null ? "---" : x.S_SendedTime.ToShamsi() + "-" + x.S_SendedTime.Value.TimeOfDay.ToString().Substring(0, 5),
            SendTime = x.S_SendTime.ToShamsi() + "-" + x.S_SendTime.TimeOfDay.ToString().Substring(0, 5),
            StatusSended = x.S_Sended ? "ارسال شده" : "در انتظار ارسال",
            Text = x.S_Text,
            Select = @"
                <input id='ch_" + x.S_Id + @"' onclick='selectOneSMS(this)' type='checkbox' class='customer-checkbox' />
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
            Message = "",
            Data = new ForGrid.DataTableModel()
            {
                recordsTotal = countt ?? 0,
                recordsFiltered = countt ?? 0,
                data = list
            }
        };
    }

    [WebMethod]
    public static dynamic DelSMS(long[] SMSIds)
    {
        if (SMSIds.Count() == 0)
        {
            return new
            {
                Result = false,
                Message = "لطفا ابتدا پیامی رو انتخاب کنید"
            };
        }
        try
        {
            var db = AdakDB.Db;
            string smsids = string.Join(",", SMSIds);
            db.usp_SMS_Delete(smsids, LoginedUser.Id);
            return new
            {
                Result = true,
                Message = "حذف با موفقیت انجام شد"
            };
        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                Message = ex.Message
            };
        }
    }
    public class SMSQueueForGrid
    {
        public string Text { get; set; }
        public string FamilyTitle { get; set; }
        public string SendTime { get; set; }
        public string StatusSended { get; set; }
        public string CauserName { get; set; }
        public string TypeTitle { get; set; }
        public string SendedTime { get; set; }
        public string Mobile { get; set; }
        public string Select { get; set; }
    }
}