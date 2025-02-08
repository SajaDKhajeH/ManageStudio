using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Web;
using System.Web.Http;

/// <summary>
/// Summary description for LoginController
/// </summary>
public class LoginController : ApiController
{
    [HttpPost, Route("Api/Login/Login")]
    public OperationResult Login([FromBody] LoginModel model)
    {
        try
        {
            if (model == null)
            {
                return new OperationResult
                {
                    Success = false,
                    Message = "اطلاعات فرستاده نشده است"
                };
            }
            //چک کردن نام کاربری و رمز عبور برای زمانی که پرسنل میخوان وارد بشن
            if (model.LoginPersonnel && (model.UserName.IsNullOrEmpty() || model.Password.IsNullOrEmpty()))
            {
                return new OperationResult
                {
                    Success = false,
                    Message = "لطفا نام کاربری و رمز عبور را بدرستی وارد کنید"
                };
            }
            //چک کردن شماره همراه برای زمانی که خانواده ها میخوان وارد بشن
            if (!model.LoginPersonnel && (model.Mobile.IsNullOrEmpty() || !model.Mobile.IsMobileNumber()))
            {
                return new OperationResult
                {
                    Success = false,
                    Message = "لطفا شماره همراه را بدرستی وارد کنید"
                };
            }
            long LoginId = 0;
            long RoleId = 0;
            string LoginName = "";
            if (model.LoginPersonnel)
            {
                #region ورود پرسنل
                var PersonnelInfo = AdakDB.Db.usp_Login(model.UserName, model.Password).SingleOrDefault();
                if (PersonnelInfo == null)
                {
                    return new OperationResult
                    {
                        Success = false,
                        Message = "نام کاربری یا رمز عبور اشتباه هست"
                    };
                }
                if (!PersonnelInfo.P_Active)
                {
                    return new OperationResult
                    {
                        Success = false,
                        Message = "اکانت شما غیرفعال شده است"
                    };
                }
                LoginId = PersonnelInfo.P_Id;
                RoleId = PersonnelInfo.P_RoleId;
                LoginName = PersonnelInfo.P_Name + " " + PersonnelInfo.P_LastName;
                #endregion
            }
            else
            {
                #region ورود خانواده ها
                var family = AdakDB.Db.usp_Family_Check_By_Mobile(model.Mobile).SingleOrDefault();
                if (family == null)
                {
                    return new OperationResult
                    {
                        Success = false,
                        Message = "شماره همراه وارد شده در سامانه وجود ندارد"
                    };
                }
                if (family.F_Archive)
                {
                    return new OperationResult
                    {
                        Success = false,
                        Message = "اکانت شما غیرفعال شده است و امکان ورود به سامانه برای شما وجود ندارد"
                    };
                }
                LoginId = family.F_ID;
                RoleId = -1;
                LoginName = family.F_Title;
                #endregion
            }
            string issuer = ConfigurationSettings.AppSettings["PortalUrl"];
            var key = "aeufukywegiubsfwviwbsrilbswvgserivgf";
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var permClaims = new List<Claim>();
            permClaims.Add(new Claim(AdakClaimTypes.Id, LoginId.ToString()));
            permClaims.Add(new Claim(AdakClaimTypes.Role, RoleId.ToString()));
            permClaims.Add(new Claim(AdakClaimTypes.Name, LoginName));

            string GoToPage = "";
            if (RoleId == DefaultDataIDs.Role_PhotographerInHospital)
            {
                GoToPage = "AddFamilyFromHospital.aspx";
            }
            else if (RoleId == DefaultDataIDs.Role_Admin || RoleId == DefaultDataIDs.Role_Secretary)
            {
                GoToPage = "Dashboard.aspx";
            }
            else if (RoleId == DefaultDataIDs.Role_Designer || RoleId == DefaultDataIDs.Role_DesignSupervisor)
            {
                GoToPage = "RequestStatus.aspx";
            }
            // اگر خانواده بود فقط صفحه مربوط به سفارش های خانواده رو بتونه ببینه و پرداخت آنلاین داشته باشه
            else if (RoleId == DefaultDataIDs.Role_Family)
            {
                GoToPage = "CustomerOrders.aspx";
            }

            var token = new JwtSecurityToken(issuer, //Issure    
                            issuer,  //Audience    
                            permClaims,
                            expires: DateTime.Now.AddYears(1),
                            signingCredentials: credentials);
            var jwt_token = new JwtSecurityTokenHandler().WriteToken(token);
            //HttpContext.Current.Response.Headers.Add("Token", jwt_token);
            var a = new HttpCookie("Authorization", "Bearer " + jwt_token);
            a.Expires = DateTime.Now.AddMonths(1);
            HttpContext.Current.Response.Cookies.Add(a);
            return new OperationResult
            {
                Success = true,
                Message = GoToPage
            };
        }
        catch (Exception ex)
        {
            return new OperationResult { Success = false, Message = "خطایی در سمت سرور رخ داده لطفاً خطا را گزارش فرمایید" };
        }
    }

}