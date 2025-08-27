using System;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

public class PaymentController : ApiController
{
    IPaymentGateway _zarrinpal;
    public PaymentController()
    {
        _zarrinpal = new Zarrinpal();
    }
    [HttpOptions, Route("Api/Payment/GoToGateway")]
    public IHttpActionResult HandlePreflight()
    {
        return Ok();
    }
    [HttpPost, Route("Api/Payment/GoToGateway")]
    public async Task<IHttpActionResult> GoToGatewayAsync([FromBody] PaymentGoToGateway input)
    {
        string baseUrl = ConfigurationSettings.AppSettings["PortalUrl"];

        Guid guid = Guid.NewGuid();
        if (!Settings.MerchantCodeZarrinpal.IsNullOrEmpty())
        {

            AdakDB.Db.usp_OnlineTurnRequest_Add(
                    input.FirstName,
                    input.LastName,
                    input.Gender,
                    input.ScheduleDate,
                    input.ScheduleTime,
                    input.DepositAmount,
                    input.Mobile,
                    guid,
                    input.PackageId,
                    ""
                );
            string callbackUrl = $"{baseUrl}/payresult?tran={guid}";



            string merchant_id = Settings.MerchantCodeZarrinpal;

            var result = await _zarrinpal.BeginAsync(new
            {
                merchant_id = merchant_id,
                amount = Settings.IsToman ? input.DepositAmount.ToString() : (input.DepositAmount / 10).ToString(),
                callback_url = callbackUrl,
                description = "رزور نوبت " + input.FirstName + " " + input.LastName + " برای تاریخ " + input.ScheduleDate,
                metadata = new
                {
                    mobile = input.Mobile
                }
            });
            return Ok(result);
        }
        else
        {
            return null;
        }
    }
    [HttpGet, Route("Api/Payment/GetReceiptInfo")]
    public async Task<OperationResult<ReceiptDto>> GetReceiptInfoAsync(string tran)
    {
        Guid guid;
        if (!Guid.TryParse(tran, out guid))
        {
            return OperationResult<ReceiptDto>.Failed("مقادیر ورودی نامعتبر است!");
        }
        var transaction = new Transaction();
        //var transaction = await _db.Transactions
        //    .Where(x => x.Guid == guid)
        //    .Select(x => new
        //    {
        //        x.Price,
        //        x.Fee,
        //        x.Description,
        //        x.VerifiedRefId,
        //        x.VerifiedTime,
        //        x.Mobile,
        //        x.InvoiceId,
        //        x.CustomerId
        //    }).SingleOrDefaultAsync();
        if (transaction == null)
        {
            return OperationResult<ReceiptDto>.Failed("تراکنش یافت نشد!");
        }
        if (string.IsNullOrEmpty(transaction.VerifiedRefId))
        {
            return OperationResult<ReceiptDto>.Failed("کد پیگیری پرداخت یافت نشد!");
        }
        StringBuilder sbReceipt = new StringBuilder();



        //List<InvoiceDetailDto>? invoiceDetails = null;

        if (transaction.InvoiceId == null)
        {
            sbReceipt.AppendLine("مبلغ خرید:");
            sbReceipt.AppendLine(transaction.Price.ToPersianPrice());
            sbReceipt.AppendLine("شماره پیگیری:");
            sbReceipt.AppendLine(transaction.VerifiedRefId.ToPersianNumber());
            sbReceipt.AppendLine("تاریخ:");
            sbReceipt.AppendLine($"{transaction.VerifiedTime.ToShamsi().ToPersianNumber()}-{transaction.VerifiedTime.ToTime().ToPersianNumber()}");
            sbReceipt.AppendLine("شرح:");
            sbReceipt.AppendLine(transaction.Description);
        }
        else
        {
            //var invoice = _db.Invoices
            //    .Where(x => x.Id == transaction.InvoiceId)
            //    .Select(x => new
            //    {
            //        x.Type,
            //        x.CustomerName
            //    }).Single();
            //if (!string.IsNullOrEmpty(invoice.CustomerName))
            //{
            //    sbReceipt.AppendLine("نام خریدار:");
            //    sbReceipt.AppendLine(invoice.CustomerName);
            //}
            //sbReceipt.AppendLine("مبلغ خرید:");
            //sbReceipt.AppendLine(transaction.Price.ToPersianPrice());
            //sbReceipt.AppendLine("شماره پیگیری:");
            //sbReceipt.AppendLine(transaction.VerifiedRefId.ToPersianNumber());
            //sbReceipt.AppendLine("تاریخ:");
            //sbReceipt.AppendLine($"{transaction.VerifiedTime.ToShamsi().ToPersianNumber()}-{transaction.VerifiedTime.ToTime().ToPersianNumber()}");
            //if (invoice.Type == InvoiceTypes.Invoice)
            //{
            //    sbReceipt.AppendLine("فاکتور فروش:");
            //    sbReceipt.AppendLine("پرداخت موفق");
            //}
            //else if (invoice.Type == InvoiceTypes.PreInvoice)
            //{
            //    sbReceipt.AppendLine("پیش فاکتور:");
            //    sbReceipt.AppendLine("پرداخت موفق");
            //}

            //invoiceDetails = _db.InvoiceDetails
            //    .Where(x => x.InvoiceId == transaction.InvoiceId)
            //    .Select(x => new InvoiceDetailDto
            //    {
            //        Count = x.Count,
            //        Price = x.UnitPrice,
            //        Title = x.Title
            //    }).ToList();
        }
        //string customerName = _db.Customers
        //    .Where(x => x.Id == transaction.CustomerId)
        //    .Select(x => x.FullName)
        //    .Single();

        return new OperationResult<ReceiptDto>
        {
            Success = true,
            Data = new ReceiptDto
            {
                Mobile = transaction.Mobile,
                Text = sbReceipt.ToString(),
                //CustomerName = customerName,
                //InvoiceItems = invoiceDetails
            }
        };
    }
    public class SetResultBody
    {
        public string tran { get; set; }
        public string authority { get; set; }
        public string status { get; set; }
    }
    [HttpPost, Route("Api/Payment/SetResult")]
    public async Task<dynamic> SetResult([FromBody] SetResultBody b)
    {
        string tran = b.tran;
        string authority = b.authority;
        string status = b.status;
        OperationResult<PGVerifyResponseData> result = new OperationResult<PGVerifyResponseData>();
        try
        {
            Guid tranGuid;
            if (!Guid.TryParse(tran, out tranGuid))
            {
                return OperationResult<PGVerifyResponseData>.Failed("مقادیر ورودی نامعتبر است");
            }

            var success = (status ?? "").ToLower().Equals("ok");
            if (!success)
            {
                return OperationResult<PGVerifyResponseData>.Failed("پرداخت انجام نشد!");
            }

            //var transaction = new Transaction();// await _db.Transactions.SingleOrDefaultAsync(x => x.Guid == tranGuid);
            //if (transaction == null)
            //{
            //    return OperationResult<PGVerifyResponseData>.Failed("تراکنش یافت نشد");
            //}
            //if (transaction.VerifiedSuccess)
            //{
            //    result.Success = true;
            //    result.Message = "اطلاعات پرداخت قبلاً ثبت شده و پرداخت شما موفق بوده";
            //    result.Data = SetData(transaction);
            //    return result;
            //}
            //if (transaction.VerifyTime != null && !transaction.VerifySuccess)
            //{
            //    result.Success = false;
            //    if (string.IsNullOrEmpty(transaction.VerifiedMessage))
            //    {
            //        result.Message = "تراکنش در حال پردازش است در صورت خطا نهایتا تا 72 ساعت آینده پول به حساب شما بازخواهد گشت";
            //    }
            //    else
            //    {
            //        result.Message = transaction.VerifiedMessage;
            //    }
            //    result.Data = SetData(transaction);
            //    return result;
            //}
            //if ((transaction.Authority ?? "") != (authority ?? ""))
            //{
            //    return OperationResult<PGVerifyResponseData>.Failed("تراکنش یافت نشد!!!");
            //}
            //var customer = await _db.Customers
            //    .Where(x => x.Id == transaction.CustomerId)
            //    .Select(x => new { x.MerchentCode, x.Mobile })
            //    .FirstOrDefaultAsync();
            //if (customer == null)
            //{
            //    result.Message = "اطلاعات مشتری در سامانه ثبت نشده";
            //    return result;
            //}


            //transaction.VerifyTime = DateTime.Now;
            //transaction.VerifySuccess = (status ?? "").ToLower().Equals("ok");
            //await _db.SaveChangesAsync();

            //if (!transaction.VerifySuccess)
            //{
            //    result.Message = "پرداخت انجام نشد!";
            //    result.Data = SetData(transaction);
            //    return result;
            //}

            var transaction = AdakDB.Db.usp_OnlineTurnRequest_Select(tranGuid).SingleOrDefault();
            if (transaction == null)
            {
                return OperationResult<PGVerifyResponseData>.Failed("تراکنش یافت نشد");
            }


            result = await _zarrinpal.VerifyAsync(new
            {
                amount = (long)transaction.OTR_Price,
                authority = authority
                //merchant_id = customer.MerchentCode
            });
            if (result.Success)
            {
                string message = "";
                int? hasError = null;
                long? resultId = null;
                AdakDB.Db.usp_Turn_Add_AfterPayOnline(
                    tranGuid,
                    result.Data?.RefId,
                    ref message,
                    ref hasError,
                    ref resultId
                  );
                if ((hasError ?? 0) != 0)
                {
                    return OperationResult<PGVerifyResponseData>.Failed(message);
                }
            }
            result.Success = true;
            result.Data = new PGVerifyResponseData
            {
                DateTime = DateTime.Now.ToShamsiWithTime(),
                Description = $"تراکنش موفق",
                Price = ((long)transaction.OTR_Price).ToString("#,#") + " " + Settings.TextAfterPrice,
                RefId = result.Data?.RefId,
                Transaction = tranGuid.ToString()
            };
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = "خطای سیستمی سمت سرور رخ داده";
            //_logger.LogError(ex, result.Message);
        }
        return result;
    }
    //private PGVerifyResponseData SetData(Transaction transaction)
    //{
    //    return new PGVerifyResponseData
    //    {
    //        DateTime = transaction.VerifiedTime?.ToShamsiWithTime() ?? transaction.VerifyTime?.ToShamsiWithTime(),
    //        Transaction = transaction.Guid.ToString(),
    //        Description = transaction.Description,
    //        Price = (transaction.Price + (transaction.Fee ?? 0)).ToPersianPrice(),
    //        RefId = (transaction.VerifiedRefId?.ToPersianNumber() ?? transaction.Authority?.TrimStart('A').TrimStart('0')),
    //        IsFromWebsite = transaction.IsFromWebsite
    //    };
    //}
}