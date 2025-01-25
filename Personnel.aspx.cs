using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class Personnel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role!=DefaultDataIDs.Role_Admin)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }

        [WebMethod]
        public static dynamic DeletePersonnel(string id)
        {
            try
            {
                if (id.ToLong()<=0)
                {
                    return new
                    {
                        Result = false,
                        Message = "شناسه کاربر مشخص نیست"
                    };
                }
                string mes = "";
                int? hasError = 0;
                AdakDB.Db.usp_Personnel_Delete(id.ToLong(), LoginedUser.Id, ref mes, ref hasError);
                return new
                {
                    Result = hasError == 0,
                    Message = mes.IsNullOrEmpty() && hasError == 0 ? "حذف با موفقیت انجام شد" : (mes.IsNullOrEmpty() && hasError == 1 ? "خطایی در حذف اطلاعات رخ داده است" : mes)
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
        public static dynamic EditPersonnel(string id)
        {
            try
            {
                id = id.ToDecodeNumber();
                if (id.IsNullOrEmpty() || id == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "شناسه کاربر مشخص نیست"
                    };
                }
                var pInfo = AdakDB.Db.usp_Personnel_Select_By_Id(id.ToLong()).SingleOrDefault();
                pInfo = pInfo ?? new Bank.usp_Personnel_Select_By_IdResult();
                return new
                {
                    Result = true,
                    roleId = pInfo.P_RoleId.ToCodeNumber(),
                    firstname = pInfo.P_Name,
                    lastname = pInfo.P_LastName,
                    mobile = pInfo.P_Mobile,
                    pass = pInfo.P_Password,
                    username = pInfo.UserName,
                    phone = pInfo.P_Phone,
                    address = pInfo.P_Address,
                    maxdiscount = pInfo.P_MaxPercentForSetDiscount ?? 0,
                    desc = pInfo.P_Desc,
                    sex = pInfo.P_Sex,
                    active = pInfo.P_Active
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
        public static dynamic ChangeRole(string roleid)
        {
            try
            {
                roleid = roleid.ToDecodeNumber();
                if (roleid.IsNullOrEmpty() || roleid == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "نقش مشخص نیست"
                    };
                }
                if (roleid == "4" || roleid == "5")
                {
                    return new
                    {
                        Result = true,
                        showCall_A_discount = true
                    };
                }
                return new
                {
                    Result = true,
                    showCall_A_discount = false
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
        public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string searchText)
        {
            perPage = perPage == 0 ? 10 : perPage;
            searchText = searchText.Trim();
            int? countt = 0;
            var data = AdakDB.Db.usp_Personnel_Select_For_Grid(searchText, ref countt, page, perPage).ToList();
            data = data ?? new List<Bank.usp_Personnel_Select_For_GridResult>();
            List<PersonnelForGrid> list = new List<PersonnelForGrid>();
            string TextAfterPrice = Settings.TextAfterPrice;
            data.ForEach(x => list.Add(new PersonnelForGrid()
            {
                FullName = x.FullName,
                RoleTitle = x.RoleTitle,
                Mobile = x.P_Mobile.IsNullOrEmpty() ? "" : x.P_Mobile,
                Username = x.UserName.IsNullOrEmpty() ? "" : x.UserName,
                Status = x.P_Active ? "<div class='badge badge-light-success'>فعال</div>" : "<div class='badge badge-light-danger'>غیرفعال</div>",
                Actions = @"

                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_add_personnel' onclick='EditPerseonnel(""" + x.P_Id.ToCodeNumber() + @""")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='DeletePersonnel(""" + x.P_Id + @""")' title='حذف'>🗑</button>
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
        [WebMethod]
        public static dynamic AddEditPersonnel(string id, string RoleId, string firstname, bool sex, bool active, string desc, string lastname, string mobile, string phone, string username, string pass, string maxdiscount, string address, bool showpopup)
        {
            try
            {
                RoleId = RoleId.ToDecodeNumber();
                id = id.ToDecodeNumber();
                if (RoleId.IsNullOrEmpty() || RoleId.ToInt() <= 0)
                {
                    return new
                    {
                        Result = false,
                        Message = "نقش را مشخص کنید"
                    };
                }
                if (firstname.Trim().IsNullOrEmpty())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا نام را مشخص کنید"
                    };
                }
                if (lastname.Trim().IsNullOrEmpty())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا نام خانوادگی را مشخص کنید"
                    };
                }
                if (!mobile.IsNullOrEmpty() && !mobile.IsMobileNumber())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا شماره همراه را بدرستی وارد کنید"
                    };
                }
                if (maxdiscount.IsNullOrEmpty())
                {
                    maxdiscount = "0";
                }
                int? hasError = 0;
                long? resultId = 0;
                long? CauserID = LoginedUser.Id;
                string mes = "";
                if (id.IsNullOrEmpty() || id.ToInt() == 0)
                {
                    AdakDB.Db.usp_Personnel_Add(firstname, lastname, sex, null, showpopup, mobile, phone, address, desc, active, username, pass, maxdiscount.ToInt(), RoleId.ToLong(), CauserID, ref mes, ref hasError, ref resultId);
                }
                else
                {
                    AdakDB.Db.usp_Personnel_Edit(id.ToLong(), firstname, lastname, sex, null, showpopup, mobile, phone, address, desc, active, username, pass, maxdiscount.ToInt(), RoleId.ToLong(), CauserID, ref mes, ref hasError);
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

    }
    public class PersonnelForGrid
    {
        public string FullName { get; set; }
        public string RoleTitle { get; set; }
        public string Mobile { get; set; }
        public string Username { get; set; }
        public string Status { get; set; }
        public string Actions { get; set; }

    }
}