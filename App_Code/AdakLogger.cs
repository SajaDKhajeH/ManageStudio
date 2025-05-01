using Serilog;
using Serilog.Formatting.Json;
using System.IO;
using System.Web;

public interface IAdakLogger
{
    void Error<T>(T obj);
    void Information<T>(T obj);
}
public class AdakLogger : IAdakLogger
{
    public static AdakLogger Log = new AdakLogger();
    private static ILogger _logger;
    public static bool Init(string baseDirectory)
    {
        var j = new JsonFormatter();
        string p = Path.Combine(baseDirectory, $"logs/l-.log");
        long fileSizeLimitBytes = 16777216;//16 mb
        _logger = new LoggerConfiguration()
            .WriteTo.File(formatter: j, path: p, rollingInterval: RollingInterval.Day, retainedFileCountLimit: 7, fileSizeLimitBytes: fileSizeLimitBytes)
            .CreateLogger();
        return true;
    }

    public void Error<T>(T obj)
    {
        _logger?.Error("{@j}:", new
        {
            obj,
            appName = HttpContext.Current?.Request.Url.Host
        });
    }

    public void Information<T>(T obj)
    {
        _logger?.Information("{@j}:", new
        {
            obj,
            appName = HttpContext.Current?.Request.Url.Host
        });
    }
    public void Warning<T>(T obj)
    {
        _logger?.Warning("{@j}:", new
        {
            obj,
            appName = HttpContext.Current?.Request.Url.Host
        });
    }
}