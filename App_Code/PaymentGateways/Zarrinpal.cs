using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Net.Http;
using System.Threading.Tasks;

public class Zarrinpal : IPaymentGateway, IDisposable
{
    //const string merchentCode = "cfa83c81-89b0-4993-9445-2c3fcd323455";//for test

    HttpClient _httpClient;
    //ILogger<Zarrinpal> _logger;
    //public Zarrinpal(ILogger<Zarrinpal> logger)
    //{
    //    _httpClient = new HttpClient();
    //    _logger = logger;
    //}
    public Zarrinpal()
    {
        _httpClient = new HttpClient();
    }
    public async Task<OperationResult<PGResponseData>> BeginAsync(dynamic p)
    {
        OperationResult<PGResponseData> result = new OperationResult<PGResponseData>();
        try
        {
            string req = "https://api.zarinpal.com/pg/v4/payment/request.json";
            var json = JsonConvert.SerializeObject(p);
            var sc = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync(req, sc);
            if (response.IsSuccessStatusCode)
            {
                string content = await response.Content.ReadAsStringAsync();
                return GetRequestResponse(content);
            }
            else
            {
                result.Message = response.StatusCode.ToString();
            }
        }
        catch (Exception ex)
        {
            result.Message = "خطای سیستمی رخ داده";
            LogError(ex, result.Message);
        }
        return result;
    }

    private void LogError(Exception ex, string message)
    {
        ex.AddLog(message);
    }

    private OperationResult<PGResponseData> GetRequestResponse(string content)
    {
        OperationResult<PGResponseData> result = new OperationResult<PGResponseData>();
        result.Data = new PGResponseData
        {
            ResponseContent = content
        };
        if (content.Contains("The amount must be at least 1000"))
        {
            result.Message = $"حداقل مبلغ مجاز {"1,000".ToPersianNumber()} ریال می باشد";
        }
        JObject jodata = JObject.Parse(content);
        string data = jodata["data"]?.ToString() ?? "[]";
        if (data != "[]")
        {
            result.Data.Authority = jodata["data"]?["authority"]?.ToString();
            int code;
            int.TryParse(jodata["data"]?["code"]?.ToString(), out code);
            int fee;
            int.TryParse(jodata["data"]?["fee"]?.ToString(), out fee);
            result.Data.Code = code;
            result.Data.Fee = fee;
            result.Success = code == 100 || code == 101;
            return result;
        }

        JObject jo = JObject.Parse(content);
        string errors = jo["errors"]?.ToString() ?? "[]";
        if (errors != "[]")
        {
            int code;
            int.TryParse(jodata["errors"]?["code"]?.ToString(), out code);
            result.Data.Code = code;
            result.Message = GetMessage(code, jo["errors"]?["message"]?.ToString());
            result.Success = false;
        }
        return result;
    }



    public async Task<OperationResult<PGVerifyResponseData>> VerifyAsync(dynamic p)
    {
        OperationResult<PGVerifyResponseData> result = new OperationResult<PGVerifyResponseData>();
        try
        {
            string req = "https://api.zarinpal.com/pg/v4/payment/verify.json";
            var json = JsonConvert.SerializeObject(p);
            var sc = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync(req, sc);
            if (response.IsSuccessStatusCode)
            {
                string content = await response.Content.ReadAsStringAsync();
                return GetVerifyResponse(content);
            }
            else
            {
                result.Message = response.StatusCode.ToString();
            }
        }
        catch (Exception ex)
        {
            result.Message = "خطای سیستمی رخ داده";
            LogError(ex, result.Message);
        }
        return result;
    }

