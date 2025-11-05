using Stimulsoft.Base;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

public class StartUpCodes
{
    public static void RegisterCustomFonts()
    {
        var basePath = Path.Combine(AppContext.BaseDirectory, "Files", "Fonts");

        var fonts = Directory.GetFiles(basePath);
        foreach (var font in fonts)
        {
            StiFontCollection.AddFontFile(font);
        }
    }
}