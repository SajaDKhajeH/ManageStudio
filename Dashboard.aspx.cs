using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected static void CloseConnectios(Bank.AdakBankDataContext db)
        {
            try { db.Transaction?.Rollback(); } catch { };
            try { db.Connection.Close(); } catch { };
            try
            { db.Dispose(); }
            catch { };
        }
        [WebMethod]
        public static dynamic SetRequestOnMaster(long requestId, string turn_Date, string turn_Time,
                        string selectedFamily, string turnType, string desc,
                        int Duration, string Location, string Photographer)
        {
            var db = AdakDB.Db;
            try
            {
                turn_Date = turn_Date.ToEnglishNumber();
                turnType = turnType.ToDecodeNumber();
                Photographer = Photographer.ToDecodeNumber();
                Location = Location.ToDecodeNumber();
                selectedFamily = selectedFamily.ToDecodeNumber();
                if (turnType.IsNullOrEmpty() || turnType == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا موضوع عکاسی را مشخص کنید"
                    };
                }
                if (!turn_Date.IsDate())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا تاریخ نوبت را مشخص کنید"
                    };
                }
                if (!turn_Time.IsNullOrEmpty() && TimeSpan.Parse(turn_Time).Hours < 8)
                {
                    return new
                    {
                        Result = false,
                        Message = "قبل از ساعت 8 صبح نمی توانید نوبت بدین"
                    };
                }
                if (requestId == 0 && (selectedFamily.IsNullOrEmpty() | selectedFamily == "0"))
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا خانواده را مشخص کنید"
                    };
                }
                int? hasError = 0;
                string mes = "";
                bool IsEdit = false;
                long CauserId = LoginedUser.Id;
                long? FamilyId = selectedFamily.ToLong();
                long? RequestResultId = null;
                if (requestId == 0)
                {
                    db.usp_RequestTurn_Add(FamilyId, turn_Date, (turn_Time.IsNullOrEmpty() ? new TimeSpan() : TimeSpan.Parse(turn_Time)), CauserId, Photographer.ToLong(), desc, CauserId, ref mes, ref hasError, ref RequestResultId, turnType.ToLong(), Location.ToLong(), Duration, 0);
                }
                else
                {
                    IsEdit = true;
                    //اصلا اطلاعات خانواده تغییر نمیکنه
                    db.usp_RequestTurn_Edit(requestId, FamilyId, turn_Date, (turn_Time.IsNullOrEmpty() ? new TimeSpan() : TimeSpan.Parse(turn_Time)), Photographer.ToLong(), desc, CauserId, ref mes, ref hasError, turnType.ToLong(), Location.ToLong(), Duration, 0);
                }
                if (hasError == 1)
                {
                    //CloseConnectios(db);
                    return new
                    {
                        Result = false,
                        Message = mes.IsNullOrEmpty() ? "خطایی در ثبت اطلاعات رخ داده است" : mes
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
                //CloseConnectios(db);
                return new { Result = false, Message = ex.Message };
            }
        }
        [WebMethod]
        public static List<TurnList> GetTurns_By_Date(DateTime date)
        {
            var db = AdakDB.Db;
            var turnList = db.usp_Request_Select_By_Date_For_Dashboard(date).ToList();
            turnList = turnList ?? new List<Bank.usp_Request_Select_By_Date_For_DashboardResult>();
            List<TurnList> tlist = new List<TurnList>();
            DateTime CurrentDate = DateTime.Now;
            foreach (var item in turnList)
            {
                tlist.Add(new TurnList()
                {
                    hour = item.R_TurnTime.Value.Hours,
                    time = item.R_TurnTime.Value.ToString().Substring(0, 5),
                    title = PublicMethod.Tag_A_for_Family(item.FamilyTitle, item.R_FamilyId.ToCodeNumber()),
                    RequestId = item.R_Id,
                    BaseFamilyTitle = item.FamilyTitle,
                    Date = date.ToShamsi(),
                    TurnId = (item.R_Type ?? 0).ToCodeNumber(),
                    TurnTitle = item.TypeTitle.IsNullOrEmpty() ? "" : item.TypeTitle,
                    Desc = item.R_Desc,
                    Duration = (item.R_Duration ?? 0),
                    LocationId = item.R_Location?.ToCodeNumber(),
                    LocationTitle = item.LocationTitle,
                    DurationText = (item.R_Duration ?? 0).ToTimeString(),
                    PhotographerId = (item.PhotographerId ?? 0).ToCodeNumber(),
                    PhotographerName = item.PhotographerName,
                    FamilyId = item.R_FamilyId,
                    FamilyTitle = item.FamilyTitle,
                    BedPrice = item.BedPrice ?? 0,

                });
            }
            return tlist;
        }

        [WebMethod]
        public static dynamic RequestDelete(long requestId, bool SendSMSCancelTurn)
        {
            var db = AdakDB.Db;
            try
            {
                if (requestId == 0)
                {
                    return new
                    {
                        Result = false,
                        Message = "شناسه درخواست مشخص نیست"
                    };
                }
                int? hasError = 0;
                string mes = "";
                long CauserId = LoginedUser.Id;
                if (db.Connection.State != System.Data.ConnectionState.Open)
                {
                    db.Connection.Open();
                }
                db.Transaction = db.Connection.BeginTransaction();
                //در صورتی که خود کاربر انتخاب کنه که پیامک کنسل شدن جلسه ارسال شود
                if (SendSMSCancelTurn)
                {
                    db.usp_SendSMS_WhenCancel_OR_Del_Turn(requestId);
                }
                db.usp_Request_Delete(requestId, CauserId, ref mes, ref hasError);
                if (hasError == 1)
                {
                    CloseConnectios(db);
                    return new
                    {
                        Result = false,
                        Message = mes.IsNullOrEmpty() ? "خطایی در حذف اطلاعات رخ داده است" : mes
                    };
                }
                db.Transaction.Commit();
                db.Connection.Close();
                db.Connection.Dispose();
                return new
                {
                    Result = true,
                    Message = "حذف اطلاعات با موفقیت انجام شد"
                };

            }
            catch (Exception ex)
            {
                CloseConnectios(db);
                return new { Result = false, Message = ex.Message };
            }
        }

        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> LunarCalendar()
        {
            int? countt = 0;
            string TextAfterPrice = Settings.TextAfterPrice;
            var data = AdakDB.Db.usp_FamilyChild_LunarCalendar().ToList();
            List<LunarCalendarList> list = new List<LunarCalendarList>();
            int i = 1;
            data.ForEach(x => list.Add(new LunarCalendarList()
            {
                Row = i++,
                BirthDate = x.BirthDate,
                ChildName = x.ChildName,
                Desc = x.DESC,
                FamilyTitle = x.FamilyTitle,
                FatherFullName = x.FatherFullName,
                FatherMobile = x.FatherMobile,
                MotherFullName = x.MotherFullName,
                MotherMobile = x.MotherMobile,
            }));
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
        public static dynamic GetInfoForPayBy_FamilyId(long familyId)
        {
            var familyInfo = AdakDB.Db.usp_Family_Select_By_Id(familyId).SingleOrDefault();
            familyInfo = familyInfo ?? new Bank.usp_Family_Select_By_IdResult();

            var defaultsms = AdakDB.Db.usp_Data_Select_By_Id(DefaultDataIDs.DefaultSMS_GetDeposit).SingleOrDefault();
            string sms = defaultsms.D_DefaultSMSText;
            // sms = sms.Replace("{{عنوان خانواده}}", familyInfo.F_Title);
            return new
            {
                SMSActive = defaultsms.D_Active,
                SMSText = sms,
                FatherHasMobile = !familyInfo.F_FatherMobile.IsNullOrEmpty() && familyInfo.F_FatherMobile.IsMobileNumber(),
                MotherHasMobile = !familyInfo.F_MotherMobile.IsNullOrEmpty() && familyInfo.F_MotherMobile.IsMobileNumber(),
                FatherName = familyInfo.F_FatherName.IsNullOrEmpty() && familyInfo.F_FatherLName.IsNullOrEmpty() ? "آقای خانواده " + familyInfo.F_Title : (familyInfo.F_FatherName + " " + familyInfo.F_FatherLName),
                MotherName = familyInfo.F_MotherName.IsNullOrEmpty() && familyInfo.F_MotherLName.IsNullOrEmpty() ? "خانم خانواده" + familyInfo.F_Title : (familyInfo.F_MotherName + " " + familyInfo.F_MotherLName),
            };
        }
        [WebMethod]
        public static dynamic SendSMS_PayLink(long familyId, decimal Price, string SMSText, bool SendToFather, bool SendToMother)
        {
            if (familyId <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه خانواده مشخص نیست"
                };
            }
            if (Price <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ مشخص نیست"
                };
            }
            if (SMSText.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "متن پیامک مشخص نیست"
                };
            }

            var familyInfo = AdakDB.Db.usp_Family_Select_By_Id(familyId).SingleOrDefault();
            familyInfo = familyInfo ?? new Bank.usp_Family_Select_By_IdResult();
            SMSText = SMSText.Replace("{{عنوان خانواده}}", familyInfo.F_Title);
            SMSText = SMSText.Replace("{{مبلغ}}", Price.ShowPrice(Settings.TextAfterPrice));
            string Key = "";
            AdakDB.Db.usp_KeyGenerator_Add(Price, familyId, ref Key);
            if (Key.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "خطایی در ایجاد لینک رخ داده است"
                };
            }
            var address = HttpContext.Current.Request.Url.Host;
            address = "https://" + address + "/pay.aspx?k=" + Key;
            SMSText = SMSText.Replace("{{لینک}}", address);

            int? hasError = 0;
            string mes = "";
            AdakDB.Db.usp_SMS_Add((SendToFather ? familyInfo.F_FatherMobile : familyInfo.F_MotherMobile), SMSText, DefaultDataIDs.SMSTypeId_PayLink, familyId, LoginedUser.Id, ref hasError, ref mes);
            if (hasError == 1)
            {
                return new
                {
                    Result = false,
                    Message = mes.IsNullOrEmpty() ? "خطایی نامشخص در ارسال پیامک پیش امده است" : mes
                };
            }
            return new
            {
                Result = true,
                Message = "ارسال پیامک با موفقیت انجام شد"
            };
        }
        [WebMethod]
        public static dynamic GetInfoBy_TurnId(long TurnId)
        {
            var TurnInfo = AdakDB.Db.usp_TurnInfo_By_Id(TurnId).SingleOrDefault();
            TurnInfo = TurnInfo ?? new Bank.usp_TurnInfo_By_IdResult();

            return new
            {
                FamilyId = TurnInfo.FamilyId.ToCodeNumber(),
                TypeId = TurnInfo.TurnType.ToCodeNumber(),
                PhotographerId = TurnInfo.PhotographerId.ToCodeNumber()
            };
        }
        [WebMethod]
        public static dynamic GetPhotographerByFamily(string familyId)
        {
            familyId = familyId.ToDecodeNumber();
            if (familyId.ToLong() > 0)
            {
                long? lastPhotographerId = AdakDB.Db.ufn_GetLastPhotographer_By_FamilyId(familyId.ToLong());
                if (lastPhotographerId > 0)
                {
                    return new
                    {
                        LastPhotographerId = lastPhotographerId.ToCodeNumber(),
                        Change=true
                    };
                }
            }
            return new
            {
                Change = false
            };
        }
    }

}
public class TurnList
{
    public int hour { get; set; }
    public string title { get; set; }
    public string time { get; set; }
    public long RequestId { get; set; }
    public string Date { get; set; }
    public string TurnId { get; set; }
    public string TurnTitle { get; set; }
    public string Desc { get; set; }
    public string BaseFamilyTitle { get; set; }
    public int Duration { get; set; }
    public int Cost { get; set; }
    public string LocationTitle { get; set; }
    public string LocationId { get; set; }
    public int ModPrice { get; set; }
    public string DurationText { get; set; }
    public string PhotographerId { get; set; }
    public string PhotographerName { get; set; }
    public long FamilyId { get; set; }
    public string FamilyTitle { get; set; }
    public decimal BedPrice { get; set; }
}
public class LunarCalendarList
{
    public int Row { get; set; }
    public string FamilyTitle { get; set; }
    public string MotherFullName { get; set; }
    public string FatherFullName { get; set; }
    public string MotherMobile { get; set; }
    public string FatherMobile { get; set; }
    public string BirthDate { get; set; }
    public string ChildName { get; set; }
    public string Desc { get; set; }
}
