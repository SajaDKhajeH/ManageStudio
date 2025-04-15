using System;
using System.Configuration;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Text;

public class PaymentController : ApiController
{
    IPaymentGateway _zarrinpal;
    public PaymentController()
    {
        HttpContext.Current.Response.SetCORSOrigin();
        _zarrinpal = new Zarrinpal();
    }
    [HttpPost, Route("Api/Payment/GoToGateway")]
    public async Task<OperationResult<PGResponseData>> GoToGatewayAsync([FromBody] PaymentGoToGateway input)
    {
        string baseUrl = ConfigurationSettings.AppSettings["PortalUrl"];
        string callbackUrl = $"{baseUrl}/payresult?tran={"tran.Guid"}";
        string merchant_id = "cfa83c81-89b0-4993-9445-2c3fcd323455";

        var result = await _zarrinpal.BeginAsync(new
        {
            merchant_id = merchant_id,
            amount = input.DepositAmount.ToString(),
            callback_url = callbackUrl,
            description = "model.Description",
            metadata = new
            {
                mobile = input.Mobile
            }
        });
        //tran.Code = result.Data?.Code ?? 0;
        //tran.Message = result.Message;
        //tran.ResponseContent = result.Data?.ResponseContent;
        //if (result.Success)
        //{
        //    tran.Authority = result.Data?.Authority;
        //    tran.Fee = result.Data?.Fee;
        //}
        //await _db.SaveChangesAsync();
        return result;
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
            return  OperationResult<ReceiptDto>.Failed("تراکنش یافت نشد!");
        }
        if (string.IsNullOrEmpty(transaction.VerifiedRefId))
        {
            return  OperationResult<ReceiptDto>.Failed("کد پیگیری پرداخت یافت نشد!");
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
    [HttpPost, Route("Api/Payment/SetResult")]
    public async Task<dynamic> SetResultAsync(string tran, string authority, string status)
    {
        OperationResult<PGVerifyResponseData> result = new OperationResult<PGVerifyResponseData>();
        try
        {
            Guid tranGuid;
            if (!Guid.TryParse(tran, out tranGuid))
            {
                return OperationResult<PGVerifyResponseData>.Failed("مقادیر ورودی نامعتبر است");
            }
            var transaction = new Transaction();// await _db.Transactions.SingleOrDefaultAsync(x => x.Guid == tranGuid);
            if (transaction == null)
            {
                return OperationResult<PGVerifyResponseData>.Failed("تراکنش یافت نشد");
            }
            if (transaction.VerifiedSuccess)
            {
                result.Success = true;
                result.Message = "اطلاعات پرداخت قبلاً ثبت شده و پرداخت شما موفق بوده";
                result.Data = SetData(transaction);
                return result;
            }
            if (transaction.VerifyTime != null && !transaction.VerifySuccess)
            {
                result.Success = false;
                if (string.IsNullOrEmpty(transaction.VerifiedMessage))
                {
                    result.Message = "تراکنش در حال پردازش است در صورت خطا نهایتا تا 72 ساعت آینده پول به حساب شما بازخواهد گشت";
                }
                else
                {
                    result.Message = transaction.VerifiedMessage;
                }
                result.Data = SetData(transaction);
                return result;
            }
            if ((transaction.Authority ?? "") != (authority ?? ""))
            {
                return OperationResult<PGVerifyResponseData>.Failed("تراکنش یافت نشد!!!");
            }
            //var customer = await _db.Customers
            //    .Where(x => x.Id == transaction.CustomerId)
            //    .Select(x => new { x.MerchentCode, x.Mobile })
            //    .FirstOrDefaultAsync();
            //if (customer == null)
            //{
            //    result.Message = "اطلاعات مشتری در سامانه ثبت نشده";
            //    return result;
            //}


            transaction.VerifyTime = DateTime.Now;
            transaction.VerifySuccess = (status ?? "").ToLower().Equals("ok");
            //await _db.SaveChangesAsync();

            if (!transaction.VerifySuccess)
            {
                result.Message = "پرداخت انجام نشد!";
                result.Data = SetData(transaction);
                return result;
            }

            result = await _zarrinpal.VerifyAsync(new
            {
                amount = (long)transaction.Price,
                authority = transaction.Authority ?? "",
                //merchant_id = customer.MerchentCode
            });
            transaction.VerifiedSuccess = result.Success;
            transaction.VerifiedTime = DateTime.Now;
            transaction.VerifiedMessage = result.Message;
            transaction.ResponseContent = result.Data?.ResponseContent;
            if (result.Success)
            {
                transaction.VerifiedRefId = result.Data?.RefId;
            }
            //await _db.SaveChangesAsync();
            result.Data = SetData(transaction);
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = "خطای سیستمی سمت سرور رخ داده";
            //_logger.LogError(ex, result.Message);
        }
        return result;
    }
    private PGVerifyResponseData SetData(Transaction transaction)
    {
        return new PGVerifyResponseData
        {
            DateTime = transaction.VerifiedTime?.ToShamsiWithTime() ?? transaction.VerifyTime?.ToShamsiWithTime(),
            Transaction = transaction.Guid.ToString(),
            Description = transaction.Description,
            Price = (transaction.Price + (transaction.Fee ?? 0)).ToPersianPrice(),
            RefId = (transaction.VerifiedRefId?.ToPersianNumber() ?? transaction.Authority?.TrimStart('A').TrimStart('0')),
            IsFromWebsite = transaction.IsFromWebsite
        };
    }
}