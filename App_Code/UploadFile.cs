using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UploadFil
/// </summary>
public class UploadFile
{
    public static bool SaveFile(string path, byte[] file)
    {
        using (MemoryStream ms = new MemoryStream(file))
        {
            if (File.Exists(HttpContext.Current.Server.MapPath(path)))
            {
                File.Delete(HttpContext.Current.Server.MapPath(path));
            }
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(path), ms.ToArray());
        }
        return true;
    }
}