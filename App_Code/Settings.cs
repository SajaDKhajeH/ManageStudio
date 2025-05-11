using System.Linq;

/// <summary>
/// Summary description for Settings
/// </summary>
public class Settings
{
    
    public static string StudioName
    {
        get
        {
            return AdakDB.Db.usp_Setting_Select_By_Key(DefaultDataIDs.Setting_Studio_Name).SingleOrDefault().Se_Value;
        }
    }
    public static string Website_Url
    {
        get
        {
            var website_URL = AdakDB.Db.usp_Setting_Select_By_Key("Website_URL").SingleOrDefault();
            return website_URL?.Se_Value ?? "";
        }
    }
    public static string Path_SaveReports
    {
        get
        {
            var Path_SaveReports = AdakDB.Db.usp_Setting_Select_By_Key("Path_SaveReports").SingleOrDefault();
            return Path_SaveReports == null ? "" : Path_SaveReports.Se_Value;
        }
    }

    public static string TextAfterPrice { get; set; }
}