using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;


namespace AdakStudio
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        
        [WebMethod]
        public static dynamic RegenerateCaptchaImage()
        {
            var ak = Captcha.CreateAuthKey();
            return new { ak_ID = ak.ID.ToCodeNumber(), src = ak.CaptchaImage };
        }
        public string CaptchaImage()
        {
            string result = "";
            var ak = Captcha.CreateAuthKey();
            result += @"<img id=""captcha59"" class=""border mb-1"" ak_ID=""" + ak.ID.ToCodeNumber() + @""" src=""" + ak.CaptchaImage + @""" />";
            return result;
        }
        [WebMethod]
        public static dynamic MobileValidation(string captchaID, string mobile, string captchaCode)
        {
            try
            {
                int acceptCode = 0;
                if (mobile.IsNullOrEmpty() || !mobile.IsMobileNumber())
                {
                    return new
                    {
                        Success = false,
                        ErrorMessage = "شماره همراه را بدرستی وارد کنید",
                        Id = "mobile"
                    };
                }
                #region چک کردن اینکه شماره همراه در سامانه وجود دارد یا نه
                mobile = mobile.ToEnglishNumber();
                var mobileCheck = AdakDB.Db.usp_Family_Check_By_Mobile(mobile).SingleOrDefault();
                if (mobileCheck == null)
                {
                    return new
                    {
                        Success = false,
                        ErrorMessage = "شماره همراه وارد شده در سامانه وجود ندارد",
                        Id = "mobile"
                    };
                }
                else if (mobileCheck.F_Archive)
                {
                    return new
                    {
                        Success = false,
                        ErrorMessage = "اکانت شما غیرفعال شده است و امکان ورود به سامانه برای شما وجود ندارد",
                        Id = "mobile"
                    };
                }
                #endregion
                captchaCode = captchaCode.ToEnglishNumber();
                if (!Captcha.CheckAuthKey((captchaID.IsNullOrEmpty() || captchaID == "0" ? "0" : captchaID).ToDecodeNumber(), captchaCode))
                {
                    return new
                    {
                        Success = false,
                        ErrorMessage = "کد تائید را اشتباه وارد کرده اید",
                        Id = "txtCaptchaCode"
                    };
                }
                else
                {
                    HttpContext.Current.Session.Add("CaptchaID", captchaID.ToCodeNumber());
                }

                Random random = new Random();
                acceptCode = random.Next(1000, 9999);
                string text = "کد تایید: " + acceptCode + " \r\n ورود به سامانه محیا";

                //acceptCode = 1234;
                HttpContext.Current.Session.Add("AcceptCode", acceptCode.ToCodeNumber());
                HttpContext.Current.Session.Add("PhoneNumber", mobile);
                string message = "";
                SetSMS.Send(text, mobile, ref message);

                return new { Success = true, acceptCode };
            }
            catch (Exception ex)
            {
                AdakDB.Db.usp_ErrorAdd("Catch=>MobileValidation", ex.Message);
                return new { E = true, EM = "خطا در بازیابی اطلاعات" };
            }
        }
    }

}