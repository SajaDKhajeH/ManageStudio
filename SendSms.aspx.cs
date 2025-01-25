using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class SendSms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> ForGrid(
               string Fromdate, string Todate, string Hospital, bool BedFamily
               )
        {
            Fromdate = Fromdate.ToEnglishNumber();
            Todate = Todate.ToEnglishNumber();
            Hospital = Hospital.ToDecodeNumber();
            int? countt = 0;
            string TextAfterPrice = Settings.TextAfterPrice;
            var data = AdakDB.Db.usp_Family_Select_For_SendSMS(Fromdate, Todate, Hospital.ToLong(), BedFamily, LoginedUser.Id).ToList();
            data = data ?? new List<Bank.usp_Family_Select_For_SendSMSResult>();
            List<SMSForGrid> list = new List<SMSForGrid>();
            countt = data.Count;
            data.ForEach(x => list.Add(new SMSForGrid()
            {
                FamilyId = x.FamilyId,
                FamilyTitle = x.FamilyTitle,
                FatherFullName = x.FatherFullName,
                MotherFullName = x.MotherFullName,
                Actions = @"
                <input id='ch_" + x.FamilyId + @"' onclick='selectOneCustomer(this)' type='checkbox' class='customer-checkbox' />
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
        public static dynamic SendSMS(bool sendToFather, bool sendToMother, string message, long[] selectedFamily)
        {

            if (message.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا متن پیام را مشخص کنید"
                };
            }
            if (sendToFather == false && sendToMother == false)
            {
                return new
                {
                    Result = false,
                    Message = "لطفا ارسال به پدر یا مادر را مشخص کنید"
                };
            }
            if (selectedFamily == null || selectedFamily.Count() == 0)
            {
                return new
                {
                    Result = false,
                    Message = "لطفا خانواده ای را انتخاب کنید"
                };
            }
            string familes = string.Join(",", selectedFamily);
            int? hasError = 0;
            string mes = "";
            AdakDB.Db.usp_SMS_AddMulti(familes, sendToMother, sendToFather, message, LoginedUser.Id, ref hasError, ref mes);
            return new
            {
                Result = hasError == 0,
                Message = mes
            };
        }
    }

    public class SMSForGrid
    {
        public string FamilyTitle { get; set; }
        public long FamilyId { get; set; }
        public string Actions { get; set; }
        public string MotherFullName { get; set; }
        public string FatherFullName { get; set; }
    }
}