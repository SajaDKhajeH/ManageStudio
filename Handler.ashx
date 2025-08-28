<%@ WebHandler Language="C#" Class="Handler" %>

using System.Web;
using System.IO;
using System;

public class Handler : HttpTaskAsyncHandler
{
    static long GetDirectorySize(string path)
    {
        long size = 0;

        // Add file sizes.
        FileInfo[] files = new DirectoryInfo(path).GetFiles("*", SearchOption.AllDirectories);
        foreach (FileInfo file in files)
        {
            size += file.Length;
        }

        return size;
    }
    const long OneGigabyte = 1024L * 1024L * 1024L;

    public override async System.Threading.Tasks.Task ProcessRequestAsync(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            var serverDir = context.Server.MapPath("~/");
            string uploadsDir = SpecialStudio.FilesDirectory + "OnlineAppointmentSettings/";
            string filesDir = serverDir + uploadsDir;

            if (!Directory.Exists(filesDir))
            {
                Directory.CreateDirectory(filesDir);
            }

            string json;

            var fileName = Guid.NewGuid().ToString() + Path.GetExtension(context.Request.Files["file"].FileName);
            //var fileName = context.Request.Files["file"]?.FileName ?? null;
            //if (File.Exists(Path.Combine(filesDir, fileName)))
            //{
            //    json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new
            //    {
            //        success = false,
            //        message = "قبلاً فایلی با این نام آپلود کردید"
            //    });
            //    SetResponse(context, json);
            //    return;
            //}

            long size = context.Request.Files["file"]?.InputStream?.Length ?? 0;
            var uploadedFilesSize = GetDirectorySize(filesDir);
            if ((uploadedFilesSize + size) > OneGigabyte)
            {
                json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new
                {
                    success = false,
                    message = "فایل های شما از 1 گیگابایت بیشتر شدند!"
                });
                SetResponse(context, json);
                return;
            }



            HttpPostedFile file = context.Request.Files["file"];
            string des = Path.Combine(filesDir, fileName);
            file.SaveAs(des);

            json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new
            {
                fileSrc = uploadsDir.Replace(SpecialStudio.FilesDirectory, "") + fileName,
                relativeUrl = HttpContext.Current.Request.Url.ToString().Replace("handler.ashx", "") + uploadsDir + fileName,
                success = true
            });
            SetResponse(context, json);
        }
        await System.Threading.Tasks.Task.CompletedTask;
    }
    protected void SetResponse(HttpContext context, string json)
    {
        context.Response.StatusCode = (int)System.Net.HttpStatusCode.OK;
        context.Response.ContentType = "text/json";
        context.Response.Write(json);
        //context.Response.End();
        context.Response.Flush(); // Sends all currently buffered output to the client.
        context.Response.SuppressContent = true;  // Gets or sets a value indicating whether to send HTTP content to the client.
        context.ApplicationInstance.CompleteRequest(); // Causes ASP.NET to bypass all events and filtering in the HTTP pipeline chain of execution and directly execute the EndRequest event.
    }
}