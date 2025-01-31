using Bank;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Linq;

/// <summary>
/// Summary description for Captcha
/// </summary>
public class Captcha
{
    public static Random r = new Random();
    public static string CreateCaptcha(string AuthKey)
    {
        int height = 30;
        int width = 220;
        Bitmap bmp = new Bitmap(width, height);
        RectangleF rectf = new RectangleF(10, 5, 0, 0);
        Graphics g = Graphics.FromImage(bmp);
        g.Clear(Color.White);
        g.SmoothingMode = SmoothingMode.AntiAlias;
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
        g.PixelOffsetMode = PixelOffsetMode.HighQuality;

        string tmp = "";
        for (int i = 0; i < AuthKey.Length; i++)
        {
            tmp = AuthKey[i].ToString();
            int x = (i * 36);
            x += r.Next(1, 25);
            int y = r.Next(0, 10);
            RectangleF rectR = new RectangleF(x, y, 0, 0);
            g.DrawString(tmp, new Font("Thaoma", 14, FontStyle.Bold), Brushes.DarkOrange, rectR);
        }
        for (int i = 0; i < 22; i++)
        {
            int x = r.Next(5, 234);
            int y = r.Next(5, 25);
            g.DrawLine(new Pen(Brushes.OrangeRed), new Point(x, y), new Point(x + r.Next(1, 12), y + r.Next(1, 12)));
            x = r.Next(5, 234);
            y = r.Next(10, 25);
            g.DrawLine(new Pen(Brushes.DarkOrange), new Point(x, y), new Point(x + r.Next(1, 12), y - r.Next(1, 12)));
        }
        //g.DrawString(@"/\/\/\/\/\", new Font("Thaoma", 12, FontStyle.Bold), Brushes.DarkOrange, rectf);
        //g.DrawRectangle(new Pen(Color.FromArgb(1,255,169,61)), 1, 1, width - 2, height - 2);
        g.Flush();
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        bmp.Save(ms, ImageFormat.Jpeg);
        byte[] byteImage = ms.ToArray();
        var SigBase64 = Convert.ToBase64String(byteImage);
        g.Dispose();
        bmp.Dispose();
        ms.Dispose();
        return "data:image/jpg;base64," + SigBase64;
    }
    public struct AuthKey
    {
        public decimal ID;
        public string CaptchaImage;

        public AuthKey(decimal p1, string p2)
        {
            ID = p1;
            CaptchaImage = p2;
        }
    }
    public static AuthKey CreateAuthKey(decimal? ID = null)
    {
        AuthKey result = new AuthKey();
        var dc = AdakDB.Db;
        Tbl_AuthKey ak = new Tbl_AuthKey();
        if (ID > 0)
        {
            ak = dc.Tbl_AuthKeys.Where(q => q.AK_ID == ID.Value).SingleOrDefault();
            if (ak != null)
            {
                result.ID = ak.AK_ID;
                result.CaptchaImage = CreateCaptcha(ak.AK_Key);
            }
        }
        else
        {
            ak.AK_CreationTime = DateTime.Now;
            ak.AK_Authenticated = false;
            ak.AK_Key = r.Next(100159, 999999).ToString();
            dc.Tbl_AuthKeys.InsertOnSubmit(ak);
            dc.SubmitChanges();
            result.ID = ak.AK_ID;
            result.CaptchaImage = CreateCaptcha(ak.AK_Key);
        }
        return result;
    }
    public static bool CheckAuthKey(string ak_ID, string Key)
    {
        bool result = false;

        var dc = AdakDB.Db;
        try
        {
            Tbl_AuthKey ak = dc.Tbl_AuthKeys.Where(q => q.AK_ID == decimal.Parse(ak_ID)).SingleOrDefault();
            if (ak.AK_Key == Key)
            {
                result = true;
                if (ak.AK_Authenticated == false)
                {
                    ak.AK_Authenticated = true;
                    dc.SubmitChanges();
                }
            }
        }
        catch
        { }

        return result;
    }
    public static bool CheckAuthKey(string ak_ID)
    {
        bool result = false;

        var dc = AdakDB.Db;
        try
        {
            Tbl_AuthKey ak = dc.Tbl_AuthKeys.Where(q => q.AK_ID == decimal.Parse(ak_ID)).SingleOrDefault();
            if (ak.AK_Authenticated == true)
            {
                result = true;
            }
        }
        catch
        { }

        return result;
    }
    public static string GetAuthKey(decimal? ID)
    {
        var dc = AdakDB.Db;
        Tbl_AuthKey ak = new Tbl_AuthKey();
        ak = dc.Tbl_AuthKeys.Where(q => q.AK_ID == ID.Value).SingleOrDefault();
        if (ak != null)
        {
            return ak.AK_Key;
        }
        return "";
    }

}