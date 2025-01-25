<%@ Application Language="C#" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        System.Web.Http.GlobalConfiguration.Configure(WebApiConfig.Register);
        RouteConfig.RegisterRoutes(System.Web.Routing.RouteTable.Routes);
    }
    void Application_End(object sender, EventArgs e)
    {
       
    }
    void Application_Error(object sender, EventArgs e)
    {
     
    }
    void Session_Start(object sender, EventArgs e)
    {
    }
    void Session_End(object sender, EventArgs e)
    {
       
    }
void Application_BeginRequest(Object sender, EventArgs e)
    {
        var c = HttpContext.Current.Request?.Cookies;
        var cc = c["Authorization"];
        string token = null;
        if (!string.IsNullOrEmpty(cc?.Value))
        {
            token = cc.Value.ToString();
        }
        var header = Request.Headers["Authorization"];
        if (header == null && !string.IsNullOrEmpty(token))
        {
            Request.Headers.Add("Authorization", token);
        }

    }
    void Application_EndRequest(Object sender, EventArgs e)
    {
       
    }
</script>
