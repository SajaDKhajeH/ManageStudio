using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Reports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod]
    public static dynamic Report_AllFactors(string fromdate, string todate, string factorStatus)
    {
        try
        {
            fromdate = fromdate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            factorStatus = factorStatus.ToDecodeNumber();
            if (fromdate.IsNullOrEmpty() || todate.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا فیلدهای تاریخ را وارد کنید",
                };
            }
            if (!fromdate.IsDate() || !todate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا تاریخ هارو به درستی وارد کنید",
                };
            }
            if (fromdate.ToMiladi() > todate.ToMiladi())
            {
                return new
                {
                    Result = false,
                    Message = "از تاریخ نمی تواند بزرگتر از تا تاریخ باشد",
                };
            }
            var data = AdakDB.Db.usp_AllFactors(fromdate, todate, factorStatus.ToLong()).ToList();

            var variables = new Dictionary<string, string>
                {
                    { "Date", DateTime.Now.ToShamsi() }
                };

            string url = $"files/temp/{DateTime.Now.Ticks}.xlsx";
            bool ok = AdakStiReportBuilder.WithName("AllFactors.mrt")
                 .WithData(data)
                 .WithVaiables(variables)
                 .SaveExcel(url);
            return new
            {
                Result = ok,
                Message = ok ? "ذخیره گزارش با موفقیت انجام شد" : "خطا درچاپ",
                Url = url
            };

        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                Message = "خطایی در ذخیره گزارش رخ داده است",
                Url = ex.Message
            };
        }
    }
    [WebMethod]
    public static dynamic Report_ProductProfit(string fromdate, string todate, string factorStatus)
    {
        try
        {
            fromdate = fromdate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            factorStatus = factorStatus.ToDecodeNumber();
            if (fromdate.IsNullOrEmpty() || todate.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا فیلدهای تاریخ را وارد کنید",
                };
            }
            if (!fromdate.IsDate() || !todate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا تاریخ هارو به درستی وارد کنید",
                };
            }
            if (fromdate.ToMiladi() > todate.ToMiladi())
            {
                return new
                {
                    Result = false,
                    Message = "از تاریخ نمی تواند بزرگتر از تا تاریخ باشد",
                };
            }
            var data = AdakDB.Db.usp_ProductProfic(fromdate, todate, factorStatus.ToLong()).ToList();

            var variables = new Dictionary<string, string>
                {
                    { "Date", DateTime.Now.ToShamsi() }
                };

            string url = $"files/temp/{DateTime.Now.Ticks}.xlsx";
            bool ok = AdakStiReportBuilder.WithName("ProductProfit.mrt")
                 .WithData(data)
                 .WithVaiables(variables)
                 .SaveExcel(url);
            return new
            {
                Result = ok,
                Message = ok ? "ذخیره گزارش با موفقیت انجام شد" : "خطا درچاپ",
                Url = url
            };

        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                Message = "خطایی در ذخیره گزارش رخ داده است",
                Url = ex.Message
            };
        }
    }
    [WebMethod]
    public static dynamic ChangeArchive_Factors(string fromdate, string todate, string factorStatus, bool archive)
    {
        try
        {
            fromdate = fromdate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            factorStatus = factorStatus.ToDecodeNumber();
            if (fromdate.IsNullOrEmpty() || todate.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا فیلدهای تاریخ را وارد کنید",
                };
            }
            if (!fromdate.IsDate() || !todate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا تاریخ هارو به درستی وارد کنید",
                };
            }
            if (fromdate.ToMiladi() > todate.ToMiladi())
            {
                return new
                {
                    Result = false,
                    Message = "از تاریخ نمی تواند بزرگتر از تا تاریخ باشد",
                };
            }
            AdakDB.Db.usp_Factor_SetArchive(fromdate, todate, factorStatus.ToLong(), archive, LoginedUser.Id);
            return new
            {
                Result = true,
                Message = "عملیات با موفقیت انجام شد"
            };
        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                Message = "خطایی در ذخیره گزارش رخ داده است",
                Url = ex.Message
            };
        }
    }
    [WebMethod]
    public static dynamic Report_PerformancePersonnel(string fromdate, string todate, string factorStatus)
    {
        try
        {
            fromdate = fromdate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            factorStatus = factorStatus.ToDecodeNumber();
            if (fromdate.IsNullOrEmpty() || todate.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا فیلدهای تاریخ را وارد کنید",
                };
            }
            if (!fromdate.IsDate() || !todate.IsDate())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا تاریخ هارو به درستی وارد کنید",
                };
            }
            if (fromdate.ToMiladi() > todate.ToMiladi())
            {
                return new
                {
                    Result = false,
                    Message = "از تاریخ نمی تواند بزرگتر از تا تاریخ باشد",
                };
            }
            var data = AdakDB.Db.usp_Factor_ComputedPerformancePersonnel(fromdate, todate, factorStatus.ToLong()).ToList();

            var variables = new Dictionary<string, string>
                {
                    { "Date", DateTime.Now.ToShamsi() }
                };

            string url = $"files/temp/{DateTime.Now.Ticks}.pdf";
            bool ok = AdakStiReportBuilder.WithName("PerformancePersonnel.mrt")
                 .WithData(data)
                 .WithVaiables(variables)
                 .SavePDF(url);
            return new
            {
                Result = ok,
                Message = ok ? "ذخیره گزارش با موفقیت انجام شد" : "خطا درچاپ",
                Url = url
            };

        }
        catch (Exception ex)
        {
            return new
            {
                Result = false,
                Message = "خطایی در ذخیره گزارش رخ داده است",
                Url = ex.Message
            };
        }
    }
}