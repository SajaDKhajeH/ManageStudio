using Bank;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace AdakStudio
{
    public partial class BasicData : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role != DefaultDataIDs.Role_Admin)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }


        [WebMethod]
        public static dynamic DeleteData(string id)
        {
            try
            {
                id = id.ToDecodeNumber();
                if (id.IsNullOrEmpty() || id == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "شناسه مشخص نیست"
                    };
                }
                string mes = "";
                int? hasError = 0;
                AdakDB.Db.usp_Data_Delete(id.ToLong(), LoginedUser.Id, ref mes, ref hasError);

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
        public static dynamic EditData(string id)
        {
            try
            {
                id = id.ToDecodeNumber();
                if (id.IsNullOrEmpty() || id == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "شناسه مشخص نیست"
                    };
                }
                var dataInfo = AdakDB.Db.usp_Data_Select_By_Id(id.ToLong()).SingleOrDefault();
                dataInfo = dataInfo ?? new Bank.usp_Data_Select_By_IdResult();
                return new
                {
                    Result = true,
                    title = dataInfo.D_Title,
                    active = dataInfo.D_Active,
                    state = (dataInfo.D_StateId ?? 0).ToCodeNumber(),
                    defaultsms = dataInfo.D_DefaultSMSText,
                    desc = dataInfo.D_Desc,
                    typeId = dataInfo.D_TypeId.ToCodeNumber(),
                    pari = dataInfo.D_Priority == null ? "" : dataInfo.D_Priority.Value.ToString(),
                    systematic = dataInfo.D_Systematic,
                    dataInfo.D_SmsKeys,
                    dataInfo.D_Show_SendFor_Men_Or_Women,
                    dataInfo.D_SendForMen,
                    dataInfo.D_SendForWomen,
                    dataInfo.D_DurationForSend,
                    dataInfo.D_Desc_For_DurationForSend,
                    dataInfo.D_ShowDurationForSend,
                    ShowDescForUser = !dataInfo.D_DescForUser.IsNullOrEmpty() && dataInfo.D_DescForUser.Trim().Length > 0,
                    dataInfo.D_DescForUser
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
        [WebMethod]
        public static dynamic AddEditData(string id, string typeId, string title, bool active, string desc, string defulatsms, string state, string pari, bool SendForWomen, bool SendForMen, string DurationForSend)
        {
            try
            {
                typeId = typeId.ToDecodeNumber();
                state = state.ToDecodeNumber();
                id = id.ToDecodeNumber();

                bool IsEdit = id.ToLong() > 0;
                usp_Data_Select_By_IdResult dataInfo = null;
                if (IsEdit)
                {
                    dataInfo = AdakDB.Db.usp_Data_Select_By_Id(id.ToLong()).SingleOrDefault();
                }

                if (typeId.IsNullOrEmpty() || typeId.ToInt() <= 0)
                {
                    return new
                    {
                        Result = false,
                        Message = "نوع داده را مشخص کنید"
                    };
                }
                if (title.Trim().IsNullOrEmpty())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا عنوان را مشخص کنید"
                    };
                }
                if ((dataInfo != null && (dataInfo.D_ShowDurationForSend ?? false)))
                {
                    if (DurationForSend != null && !DurationForSend.IsNumber())
                    {
                        return new
                        {
                            Result = false,
                            Message = "لطفا زمان ارسال را به درستی وارد کنید"
                        };
                    }
                    if (DurationForSend != null && DurationForSend.ToInt() > 1000)
                    {
                        return new
                        {
                            Result = false,
                            Message = "لطفا زمان ارسال را کمتر از 1000 وارد کنید"
                        };
                    }
                }
                var b = AdakDB.Db;
                int? hasError = 0;
                long? resultId = 0;
                string mes = "";
                if (id.IsNullOrEmpty() || id.ToInt() == 0)
                {
                    b.usp_Data_Add(title, active, state.ToLong(), typeId.ToInt(), desc, defulatsms, 1, ref mes, ref hasError, ref resultId, pari.ToInt(), (DurationForSend == null ? 0 : DurationForSend.ToInt()), SendForMen, SendForWomen);
                }
                else
                {
                    b.usp_Data_Edit(id.ToLong(), title, active, state.ToLong(), typeId.ToInt(), desc, defulatsms, 1, ref mes, ref hasError, pari.ToInt(), (DurationForSend == null ? 0 : DurationForSend.ToInt()), SendForMen, SendForWomen);
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
        public static dynamic ChangeType(string typeId)
        {
            try
            {
                typeId = typeId.ToDecodeNumber();
                var cs = ConfigurationManager.ConnectionStrings["J_AdakStudioConnectionString"]?.ConnectionString;
                Bank.AdakBankDataContext b = new Bank.AdakBankDataContext(cs);
                var dtype = b.usp_DataType_Select_By_Id(typeId.ToInt()).SingleOrDefault();
                if (dtype == null)
                {
                    return new
                    {
                        Result = false,
                        ShowDefaultSMS = false,
                        ShowState = false,
                        ShowPriority = false,
                        Show_SendFor_Men_Or_Women = false
                    };
                }
                return new
                {
                    Result = true,
                    ShowDefaultSMS = (dtype.DT_ShowDefaultSMS ?? false),
                    ShowState = (dtype.DT_ShowState ?? false),
                    ShowPriority = (dtype.DT_ShowPariority ?? false),
                    Show_SendFor_Men_Or_Women = typeId.ToInt() == DefaultDataIDs.DataType_FactorStatus,
                    DefaultSMS = "خانواده {{عنوان خانواده}} عزیز " + Environment.NewLine + " سفارش شما در مرحله {{عنوان وضعیت}} قرار گرفته است"
                };

            }
            catch (Exception ex)
            {
                return new
                {
                    Result = false,
                    ShowDefaultSMS = false,
                    ShowState = false,
                    ShowPriority = false,
                    Show_SendFor_Men_Or_Women = false
                };
            }

        }
        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string searchText, string typeId)
        {
            perPage = perPage == 0 ? 10 : perPage;
            searchText = searchText.Trim();
            int? countt = 0;
            typeId = typeId.ToDecodeNumber();
            var data = AdakDB.Db.usp_Data_Select_For_Grid(searchText, typeId.ToInt(), ref countt, page, perPage).ToList();
            data = data ?? new List<Bank.usp_Data_Select_For_GridResult>();
            List<BasicDataForGrid> list = new List<BasicDataForGrid>();
            string TextAfterPrice = Settings.TextAfterPrice;
            data.ForEach(x => list.Add(new BasicDataForGrid()
            {
                Title = x.D_Title,
                Desc = x.D_Desc.IsNullOrEmpty() ? "" : x.D_Desc,
                TypeTitle = x.TypeTitle,
                Priority = x.D_Priority == null ? "---" : x.D_Priority.ToString(),
                Status = x.D_Active ? "<div class='badge badge-light-success'>فعال</div>" : "<div class='badge badge-light-danger'>غیرفعال</div>",
                Actions = @"
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_add_customer' onclick='EditBasicData(""" + x.D_Id.ToCodeNumber() + @""")' title='ویرایش'>✎</button>
                        " + (!x.D_Systematic ? @"<button class='btnDataTable btnDataTable-delete' onclick='DeleteBasicData(""" + x.D_Id.ToCodeNumber() + @""")' title='حذف'>🗑</button>" : "")+@"
                </div>
                "
            })); ; ;


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
    public class BasicDataForGrid
    {
        public string Title { get; set; }
        public string Desc { get; set; }
        public string TypeTitle { get; set; }
        public string Status { get; set; }
        public string Priority { get; set; }
        public string Actions { get; set; }

    }

}