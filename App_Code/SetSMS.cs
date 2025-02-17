using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Timers;
using System.Web;


public class SetSMS
{
    public static bool AfterSetFactor(long FactorId, Bank.AdakBankDataContext db)
    {
        try
        {
            var factorInfo = db.usp_Factor_Select_By_Id(FactorId).SingleOrDefault();
            var familyInfo = db.usp_Family_Select_By_Id(factorInfo.F_FamilyId).SingleOrDefault();
            string TextAfterPrice = Settings.TextAfterPrice;
            var sms = db.usp_Data_Select_By_Id(DefaultDataIDs.DefaultSMS_AfterSetFactor).FirstOrDefault();
            if (sms != null && sms.D_Active && !sms.D_DefaultSMSText.IsNullOrEmpty())
            {
                string text = sms.D_DefaultSMSText;
                decimal ModPrice = 0;
                ModPrice = (factorInfo.F_SumPrice ?? 0) - (factorInfo.F_SumDiscountPrice ?? 0) - (factorInfo.F_PaidPrice);
                text = text.Replace("{{عنوان خانواده}}", familyInfo.F_Title);
                text = text.Replace("{{مجموع فاکتور}}", factorInfo.F_SumPrice.ShowPrice(TextAfterPrice));
                text = text.Replace("{{مجموع تخفیف}}", (factorInfo.F_SumDiscountPrice == null || factorInfo.F_SumDiscountPrice == 0 ? "---" : factorInfo.F_SumDiscountPrice.Value.ShowPrice(TextAfterPrice)));
                text = text.Replace("{{مجموع پرداختی}}", (factorInfo.F_PaidPrice == null || factorInfo.F_PaidPrice == 0 ? "---" : factorInfo.F_PaidPrice.ShowPrice(TextAfterPrice)));
                text = text.Replace("{{مانده حساب}}", (ModPrice == 0 ? "---" : ModPrice.ShowPrice(TextAfterPrice)));
                int? haserror = 0;
                string mes = "";
                if (familyInfo.F_MotherMobile.IsMobileNumber())
                {
                    db.usp_SMS_Add(familyInfo.F_MotherMobile, text, DefaultDataIDs.SMSTypeId_AfterSetFactor, factorInfo.F_FamilyId, LoginedUser.Id, ref haserror, ref mes);
                }
                if (familyInfo.F_FatherMobile.IsMobileNumber())
                {
                    db.usp_SMS_Add(familyInfo.F_FatherMobile, text, DefaultDataIDs.SMSTypeId_AfterSetFactor, factorInfo.F_FamilyId, LoginedUser.Id, ref haserror, ref mes);
                }

            }
            return true;
        }
        catch (Exception ex)
        {
            db.usp_ErrorAdd("Wellcome_To_Family", ex.Message);
            return false;
        }
    }
    public static bool Send(string Text, string Phone, ref string Mes)
    {
        string SenderKavenegar = AdakDB.Db.usp_Setting_Select_By_Key(DefaultDataIDs.Setting_SenderKavenegar).SingleOrDefault().Se_Value;
        string ApiKeyKavenegar = AdakDB.Db.usp_Setting_Select_By_Key(DefaultDataIDs.Setting_ApiKeyKavenegar).SingleOrDefault().Se_Value;
        if (SenderKavenegar.IsNullOrEmpty() || ApiKeyKavenegar.IsNullOrEmpty())
        {
            Mes = "تنظیمات پنل ارسال پیامک مشخص نشده است";
            AdakDB.Db.usp_ErrorAdd("SetSMS.Send", "تنظیمات پنل ارسال پیامک مشخص نشده است");
            return false;
        }
        bool res = false;
        try
        {
            #region KaveNegar
            Kavenegar.KavenegarApi api = new Kavenegar.KavenegarApi(ApiKeyKavenegar);
            var status = api.Send(SenderKavenegar, Phone, Text);
            if (status.Messageid > 0)
            {
                return true;
            }
            #endregion
        }
        catch (Exception ex)
        {
            Mes = "خطایی در ارسال پیامک پیش آمده است";
            AdakDB.Db.usp_ErrorAdd("SetSMS.Send", ex.Message);
            return false;
        }
        return res;
    }
}
