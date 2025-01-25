using Microsoft.AspNet.FriendlyUrls;
using System.Web.Routing;

/// <summary>
/// Summary description for RouteConfig
/// </summary>
public static class RouteConfig
{

    public static void RegisterRoutes(RouteCollection routes)
    {
        var settings = new FriendlyUrlSettings();
        settings.AutoRedirectMode = RedirectMode.Permanent;
        routes.EnableFriendlyUrls(settings);
    }
}