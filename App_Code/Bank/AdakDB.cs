using System.Collections.Generic;
using System.Configuration;
using System.Web;
public class AdakDB
{
    public static Bank.AdakBankDataContext Db
    {
        get
        {
            var domainName = HttpContext.Current?.Request.Url.Host;
            AdakLogger.Log.Warning(domainName);
            var cs = ConfigurationManager.ConnectionStrings[domainName]?.ConnectionString;
            return new Bank.AdakBankDataContext(cs);
        }
    }
    public static Bank.AdakBankDataContext GetDb(string cs)
    {
        return new Bank.AdakBankDataContext(cs);
    }
    public static List<string> ConnectionStrings
    {
        get
        {
            List<string> connectionStrings = new List<string>();
            foreach (var cs in ConfigurationManager.ConnectionStrings)
            {
                if (cs.ToString().Contains(@"SQLEXPRESS;Integrated Security=SSPI;AttachDBFilename=|DataDirectory|aspnetdb.mdf;User Instance=true"))
                    continue;
                AdakLogger.Log.Warning(cs.ToString());
                connectionStrings.Add(cs.ToString());
            }
            return connectionStrings;
        }
    }
}