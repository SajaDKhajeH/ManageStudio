using System.Configuration;
public class AdakDB
{
    public static Bank.AdakBankDataContext Db
    {
        get
        {
            var cs = ConfigurationManager.ConnectionStrings["J_AdakStudioConnectionString"]?.ConnectionString;
            Bank.AdakBankDataContext b = new Bank.AdakBankDataContext(cs);
            return b;
        }
    }
}