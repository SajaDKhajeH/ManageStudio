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
    }
    
}