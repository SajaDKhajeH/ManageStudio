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
            if (model.UserName.IsNullOrEmpty() || model.Password.IsNullOrEmpty())
            {
                return new OperationResult
                {
                    Success = false,
                    Message = "لطفا ورودی ها را وارد نمایید"
                };
            }

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
            string issuer = ConfigurationSettings.AppSettings["PortalUrl"];
            var key = "aeufukywegiubsfwviwbsrilbswvgserivgf";
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var permClaims = new List<Claim>();
            permClaims.Add(new Claim(AdakClaimTypes.Id, PersonnelInfo.P_Id.ToString()));
            permClaims.Add(new Claim(AdakClaimTypes.Role, PersonnelInfo.P_RoleId.ToString()));
            permClaims.Add(new Claim(AdakClaimTypes.Name, PersonnelInfo.P_Name + " " + PersonnelInfo.P_LastName));

            string GoToPage = "";
            if (PersonnelInfo.P_RoleId == DefaultDataIDs.Role_PhotographerInHospital)
            {
                GoToPage = "AddFamilyFromHospital.aspx";
            }
            else if (PersonnelInfo.P_RoleId == DefaultDataIDs.Role_Admin || PersonnelInfo.P_RoleId == DefaultDataIDs.Role_Secretary)
            {
                GoToPage = "Dashboard.aspx";
            }
            else if (PersonnelInfo.P_RoleId == DefaultDataIDs.Role_Designer || PersonnelInfo.P_RoleId == DefaultDataIDs.Role_DesignSupervisor)
            {
                GoToPage = "RequestStatus.aspx";
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