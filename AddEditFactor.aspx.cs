using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddEditFactor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (LoginedUser.Role != DefaultDataIDs.Role_Admin && LoginedUser.Role != DefaultDataIDs.Role_Secretary)
        {
            Response.Redirect("Logout.aspx");
        }
    }


}