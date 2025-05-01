using System.Web;

public class SpecialStudio
{
    public static string Logo
    {
        get
        {
            string name = HttpContext.Current.Request.Url.Host;
            if (string.IsNullOrEmpty(name))
                name = "logo";
            return $"Files/Logo/{name}.png";
        }
    }
}