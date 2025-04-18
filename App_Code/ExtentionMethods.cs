using System;
using System.Linq;
using System.Web;

public static class ExtentionMethods
{
    public static string ToPersianPrice(this decimal p)
    {
        long price = (long)p;
        return $"{price.ToString("#,#").ToPersianNumber()} ریال";
    }
    public static void AddLog(this Exception ex)
    {
        AddLog(ex, null);
    }
    public static void AddLog(this Exception ex, string desc)
    {
        Console.WriteLine(ex.ToString());
    }
    public static string OrDefault(this string str, string defaultStr)
    {
        if (string.IsNullOrEmpty(str))
            return defaultStr;
        return str;
    }
    public static void SetCORSOrigin(this HttpResponse response)
    {
        try
        {
            if (response.Headers.AllKeys.Any(x => x == "Access-Control-Allow-Origin"))
            {
                response.Headers["Access-Control-Allow-Origin"] = "*";
            }
            else
            {
                response.Headers.Add("Access-Control-Allow-Origin", "*");
            }
            if (response.Headers.AllKeys.Any(x => x == "Access-Control-Allow-Methods"))
            {
                response.Headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS";
            }
            else
            {
                response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
            }
            if (response.Headers.AllKeys.Any(x => x == "Access-Control-Allow-Headers"))
            {
                response.Headers["Access-Control-Allow-Headers"] = "*";
            }
            else
            {
                response.Headers.Add("Access-Control-Allow-Headers", "*");
            }
            //
        }
        catch { }
    }
}