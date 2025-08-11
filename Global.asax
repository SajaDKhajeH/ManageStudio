<%@ Application Language="C#" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        RouteConfig.RegisterRoutes(System.Web.Routing.RouteTable.Routes);
        MyHttpClient.Init();
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
        
    }
    void Application_EndRequest(Object sender, EventArgs e)
    {

    }
</script>
