using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class OnlineAppointmentSettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static dynamic DeleteOnlineAppointmentSettings(long id)
    {
        try
        {
            if (id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه مشخص نیست"
                };
            }
            string mes = "";
            int? hasError = 0;
            AdakDB.Db.usp_OnlineTurnSettings_Delete(id, LoginedUser.Id, ref mes, ref hasError);

            return new
            {
                Result = hasError == 0,
                Message = mes
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
    public static dynamic AddEdit(
            long ots_Id,
            string title,
            string turnType,
            bool active,
            decimal depositeamount,
            int countShowWeek,
            string fromtime,
            string totime,
            int TimeEachTurn,
            int capacity,
            string af_fromtime,
            string af_totime,
            int af_TimeEachTurn,
            int af_capacity,
            string days,
            string desc
        )
    {
        try
        {
            fromtime = fromtime.ToEnglishNumber();
            totime = totime.ToEnglishNumber();
            turnType = turnType.ToDecodeNumber();
            if (title.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا عنوان را مشخص کنید"
                };
            }
            if (turnType.IsNullOrEmpty() || turnType == "0")
            {
                return new
                {
                    Result = false,
                    Message = "لطفا نوع عکاسی را مشخص کنید"
                };
            }
            if (depositeamount <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "لطفا مبلغ بیعانه را مشخص کنید"
                };
            }
            if (fromtime.IsNullOrEmpty() && !totime.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا بازه زمانی طرف صبح را به صورت کامل مشخص کنید"
                };
            }
            if (af_fromtime.IsNullOrEmpty() && !af_totime.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا بازه زمانی طرف بعدازظهر را به صورت کامل مشخص کنید"
                };
            }

            if (!fromtime.IsNullOrEmpty() && totime.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا بازه زمانی طرف صبح را به صورت کامل مشخص کنید"
                };
            }
            if (!af_fromtime.IsNullOrEmpty() && af_totime.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا بازه زمانی طرف بعدازظهر را به صورت کامل مشخص کنید"
                };
            }

            if (fromtime.ToTimeParse() > totime.ToTimeParse())
            {
                return new
                {
                    Result = false,
                    Message = "از ساعت نمی تواند بزرگتر از تا ساعت نوبت طرف صبح باشد"
                };
            }

            if (af_fromtime.ToTimeParse() > af_totime.ToTimeParse())
            {
                return new
                {
                    Result = false,
                    Message = "از ساعت نمی تواند بزرگتر از تا ساعت برای نوبت طرف بعدازظهر باشد"
                };
            }
            string path = "";
            var b = AdakDB.Db;

            if (days.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا روزهای هفته را مشخص کنید"
                };
            }

            capacity = capacity == 0 ? 1 : capacity;
            af_capacity = af_capacity == 0 ? 1 : af_capacity;
            countShowWeek = countShowWeek == 0 ? 1 : countShowWeek;

            long CauserId = LoginedUser.Id;
            int? hasError = 0;
            long? resultId = 0;
            string mes = "";
            if (ots_Id <= 0)
            {
                b.usp_OnlineTurnSettings2_Add(title, TimeEachTurn, depositeamount, desc, turnType.ToLong(), fromtime.ToTimeParse(), totime.ToTimeParse(), path, capacity, af_fromtime.ToTimeParse(), af_totime.ToTimeParse(), af_TimeEachTurn, af_capacity, days, countShowWeek, active, CauserId, ref mes, ref hasError, ref resultId);
            }
            else
            {
                b.usp_OnlineTurnSettings2_Edit(ots_Id, title, TimeEachTurn, depositeamount, desc, turnType.ToLong(), fromtime.ToTimeParse(), totime.ToTimeParse(), path, capacity, af_fromtime.ToTimeParse(), af_totime.ToTimeParse(), af_TimeEachTurn, af_capacity, days, countShowWeek, active, CauserId, ref mes, ref hasError);
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
    public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string searchText)
    {
        perPage = perPage == 0 ? 10 : perPage;
        searchText = searchText.Trim();
        int? countt = 0;
        var data = AdakDB.Db.usp_OnlineTurnSettings_Select_For_Grid(searchText, ref countt, page, perPage).ToList();
        data = data ?? new List<Bank.usp_OnlineTurnSettings_Select_For_GridResult>();
        List<SettingsForGrid> list = new List<SettingsForGrid>();
        string TextAfterPrice = Settings.TextAfterPrice;
        data.ForEach(x => list.Add(new SettingsForGrid()
        {
            Title = x.OTS_Title,
            TurnType = x.TurnTypeTitle,
            RangeDate = x.OTS_FromDate.ToShamsi() + " تا " + x.OTS_ToDate.ToShamsi(),
            RangeTime = x.OTS_FromTime.ToString().Substring(0, 5) + " تا " + x.OTS_ToTime.ToString().Substring(0, 5),
            DepositeAmount = (x.OTS_DepositAmount ?? 0).ShowPrice(TextAfterPrice),
            Capacity = x.OTS_Capacity ?? 0,
            Status = x.OTS_Active ? "<div class='badge badge-light-success'>فعال</div>" : "<div class='badge badge-light-danger'>غیرفعال</div>",
            Actions = @"
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_AddEditOnlineTurnSetting' onclick='EditSettings(" + x.OTS_Id + @")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='DeleteOnlineAppointmentSettings(" + x.OTS_Id + @")' title='حذف'>🗑</button>
                </div>
                "
        })); ; ; ;


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
    public static dynamic EditSettings(long id)
    {
        try
        {
            if (id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه مشخص نیست"
                };
            }
            var dataInfo = AdakDB.Db.usp_OnlineTurnSettings_SelectById(id).SingleOrDefault();
            dataInfo = dataInfo ?? new Bank.usp_OnlineTurnSettings_SelectByIdResult();
            var days = dataInfo.OTS_WeekDays.IsNullOrEmpty() ? new List<string>() : dataInfo.OTS_WeekDays.Split(',').ToList();
            return new
            {
                Result = true,
                Title = dataInfo.OTS_Title,
                FromDate = dataInfo.OTS_FromDate.ToShamsi(),
                ToDate = dataInfo.OTS_ToDate.ToShamsi(),
                TurnType = dataInfo.OTS_TurnType.ToCodeNumber(),
                FromTime = dataInfo.OTS_FromTime == null ? "" : dataInfo.OTS_FromTime.ToString().Substring(0, 5),
                ToTime = dataInfo.OTS_ToTime == null ? "" : dataInfo.OTS_ToTime.ToString().Substring(0, 5),
                Capacity = dataInfo.OTS_Capacity ?? 0,
                Active = dataInfo.OTS_Active,
                DepositeAmount = dataInfo.OTS_DepositAmount ?? 0,
                Desc = dataInfo.OTS_Desc,
                FilePath = dataInfo.OTS_FilePath,
                TimeEachTurn = dataInfo.OTS_TimeEachTurn ?? 0,
                FileName = Path.GetFileName(dataInfo.OTS_FilePath),
                AF_FromTime = dataInfo.OTS_AF_FromTime == null ? "" : dataInfo.OTS_AF_FromTime.ToString().Substring(0, 5),
                AF_ToTime = dataInfo.OTS_AF_ToTime == null ? "" : dataInfo.OTS_AF_ToTime.ToString().Substring(0, 5),
                AF_Capacity = dataInfo.OTS_AF_Capacity ?? 0,
                AF_TimeEachTurn = dataInfo.OTS_AF_TimeEachTurn ?? 0,
                CountShowWeek = dataInfo.OTS_CountShowWeek ?? 0,
                saturday = days.Any(a => a == "1"),
                sunday = days.Any(a => a == "2"),
                monday = days.Any(a => a == "3"),
                tuesday = days.Any(a => a == "4"),
                wednesday = days.Any(a => a == "5"),
                thursday = days.Any(a => a == "6"),
                friday = days.Any(a => a == "7")

            };

        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                ShowDefaultSMS = false,
                ShowState = false
            };
        }

    }
}
public class SettingsForGrid
{
    public string Title { get; set; }
    public string TurnType { get; set; }
    public string RangeDate { get; set; }
    public string RangeTime { get; set; }
    public string DepositeAmount { get; set; }
    public int Capacity { get; set; }
    public string Status { get; set; }
    public string Actions { get; set; }

}