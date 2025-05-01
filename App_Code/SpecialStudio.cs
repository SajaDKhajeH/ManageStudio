using System.Web;

public class SpecialStudio
{
    public static string Logo
    {
        get
        {
            string name = HttpContext.Current.Request.Url.Host;
            if (string.IsNullOrEmpty(name))
                name = "unknown";
            return $"Files/{name}/Logo/logo.png";
        }
    }
}