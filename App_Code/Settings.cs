﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Settings
/// </summary>
public class Settings
{
    public static bool IsToman
    {
        get
        {
            var isToman = AdakDB.Db.usp_Setting_Select_By_Key("IsToman").SingleOrDefault();
            return isToman == null ? false : isToman.Se_Value == "1";
        }
    }
    public static string TextAfterPrice
    {
        get
        {
            var TextAfterPrice = AdakDB.Db.usp_Setting_Select_By_Key("TextAfterPrice").SingleOrDefault();
            return TextAfterPrice == null ? "ریال" : TextAfterPrice.Se_Value;
        }
    }
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
}