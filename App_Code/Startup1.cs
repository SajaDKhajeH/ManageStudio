using Microsoft.IdentityModel.Tokens;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Jwt;
using Owin;
using System;
using System.Configuration;
using System.Text;

[assembly: OwinStartup(typeof(Startup1))]

public class Startup1
{
    public void Configuration(IAppBuilder app)
    {
        //if is not local
        SmsSender.Instance.BeginSend();
        #region JWT
        //string portalUrl = ConfigurationSettings.AppSettings["PortalUrl"];
        //string portalUrl = new StringBuilder()
        //   .Append(HttpContext.Current.Request.Url.Scheme)
        //   .Append("://")
        //   .Append(HttpContext.Current.Request.Url.Authority)
        //   .Append(HttpContext.Current.Request.ApplicationPath.TrimEnd('/'))
        //   .ToString();
        string portalUrl = ConfigurationSettings.AppSettings["PortalUrl"];
        var key = "aeufukywegiubsfwviwbsrilbswvgserivgf";
        app.UseJwtBearerAuthentication(
                new JwtBearerAuthenticationOptions
                {
                    AuthenticationMode = AuthenticationMode.Active,
                    TokenValidationParameters = new TokenValidationParameters()
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = portalUrl, //some string, normally web url,  
                        ValidAudience = portalUrl,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key))
                    }
                });
        #endregion

        //TestMethods();
    }
}
