using Bank;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Family;
using System.IO;
using static Stimulsoft.Report.StiRecentConnections;

namespace AdakStudio
{
    public partial class ManageInvoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id == 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role != DefaultDataIDs.Role_Admin && LoginedUser.Role != DefaultDataIDs.Role_Secretary)
            {
                Response.Redirect("Logout.aspx");
            }
        }

        protected static void CloseConnectios(Bank.AdakBankDataContext db)
        {
            try { db.Transaction?.Rollback(); } catch { };
            try { db.Connection.Close(); } catch { };
            try
            { db.Dispose(); }
            catch { };
        }
        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> ForGrid(
                int page, int perPage, string fromDate, string toDate, string familyId, string searchText,
                string causer, string status, string typePhoto, string photographer, string designer, bool isGift, bool forceDesign
                )
        {
            perPage = perPage == 0 ? 10 : perPage;
            searchText = searchText.Trim();
            int? countt = 0;
            familyId = familyId.ToDecodeNumber();
            causer = causer.ToDecodeNumber();
            status = status.ToDecodeNumber();
            typePhoto = typePhoto.ToDecodeNumber();
            photographer = photographer.ToDecodeNumber();
            designer = designer.ToDecodeNumber();

            string TextAfterPrice = Settings.TextAfterPrice;
            var data = AdakDB.Db.usp_Factor_Select_For_Grid(searchText, fromDate.ToEnglishNumber(), toDate.ToEnglishNumber(), 0, familyId.ToLong(), page, perPage, ref countt, causer.ToLong(), status.ToLong(), typePhoto.ToLong(), photographer.ToLong(), designer.ToLong(), isGift, forceDesign).ToList();
            data = data ?? new List<Bank.usp_Factor_Select_For_GridResult>();
            List<FactorForGrid> list = new List<FactorForGrid>();
            data.ForEach(x => list.Add(new FactorForGrid()
            {
                FactorNumber = x.F_Id.ToString(),
                Row = 1,
                FamilyTitle = PublicMethod.Tag_A_for_Family(x.FamilyTitle, x.F_FamilyId.ToCodeNumber()),
                FactorDate = x.F_Date,
                SumFactor = x.F_SumPrice.ShowPrice(TextAfterPrice),
                Payable = ((x.F_SumPrice - x.F_SumDiscountPrice) ?? 0).ShowPrice(TextAfterPrice),
                SumDiscount = x.F_SumDiscountPrice.ShowPrice(TextAfterPrice),
                PaidPrice = (x.PaidPrice ?? 0).ShowPrice(TextAfterPrice),
                FinanStatus = x.FinanStatus,
                FactorStatus = x.StatusTitle,
                TypePhotographi = x.TypePhotographyTitle,
                Designer = x.DesignerFullName.IsNullOrEmpty() ? "" : x.DesignerFullName,
                Photographer = x.PhotographerFullName.IsNullOrEmpty() ? "" : x.PhotographerFullName,
                IsGift = (x.F_IsGift ?? false) ? "هست" : "نیست",
                ForceDesign = (x.F_ForceDesign ?? false) ? "هست" : "نیست",
                Actions = @"
                <div class='action-buttons'>
                      " + (((x.F_SumPrice - x.F_SumDiscountPrice - (x.PaidPrice ?? 0)) ?? 0) > 0 ? @"<button class='btnDataTable btnDataTable-print' data-bs-toggle='modal' data-bs-target='#m_SetPaidPrice' onclick='PayFactor_Or_Turn(" + x.F_Id + @"," + ((x.F_SumPrice - x.F_SumDiscountPrice - (x.PaidPrice ?? 0)) ?? 0) + @",1)' title='پرداخت'>💰</button>" : "") + @"  
                        <button class='btnDataTable btnDataTable-print' onclick='PrintFactor(" + x.F_Id + @")' title='چاپ'>🖨</button>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#m_SetFactor' onclick='GetInfoForEditFactor(" + x.F_Id + @")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='FactorDelete(" + x.F_Id + @")' title='حذف'>🗑</button>
                </div>
                "
            })); ;
            //  < div class='menu-item px-3'><a data-bs-toggle='modal' data-bs-target='#m_SetFactor' onclick='GetInfoForEditFactor(" + x.F_Id + @")' class='menu-link px-3'>ویرایش</a></div>
            //<div class='menu-item px-3'><a onclick = 'FactorDelete(" + x.F_Id + @")' class='menu-link px-3'>حذف</a></div>

            if (list == null)
            {
                return new OperationResult<ForGrid.DataTableModel>
                {
                    Success = false,
                    Message = "اطلاعات برای نمایش وجود ندارد",
                    Data = new ForGrid.DataTableModel() { }
                };
            }
            return new OperationResult<ForGrid.DataTableModel>
            {
                Success = true,
                Message = "",
                Data = new ForGrid.DataTableModel()
                {
                    recordsTotal = countt ?? 0,
                    recordsFiltered = countt ?? 0,
                    data = list
                }
            };
        }
        [WebMethod]
        public static dynamic FactorDelete(long id)
        {
            if (id == 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه فاکتور مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            int? haserror = 0;
            string mes = "";
            db.usp_Factor_Delete(id, LoginedUser.Id, ref mes, ref haserror);
            return new
            {
                Result = haserror == 0,
                Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
            };
        }
        [WebMethod]
        public static dynamic SetFactor(
                    string factorId, string familyId, string fDate, string discountPrice, string paidPrice, string paidType, string refNumber, List<ProductDetails> products, string factor_desc,
                    string TypePhotography, string factor_status, string PhotographerId, bool ForceDesign, bool OnlyEditedDelivered
            )
        {
            var db = AdakDB.Db;
            try
            {
                familyId = familyId.ToDecodeNumber();
                fDate = fDate.ToEnglishNumber();
                TypePhotography = TypePhotography.ToDecodeNumber();
                factor_status = factor_status.ToDecodeNumber();
                PhotographerId = PhotographerId.ToDecodeNumber();
                #region چک کردن ورودی ها
                if (factor_status.IsNullOrEmpty() || factor_status == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا وضعیت فاکتور را مشخص کنید"
                    };

                }
                if (familyId.Trim().IsNullOrEmpty() || familyId == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا خانواده  را مشخص کنید"
                    };
                }
                if (TypePhotography.Trim().IsNullOrEmpty() || TypePhotography == "0")
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا موضوع عکاسی را مشخص کنید"
                    };
                }
                if (fDate.Trim().IsNullOrEmpty() || !fDate.IsDate())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا تاریخ را مشخص کنید"
                    };
                }
                //اگر وضعیت فاکتور ناقص بود میتونه بدون اقلام ثبت کنه
                if (factor_status.ToLong() != DefaultDataIDs.FactorStatus_IncompleteFactor && (products == null || products.Count == 0))
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا اقلام فاکتور را مشخص کنید"
                    };
                }
                if (products.Exists(a => a.quantity <= 0))
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا تعداد تمامی اقلام فاکتور را مشخص کنید"
                    };
                }
                if (products.Exists(a => a.price <= 0))
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا قیمت فروش تمامی اقلام فاکتور را مشخص کنید"
                    };
                }
                #endregion
                int? hasError = 0;
                string mes = "";
                long CauserId = LoginedUser.Id;
                long DiscountPrice = 0;
                DiscountPrice = discountPrice.IsNullOrEmpty() || !discountPrice.IsNumber() ? 0 : discountPrice.ToLong();
                if (DiscountPrice > 0)
                {
                    var PInfo = db.usp_Personnel_SelectInfo_By_Username_Or_Id(null, CauserId).SingleOrDefault();
                    if (PInfo != null && DiscountPrice > (PInfo.P_MaxPercentForSetDiscount ?? 0))
                    {
                        return new
                        {
                            Result = false,
                            Message = "امکان ثبت تخفیف بیش از مبلغ مشخص شده برای شما وجود ندارد"
                        };
                    }
                }
                long sumGiftPrice = products.Where(a => a.Gift).Sum(b => b.quantity * b.price).ToLong();
                if (products.Exists(a => a.Gift && a.quantity > 1))
                {
                    return new
                    {
                        Result = false,
                        Message = "اقلام هدیه را نمی توانید بیش از یکی ثبت کنید"
                    };
                }
                bool IsEdit = false;
                long? FamilyId = familyId.ToLong();
                long? FactorId = factorId.IsNullOrEmpty() || factorId == "0" ? 0 : factorId.ToLong();
                long OldFactorStatus = 0;
                //ثبت فاکتور
                decimal SumPrice = products.Sum(a => a.price * a.quantity);
                decimal SumPriceWithoutGift = SumPrice - sumGiftPrice;
                decimal PaidPrice = paidPrice.IsNullOrEmpty() | !paidPrice.IsNumber() ? 0 : paidPrice.ToLong();
                decimal SumPaidPrice = 0;
                //گرفتن وضعیت قبلیش واسه اینکه پیامک رو بفرستیم
                if (FactorId > 0)
                {
                    var facInfo = db.usp_Factor_Select_By_Id(FactorId)?.SingleOrDefault();
                    OldFactorStatus = facInfo.F_Status;
                    SumPaidPrice = facInfo.F_PaidPrice;
                }
                #region چک کردن اینکه نتونن فاکتور رو با وضعیت آماده به طراحی ثبت کنند زمانی که کمتر از 50 درصد فاکتور پپرپداخت شده
                if (factor_status.ToLong() == DefaultDataIDs.FactorStatus_ReadyForDesign)
                {
                    SumPaidPrice = FactorId > 0 ? SumPaidPrice : PaidPrice;
                    if ((SumPriceWithoutGift - DiscountPrice) > 0 && SumPaidPrice == 0 && ((DiscountPrice * 100) / SumPriceWithoutGift) < 50)
                    {
                        return new
                        {
                            Result = false,
                            Message = "فاکتور هیچ پرداختی ای نداشته است اجازه ثبت فاکتور با وضعیت آماده به طراحی رو ندارید"
                        };
                    }
                    if ((SumPriceWithoutGift - DiscountPrice) > 0 && SumPaidPrice > 0 && (((SumPaidPrice + DiscountPrice) * 100) / SumPriceWithoutGift) < 50)
                    {
                        return new
                        {
                            Result = false,
                            Message = "حداقل باید 50 درصد فاکتور پرداخت شده باشد تا بتوانید وضعیت فاکتور را با وضعیت آماده به طراحی ثبت کنید"
                        };
                    }
                }
                #endregion
                DiscountPrice = DiscountPrice + sumGiftPrice;
                List<usp_FactorDetail_By_FactorIdResult> OldDetails = new List<usp_FactorDetail_By_FactorIdResult>();
                //چک کردن اینکه فاکتور منفی نباشه
                if (SumPrice > 0 && (SumPrice - DiscountPrice - PaidPrice) < 0)
                {
                    return new
                    {
                        Result = false,
                        Message = "فاکتور نمی تواند منفی باشد"
                    };
                }

                if (db.Connection.State != System.Data.ConnectionState.Open)
                {
                    db.Connection.Open();
                }
                db.Transaction = db.Connection.BeginTransaction();

                if (FactorId == 0)
                {
                    db.usp_Factor_Add(FamilyId, fDate, SumPrice, DiscountPrice, 0, products.Count, 0, 0, factor_desc, CauserId, ref mes, ref hasError, ref FactorId, ForceDesign, TypePhotography.ToLong(), factor_status.ToLong(), PhotographerId.ToLong(), OnlyEditedDelivered);
                }
                else
                {
                    IsEdit = true;
                    db.usp_Factor_Edit(FactorId, fDate, SumPrice, DiscountPrice, 0, products.Count, 0, 0, factor_desc, CauserId, ref mes, ref hasError, ForceDesign, TypePhotography.ToLong(), factor_status.ToLong(), PhotographerId.ToLong(), OnlyEditedDelivered);
                }
                if (hasError == 1)
                {
                    CloseConnectios(db);
                    return new
                    {
                        Result = false,
                        Message = mes.IsNullOrEmpty() ? "خطایی در ثبت اطلاعات رخ داده است" : mes
                    };
                }
                //گرفتن لیست بچه هایی که قبلا ثبت شده است
                if (IsEdit)
                {
                    OldDetails = db.usp_FactorDetail_By_FactorId(FactorId).ToList();
                }
                foreach (var pp in products)
                {
                    long detailId = pp.FCId;
                    if (detailId > 0)
                    {
                        var itemDel = OldDetails.SingleOrDefault(a => a.FD_Id == detailId);
                        if (itemDel != null)
                        {
                            OldDetails.Remove(itemDel);
                        }
                        db.usp_FactorDetail_Edit(detailId, pp.quantity, pp.price, (pp.quantity * pp.price), pp.notes, 0, CauserId, ref mes, ref hasError, pp.ShotCount, pp.Gift);
                    }
                    else
                    {
                        db.usp_FactorDetail_Add(FactorId, pp.ProductId, pp.quantity, pp.price, (pp.quantity * pp.price), pp.notes, 0, CauserId, ref mes, ref hasError, pp.ShotCount, pp.Gift);
                    }
                    if (hasError == 1)
                    {
                        CloseConnectios(db);
                        return new
                        {
                            Result = false,
                            Message = mes.IsNullOrEmpty() ? "خطایی در ثبت اطلاعات رخ داده است" : mes
                        };
                    }
                }
                //حذف بچه هایی که حذف کردند
                if (OldDetails != null && OldDetails.Count > 0)
                {
                    foreach (var ii in OldDetails)
                    {
                        db.usp_FactorDetail_Delete(ii.FD_Id, CauserId, ref mes, ref hasError);
                        if (hasError == 1)
                        {
                            CloseConnectios(db);
                            return new
                            {
                                Result = false,
                                Message = mes.IsNullOrEmpty() ? "خطایی در حذف اطلاعات فرزند رخ داده است" : mes
                            };
                        }
                    }
                }
                if (!IsEdit)
                {
                    if (PaidPrice > 0)
                    {
                        paidType = paidType.ToDecodeNumber();
                        if (paidType.IsNullOrEmpty() || paidType == "0")
                        {
                            CloseConnectios(db);
                            return new
                            {
                                Result = false,
                                Message = "لطفا نوع پرداخت را مشخص کنید"
                            };
                        }
                        long? PaidId = 0;
                        db.usp_FactorPaid_Add(FactorId, fDate, PaidPrice, paidType.ToInt(), refNumber, null, DateTime.Now.TimeOfDay, CauserId, ref mes, ref hasError, ref PaidId);
                        if (hasError == 1)
                        {
                            CloseConnectios(db);
                            return new
                            {
                                Result = false,
                                Message = mes.IsNullOrEmpty() ? "خطایی در ثبت پرداختی فاکتور رخ داده است" : mes
                            };
                        }
                    }
                }

                //اگر فاکتور وضعیتش آماده برای طراحی بود پیامک ارسال شود
                if (factor_status.ToLong() == DefaultDataIDs.FactorStatus_ReadyForDesign && (OldFactorStatus == 0 || factor_status.ToLong() != OldFactorStatus))
                {
                    SetSMS.AfterSetFactor((FactorId ?? 0), db);
                }
                db.Transaction.Commit();
                db.Connection.Close();
                db.Connection.Dispose();
                return new
                {
                    Result = true,
                    Message = "ثبت اطلاعات با موفقیت انجام شد",
                    AddFactor = !IsEdit,
                    FactorId
                };

            }
            catch (Exception ex)
            {
                CloseConnectios(db);
                return new { Result = false, Message = ex.Message };
            }
        }
        [WebMethod]
        public static dynamic GetFactorInfo(long id)
        {
            if (id == 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه فاکتور مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            var FactorInfo = db.usp_Factor_Select_By_Id(id).SingleOrDefault();
            if (FactorInfo.F_Status > DefaultDataIDs.FactorStatus_ReadyForDesign)//اگر وضعیتش بزرگتر از آماده طراحی بود نمیتونه ویرایش کنه چون در دست طراحی هست
            {
                return new
                {
                    Result = false,
                    Message = "وضعیت فاکتور " + FactorInfo.StatusTitle + " هست امکان ویرایش فاکتور وجود ندارد برای انجام ویرایش باید وضعیت فاکتور توسط طراح به وضعیت آماده به طراحی تغییر کند."
                };
            }
            var FactorDetails = db.usp_FactorDetail_By_FactorId(id).ToList();
            FactorDetails = FactorDetails ?? new List<usp_FactorDetail_By_FactorIdResult>();
            string childsInnerHtml = "";
            List<ProductDetails> proDetails = new List<ProductDetails>();
            foreach (var p in FactorDetails)
            {
                proDetails.Add(new ProductDetails()
                {
                    FCId = p.FD_Id,
                    ProductId = p.FD_ProductId,
                    notes = p.FD_Desc,
                    price = p.FD_Fee ?? 0,
                    quantity = p.FD_Count,
                    title = p.ProductTitle,
                    GTitle = p.ProductGroupTitle,
                    ShotCount = p.FD_ShotCount ?? 0,
                    Gift = p.FD_IsGift ?? false
                });
            }
            return new
            {
                Result = true,
                FactorInfo = FactorInfo,
                FactorDetails = proDetails,
                FamilyCodeId = FactorInfo.F_FamilyId.ToCodeNumber(),
                FactorStatusId = FactorInfo.F_Status.ToCodeNumber(),
                TypePhotographiId = FactorInfo.F_TypePhotographyId.ToCodeNumber(),
                PhotographerId = FactorInfo.F_PhotographerId.ToCodeNumber()

            };
        }
        [WebMethod]
        public static dynamic PrintFactor(long id)
        {
            try
            {
                var data = AdakDB.Db.usp_Factor_Select_Product(id).ToList();
                var factorDetail = AdakDB.Db.usp_Factor_Detail(id).Single();

                var variables = new Dictionary<string, string>
                {
                    { "ModPrice", (factorDetail.ModPrice ?? 0).ToString() },
                    { "PaidPrice", (factorDetail.PaidPrice ?? 0).ToString() },
                    { "DiscountPrice", (factorDetail.DiscountPrice ?? 0).ToString() },
                    { "FamilyTitle", factorDetail.FamilyTitle },
                    { "FactorDate", factorDetail.FactorDate },
                    { "FactorDesc", factorDetail.FactorDesc },
                    { "FactorTitle", factorDetail.FactorTitle },
                };

                //string url = $"files/temp/{Guid.NewGuid().ToString("N")}.jpg";
                string url = $"files/temp/{id}.jpg";
                bool ok = AdakStiReportBuilder.WithName("invoice.mrt")
                     .WithData(data)
                     .WithVaiables(variables)
                     .SaveImage(url);

                return new
                {
                    Result = ok,
                    Message = ok ? "ذخیره فاکتور با موفقیت انجام شد" : "خطا درچاپ",
                    Url = url
                };

            }
            catch (Exception ex)
            {
                return new
                {
                    Result = false,
                    Message = "خطایی در ذخیره فاکتور رخ داده است",
                    Url = ex.Message
                };
            }
        }
        [WebMethod]
        public static dynamic SetPay(long IdForPay, long PaidPrice, string PaidType, string RefNumber, string desc, int SubjectTypePay)
        {
            if (IdForPay == 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه مشخص نیست"
                };
            }
            if (SubjectTypePay<=0)
            {
                return new
                {
                    Result = false,
                    Message = "موضوع پرداخت مشخص نیست"
                };
            }
            PaidType = PaidType.ToDecodeNumber();
            if (PaidType.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "طریقه پرداخت را مشخص کنید"
                };
            }
            if (PaidPrice <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "مبلغ پرداخت را مشخص کنید"
                };
            }
            var db = AdakDB.Db;
            int? haserror = 0;
            string mes = "";
            long? resultId = 0;
            if (db.Connection.State != System.Data.ConnectionState.Open)
            {
                db.Connection.Open();
            }
            db.Transaction = db.Connection.BeginTransaction();
            db.usp_Paids_Add(IdForPay, byte.Parse(SubjectTypePay.ToString()), DateTime.Now.ToShamsi(), PaidPrice, PaidType.ToInt(), RefNumber, desc, DateTime.Now.TimeOfDay, LoginedUser.Id, ref mes, ref haserror, ref resultId);
            if (haserror == 1)
            {
                CloseConnectios(db);
                return new
                {
                    Result = false,
                    Message = mes.IsNullOrEmpty() ? "خطایی در ثبت اطلاعات رخ داده است" : mes
                };
            }
            //پرداختی بابت فاکتور بود
            else if (SubjectTypePay == 1)
            {
                var facinfo = db.usp_Factor_Select_By_Id(IdForPay).SingleOrDefault();
                facinfo = facinfo ?? new usp_Factor_Select_By_IdResult();
                if ((facinfo.F_Status == DefaultDataIDs.FactorStatus_IncompleteFactor || facinfo.F_Status == DefaultDataIDs.FactorStatus_WaitForPaid) && facinfo.F_Status != DefaultDataIDs.FactorStatus_ReadyForDesign && (((facinfo.F_PaidPrice + facinfo.F_SumDiscountPrice) * 100) / facinfo.F_SumPrice) >= 50)
                {
                    db.usp_Factor_ChangeStatus(IdForPay, DefaultDataIDs.FactorStatus_ReadyForDesign, LoginedUser.Id, "تغییر وضعیت اتوماتیک پس از پرداخت فاکتور");
                }
            }
            db.Transaction.Commit();
            db.Connection.Close();
            db.Connection.Dispose();
            return new
            {
                Result = haserror == 0,
                Message = haserror == 0 ? "ثبت با موفقیت انجام شد" : mes
            };
        }
    }
    public class FactorForGrid
    {
        public int Row { get; set; }
        public string FactorNumber { get; set; }
        public string FamilyTitle { get; set; }
        public string FactorDate { get; set; }
        public string SumFactor { get; set; }
        public string SumDiscount { get; set; }
        public string Payable { get; set; }
        public string FinanStatus { get; set; }
        public string Actions { get; set; }
        public string PaidPrice { get; set; }
        public string TypePhotographi { get; set; }
        public string FactorStatus { get; set; }
        public string Photographer { get; set; }
        public string Designer { get; set; }
        public string ForceDesign { get; set; }
        public string IsGift { get; set; }

    }
    public class ProductDetails
    {
        public long FCId { get; set; }
        public long ProductId { get; set; }
        public string title { get; set; }
        public decimal price { get; set; }
        public int quantity { get; set; }
        public string notes { get; set; }
        public string GTitle { get; set; }
        public int ShotCount { get; set; }
        public bool Gift { get; set; }

    }
}