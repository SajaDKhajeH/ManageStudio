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
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role != DefaultDataIDs.Role_Admin && LoginedUser.Role != DefaultDataIDs.Role_Secretary)
            {
                Response.Redirect("Logout.aspx");
            }
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
                        int Duration, string Location, int Cost)
        {
            var db = AdakDB.Db;
            try
            {
                turn_Date = turn_Date.ToEnglishNumber();
                turnType = turnType.ToDecodeNumber();
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
                if (Cost < 0)
                {
                    return new
                    {
                        Result = false,
                        Message = "هزینه نوبت نمیتونه کمتر از صفر باشد"
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
                    db.usp_RequestTurn_Add(FamilyId, turn_Date, (turn_Time.IsNullOrEmpty() ? new TimeSpan() : TimeSpan.Parse(turn_Time)), CauserId, null, desc, CauserId, ref mes, ref hasError, ref RequestResultId, turnType.ToLong(), Location.ToLong(), Duration, Cost);
                }
                else
                {
                    IsEdit = true;
                    //اصلا اطلاعات خانواده تغییر نمیکنه
                    db.usp_RequestTurn_Edit(requestId, FamilyId, turn_Date, (turn_Time.IsNullOrEmpty() ? new TimeSpan() : TimeSpan.Parse(turn_Time)), null, desc, CauserId, ref mes, ref hasError, turnType.ToLong(), Location.ToLong(), Duration, Cost);
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
                    Cost = (item.R_Cost ?? 0).ToInt(),
                    Duration = (item.R_Duration ?? 0),
                    LocationId = item.R_Location.ToCodeNumber(),
                    LocationTitle = item.LocationTitle,
                    ModPrice = (item.ModPrice ?? 0).ToInt(),
                    DurationText = (item.R_Duration ?? 0).ToTimeString()
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
}