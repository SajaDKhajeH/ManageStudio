using Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web.Services;
using System.Web.UI.WebControls;
public partial class Permission : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static dynamic GetPermissions(long id)
    {
        if (id <= 0)
        {
            return new
            {
                Result = false,
                Message = "شناسه پرسنل مشخص نیست"
            };
        }
        var db = AdakDB.Db;
        var permissions = AdakDB.Db.usp_Page_Select(id).ToList();
        permissions = permissions ?? new List<Bank.usp_Page_SelectResult>();
        string Pages = "";
        foreach (var pa in permissions)
        {
            Pages += @"<div class='form-check custom-checkbox'>
                     <input class='form-check-input access-checkbox' name='PagesPermission' type='checkbox' id='" + pa.P_Id + @"' " + (pa.HasPermission == 1 ? "checked" : "") + @">
                     <label class='form-check-label' for='dashboard'>" + pa.P_Title + @"</label>
                </div>";
        }

        return new
        {
            Result = true,
            Pages
        };
    }

    [WebMethod]
    public static dynamic SavePermission(long personnelId, string pageIds)
    {
        if (personnelId <= 0)
        {
            return new
            {
                Result = false,
                Message = "شناسه پرسنل مشخص نیست"
            };
        }
        AdakDB.Db.usp_Permission_Add(personnelId, pageIds, LoginedUser.Id);
        return new
        {
            Result = true,
        };
    }
}