using System;
using System.Linq;
using System.Threading.Tasks;
using System.Timers;
using System.Web;

public class SmsSender
{
    public static SmsSender Instance = new SmsSender();
    private SmsSender()
    {

    }
    class SmsModel
    {
        public long SMSId { get; set; }
        public string Mobile { get; set; }
        public string Text { get; set; }
        public bool Success { get; set; }
        public string ResultId { get; set; }
        public string ErrorText { get; set; }
    }
    Timer timer;

    public void BeginSend()
    {
        //timer = new Timer(10000);
        //timer.Elapsed += Timer_Elapsed;
        //timer.Enabled = true;
        //timer.Start();
    }

    private void Timer_Elapsed(object sender, ElapsedEventArgs e)
    {
        if (isSending)
            return;
        isSending = true;
        var css = AdakDB.ConnectionStrings;
        foreach (var cs in css)
        {
            using (var db = AdakDB.GetDb(cs))
            {
                string SenderKavenegar = db.usp_Setting_Select_By_Key(DefaultDataIDs.Setting_SenderKavenegar).SingleOrDefault().Se_Value;
                string ApiKeyKavenegar = db.usp_Setting_Select_By_Key(DefaultDataIDs.Setting_ApiKeyKavenegar).SingleOrDefault().Se_Value;
                if (SenderKavenegar.IsNullOrEmpty() || ApiKeyKavenegar.IsNullOrEmpty())
                {
                    continue;
                }
                SendSMS(db, SenderKavenegar, ApiKeyKavenegar);
            }
        }
        isSending = false;
    }
    bool isSending = false;
    private void SendSMS(Bank.AdakBankDataContext db, string SenderKavenegar, string ApiKeyKavenegar)
    {
        var smss = db.usp_Sms_Select_For_Send().ToList();

        var list = smss.Select(item => new SmsModel()
        {
            Mobile = item.Mobile,
            Text = item.Textt,
            SMSId = item.Id ?? 0
        }).ToList();

        Parallel.ForEach(list, (service) =>
        {
            SendAllSms(service, SenderKavenegar, ApiKeyKavenegar);
        });

        string ids = string.Join(",", list.Where(a => a.Success).Select(x => x.SMSId));

        if (!ids.IsNullOrEmpty())
        {
            int? hasError = 0;
            string mes = "";
            db.usp_SMS_SetSended(ids, ref hasError, ref mes);
        }
        foreach (var er in list.Where(x => !x.Success))
        {
            db.usp_ErrorAdd("SendSMS", er.ErrorText);
        }
    }
    private static void SendAllSms(SmsModel service, string SenderKavenegar, string ApiKeyKavenegar)
    {
        try
        {
            var api = new Kavenegar.KavenegarApi(ApiKeyKavenegar);
            var res = api.Send(SenderKavenegar, service.Mobile, HttpUtility.HtmlEncode(service.Text));

            if (res.Messageid > 0)
            {
                service.Success = true;
                service.ResultId = res.Messageid.ToString();
            }
            else
            {
                service.Success = false;
                service.ErrorText = res.StatusText;
            }
        }
        catch (Exception ex)
        {
            service.ErrorText = ex.Message;
        }
    }
}