using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class Pay : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        [WebMethod]
        public static dynamic SendSMS_PayLink(string key)
        {
            if (key.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "ورودی صفحه مشخص نیست"
                };
            }
            var keyInfo = AdakDB.Db.usp_KeyGenerator_Select_ByKey(key).SingleOrDefault();
            keyInfo = keyInfo ?? new Bank.usp_KeyGenerator_Select_ByKeyResult();
            if (keyInfo.Id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "اطلاعات لینک نامشخص هست"
                };
            }
            if (keyInfo.Paid ?? false)
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ مورد نظر از طریق این لینک پرداخت شده است"
                };
            }
            if (keyInfo.ExpireDate < DateTime.Now)
            {
                return new
                {
                    Result = false,
                    Message = "لینک منقضی شده است"
                };
            }

            return new
            {
                Result = true,
                FamilyTitle = keyInfo.FamilyTitle,
                Price = keyInfo.Price.ShowPrice(Settings.TextAfterPrice)
            };
        }
        [WebMethod]
        public static dynamic GoToPayment(string key)
        {
            if (key.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "ورودی صفحه مشخص نیست"
                };
            }
            var keyInfo = AdakDB.Db.usp_KeyGenerator_Select_ByKey(key).SingleOrDefault();
            keyInfo = keyInfo ?? new Bank.usp_KeyGenerator_Select_ByKeyResult();
            if (keyInfo.Id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "اطلاعات لینک نامشخص هست"
                };
            }
            if (keyInfo.Paid ?? false)
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ مورد نظر از طریق این لینک پرداخت شده است"
                };
            }
            if (keyInfo.ExpireDate < DateTime.Now)
            {
                return new
                {
                    Result = false,
                    Message = "لینک منقضی شده است"
                };
            }
            //باید بره به درگاه
            return new
            {
                Result = true,
                FamilyTitle = keyInfo.FamilyTitle,
                Price = keyInfo.Price.ShowPrice(Settings.TextAfterPrice)
            };
        }
    }
}