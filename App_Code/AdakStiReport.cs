using Stimulsoft.Report;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

public class AdakStiReportBuilder
{
    StiReport Report;
    public static AdakStiReportBuilder WithName(string name)
    {
        AdakStiReportBuilder builder = new AdakStiReportBuilder();
        builder.Report = new StiReport();
        builder.Report.Load(HttpContext.Current.Server.MapPath("Files/Reports/" + name));
        #region Crack
        if (!File.Exists(HttpContext.Current.Server.MapPath("Stimulsoft/account.dat")))
            File.Copy(HttpContext.Current.Server.MapPath("Files/Reports/StiCrack/account.dat"),
                HttpContext.Current.Server.MapPath("Stimulsoft/account.dat"), true);
        if (!File.Exists(HttpContext.Current.Server.MapPath("Stimulsoft/license.key")))
            File.Copy(HttpContext.Current.Server.MapPath("Files/Reports/StiCrack/license.key"),
                HttpContext.Current.Server.MapPath("Stimulsoft/license.key"), true);
        #endregion

        return builder;
    }
    public AdakStiReportBuilder WithData(object data)
    {
        try
        {
            Report.RegData("Data", data);
            return this;
        }
        catch (System.Exception ex)
        {

            AdakDB.Db.usp_ErrorAdd("AdakStiReportBuilder WithData", ex.Message);
            return null;
        }
    }
    public AdakStiReportBuilder WithVaiables(Dictionary<string, string> variables)
    {
        string key = "";
        try
        {
            foreach (var variable in variables)
            {
                key = variable.Key;
                Report.Dictionary.Variables[variable.Key].Value = variable.Value;
            }
        }
        catch (System.Exception ex)
        {
            AdakDB.Db.usp_ErrorAdd("AdakStiReportBuilder WithVaiables" + " =>" + key, ex.Message);
        }
        return this;
    }
    public bool SaveImage(string path)
    {
        try
        {
            path = GetSpecialPath(path);
            Report.RegReportDataSources();
            Report.Compile();
            Report.Render();
            using (MemoryStream ms = new MemoryStream())
            {
                Report.ExportDocument(StiExportFormat.Image, ms);
                if (File.Exists(HttpContext.Current.Server.MapPath(path)))
                {
                    File.Delete(HttpContext.Current.Server.MapPath(path));
                }
                File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
            }
            Report.Dispose();

            return true;
        }
        catch (System.Exception ex)
        {
            AdakDB.Db.usp_ErrorAdd("AdakStiReportBuilder SaveImage", ex.Message);
            return false;
        }
    }
    public bool SavePNG(string path)
    {
        path = GetSpecialPath(path);
        Report.RegReportDataSources();
        Report.Compile();
        Report.Render();
        using (MemoryStream ms = new MemoryStream())
        {
            Report.ExportDocument(StiExportFormat.ImagePng, ms);
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
        }
        Report.Dispose();
        return true;
    }
    public bool SavePDF(string path)
    {
        path = GetSpecialPath(path);
        Report.RegReportDataSources();
        Report.Compile();
        Report.Render();
        using (MemoryStream ms = new MemoryStream())
        {
            Stimulsoft.Report.Export.StiPdfExportSettings pdfExportSettings = new Stimulsoft.Report.Export.StiPdfExportSettings
            {
                EmbeddedFonts = true, // تعبیه فونت
            };
            Report.ExportDocument(StiExportFormat.Pdf, ms, pdfExportSettings);
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
        }
        Report.Dispose();
        return true;
    }
    public bool SaveExcel(string path)
    {
        path = GetSpecialPath(path);
        Report.RegReportDataSources();
        Report.Compile();
        Report.Render();
        using (MemoryStream ms = new MemoryStream())
        {
            Report.ExportDocument(StiExportFormat.Excel2007, ms);
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
        }
        Report.Dispose();
        return true;
    }
    private string GetSpecialPath(string path)
    {
        string name = HttpContext.Current?.Request.Url.Host;
        if (string.IsNullOrEmpty(name))
        {
            name = "unknown";
        }
        path = path.Replace("Files/", $"Files/{name}/");
        return path;
    }
}