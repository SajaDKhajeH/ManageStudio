using Stimulsoft.Report;
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
        Report.RegData("Data", data);
        return this;
    }
    public AdakStiReportBuilder WithVaiables(Dictionary<string, string> variables)
    {
        foreach (var variable in variables)
        {
            Report.Dictionary.Variables[variable.Key].Value = variable.Value;
        }
        return this;
    }
    public bool SaveImage(string path)
    {
        Report.RegReportDataSources();
        Report.Compile();
        Report.Render();
        using (MemoryStream ms = new MemoryStream())
        {
            Report.ExportDocument(StiExportFormat.Image, ms);
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
        }
        Report.Dispose();
        return true;
    }
    public bool SavePNG(string path)
    {
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
}