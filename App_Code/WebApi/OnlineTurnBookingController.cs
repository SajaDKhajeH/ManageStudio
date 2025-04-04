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

public class OnlineTurnBookingController : ApiController
{
    [HttpGet, Route("Api/OnlineTurnBooking/Get_Package")]
    public IHttpActionResult Get_Package()
    {
        var list = AdakDB.Db.usp_OnlineTurnSettings_For_Website().ToList().
                Select(x => new { Id = x.SettingId, Title = x.Title, FilePath = x.FilePath, Amount = x.DepositAmount, Desc = x.Desc }).ToList();
        return Json(list);
    }
    [HttpGet, Route("Api/OnlineTurnBooking/Get_Times")]
    public IHttpActionResult Get_Times(long Id)
    {
        var list = AdakDB.Db.usp_OnlineTurnSettings_GetTimes_ForWebsite(Id).ToList().
                Select(x => new { Date = x.DateS, Time = x.StartTime, x.Reserved }).ToList();
        return Json(list);
    }
}