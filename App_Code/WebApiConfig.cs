//using Microsoft.Owin.Security.OAuth;
using System.Web.Http;

/// <summary>
/// Summary description for WebApiConfig
/// </summary>
public static class WebApiConfig
{
    public static void Register(HttpConfiguration config)
    {
  

        config.MapHttpAttributeRoutes();

        config.Routes.MapHttpRoute(
            name: "DefaultApi",
            routeTemplate: "api/{controller}/{id}",
            defaults: new { id = RouteParameter.Optional }
        );

        //config.Routes.MapHttpRoute(
        //    name: "StudentApi",
        //    routeTemplate: "api/Student/{controller}/{id}",
        //    defaults: new { cootroller = "StudentController", id = RouteParameter.Optional }
        //);
        //config.MapHttpAttributeRoutes();
        //config.Routes.MapHttpRoute("DefaultAPI", "api/{contoroller}/{id}", defaults: new { id = RouteParameter.Optional });
    }
}