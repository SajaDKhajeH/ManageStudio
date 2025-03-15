using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Permission : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public static string GetPersonnels()
    {
        string htmls = "<option>انتخاب نوع</option>";
        var dataType = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Secretary).ToList();
        dataType = dataType ?? new List<Bank.usp_Personnel_By_RoleResult>();
        foreach (var item in dataType)
        {
            htmls += "<option value='" + item.DT_ID.ToCodeNumber() + "'>" + item.DT_Title + "</option>";
        }
        return htmls;
    }
}