    private OperationResult<PGVerifyResponseData> GetVerifyResponse(string content)
    {
        OperationResult<PGVerifyResponseData> result = new OperationResult<PGVerifyResponseData>();
        result.Data = new PGVerifyResponseData
        {
            ResponseContent = content
        };

        JObject jodata = JObject.Parse(content);
        string data = jodata["data"]?.ToString() ?? "[]";
        if (data != "[]")
        {
            result.Data.RefId = jodata["data"]?["ref_id"]?.ToString();
            int code;
            int.TryParse(jodata["data"]?["code"]?.ToString(), out code);
            result.Data.Code = code.ToString();
            result.Success = code == 100 || code == 101;
            return result;
        }

        JObject jo = JObject.Parse(content);
        string errors = jo["errors"]?.ToString() ?? "[]";
        if (errors != "[]")
        {
            int code;
            int.TryParse(jodata["errors"]?["code"]?.ToString(), out code);
            result.Data.Code = code.ToString();
            result.Message = GetMessage(code, jo["errors"]?["message"]?.ToString());
            result.Success = false;
        }
        return result;
    }
    private string GetMessage(int code, string msg)
    {
        switch (code)
        {
            case -9:
                return "مبلغ وارد شده خارج از محدوده مجاز است.";
            case -10:
                return "ای پی یا مرچنت كد پذیرنده صحیح نیست.";
            case -11:
                return "مرچنت کد فعال نیست، پذیرنده مشکل خود را به امور مشتریان زرین‌پال ارجاع دهد.";
            case -12:
                return "تلاش بیش از دفعات مجاز در یک بازه زمانی کوتاه به امور مشتریان زرین پال اطلاع دهید.";
            case -15:
                return "درگاه پرداخت به حالت تعلیق در آمده است، پذیرنده مشکل خود را به امور مشتریان زرین‌پال ارجاع دهد.";
            case -16:
                return "سطح تایید پذیرنده پایین تر از سطح نقره ای است.";
            case -17:
                return "محدودیت پذیرنده در سطح آبی.";
            case -30:
                return "پذیرنده اجازه دسترسی به سرویس تسویه اشتراکی شناور را ندارد.";
            case -31:
                return "حساب بانکی تسویه را به پنل اضافه کنید. مقادیر وارد شده برای تسهیم درست نیست. پذیرنده جهت استفاده از خدمات سرویس تسویه اشتراکی شناور، باید حساب بانکی معتبری به پنل کاربری خود اضافه نماید.";
            case -32:
                return "مبلغ وارد شده از مبلغ کل تراکنش بیشتر است.";
            case -33:
                return "درصدهای وارد شده صحیح نیست.";
            case -34:
                return "مبلغ وارد شده از مبلغ کل تراکنش بیشتر است.";
            case -35:
                return "تعداد افراد دریافت کننده تسهیم بیش از حد مجاز است.";
            case -36:
                return "حداقل مبلغ جهت تسهیم باید ۱۰۰۰۰ ریال باشد.";
            case -37:
                return "یک یا چند شماره شبای وارد شده برای تسهیم از سمت بانک غیر فعال است.";
            case -38:
                return "خطا٬عدم تعریف صحیح شبا٬لطفا دقایقی دیگر تلاش کنید.";
            case -39:
                return "خطایی رخ داده است به امور مشتریان زرین پال اطلاع دهید.";
            case -40:
                return "Invalid extra params, expire_in is not valid.";
            case -41:
                return "حداکثر مبلغ پرداختی ۱۰۰ میلیون تومان است";
            case -50:
                return "حداکثر مبلغ پرداختی ۱۰۰ میلیون تومان است";
            case -51:
                return "پرداخت ناموفق";
            case -52:
                return "خطای غیر منتظره‌ای رخ داده است. پذیرنده مشکل خود را به امور مشتریان زرین‌پال ارجاع دهد.";
            case -53:
                return "پرداخت متعلق به این مرچنت کد نیست.";
            case -54:
                return "اتوریتی نامعتبر است.";
            case -55:
                return "تراکنش مورد نظر یافت نشد.";
            case -60:
                return "امکان ریورس کردن تراکنش با بانک وجود ندارد.";
            case -61:
                return "تراکنش موفق نیست یا قبلا ریورس شده است.";
            case -62:
                return "آی پی درگاه ست نشده است.";
            case -63:
                return "حداکثر زمان (۳۰ دقیقه) برای ریورس کردن این تراکنش منقضی شده است.";

            case 101:
                return "تراکنش وریفای شده است.";
            case 100:
                return "عملیات موفق";

            default:
                {
                    if (string.IsNullOrEmpty(msg))
                    {
                        return "کد خطا خارج از محدوده کنترل شده است!";
                    }
                    if (msg.Contains("The amount must be at least 1000"))
                    {
                        return $"حداقل مبلغ مجاز {"1,000".ToPersianNumber()} ریال می باشد";
                    }
                    return msg;
                }
        }
    }
    public void Dispose()
    {
        _httpClient.Dispose();
    }


}