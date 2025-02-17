using Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class RequestStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Role == DefaultDataIDs.Role_PhotographerInHospital)
            {
                Response.Redirect("AddFamilyFromHospital.aspx");
            }
        }
        [WebMethod]
        public static dynamic GetFactors(string searchText, string fromdate, string todate, string causer)
        {
            string html = "";
            List<FactorStat> htmls = new List<FactorStat>();
            fromdate = fromdate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            causer = causer.ToDecodeNumber();
            long RoleId = LoginedUser.Role;
            long LoginnedCauserId = LoginedUser.Id;
            try
            {
                var factorStatus = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_FactorStatus).ToList();
                var factors = AdakDB.Db.usp_FactorsNotArchive_For_Tracking(searchText, fromdate, todate, causer.ToLong()).ToList();
                List<usp_Data_Select_By_TypeIdResult> fs_List = new List<usp_Data_Select_By_TypeIdResult>();
                List<usp_FactorsNotArchive_For_TrackingResult> factorForShow = new List<usp_FactorsNotArchive_For_TrackingResult>();
                ///گرفتن اولویت آماده طراحی
                int pariReadyForDesign = factorStatus.Where(a => a.D_ID == DefaultDataIDs.FactorStatus_ReadyForDesign).SingleOrDefault().D_Priority ?? 0;
                //گرفتن اولویت ارسال به چاپ خانه
                int pariSendTo_PrintingHouse = factorStatus.Where(a => a.D_ID == DefaultDataIDs.FactorStatus_SendTo_PrintingHouse).SingleOrDefault().D_Priority ?? 0;
                //محدود کردن وضعیت ها براساس رول طراح و سرپرست طراحی
                if (RoleId == DefaultDataIDs.Role_Designer || RoleId == DefaultDataIDs.Role_DesignSupervisor)//طراح یا سوپروایزر طراحی بود
                {
                    ///گرفتن اولویت آماده طراحی
                    int pariSendToPrintingHouse = factorStatus.Where(a => a.D_ID == DefaultDataIDs.FactorStatus_SendTo_PrintingHouse).SingleOrDefault().D_Priority ?? 0;
                    //اگر طراح بود فقط تا مرحله ارسال به چاپ خانه رو بتونه ببینه
                    fs_List = factorStatus.Where(a => a.D_Priority >= pariReadyForDesign && a.D_Priority <= pariSendToPrintingHouse).ToList().OrderBy(a => a.D_Priority).ToList();
                }
                else
                {
                    fs_List = factorStatus.OrderBy(a => a.D_Priority).ToList();
                }
                string PersonnelName_For_DesignSupervisor = @"<span class='customer-name'>PersonnelName</span>";
                var designers = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Designer).ToList();
                //فیلتر کردن فاکتورها برای رول دیزاینر
                if (RoleId == DefaultDataIDs.Role_Designer)
                {
                    //اگر رول طراح بود فقط فاکتورهای خودشو باید ببینه به علاوه اونهایی که آماده به طراحی هست
                    factors = factors.Where(a => a.FactorStatus == DefaultDataIDs.FactorStatus_ReadyForDesign || a.DesignerId == LoginedUser.Id).ToList();
                }
                //اگر سرپرست طراحی بود باید فاکتورهای بقیه طراح هارو هم ببینه
                else if (RoleId == DefaultDataIDs.Role_DesignSupervisor)
                {
                    //اگر رول طراح بود فقط فاکتورهای خودشو باید ببینه به علاوه اونهایی که آماده به طراحی هست
                    factors = factors.Where(a => a.FactorStatus == DefaultDataIDs.FactorStatus_ReadyForDesign ||
                                                 a.DesignerId == LoginedUser.Id ||
                                                 designers.Exists(b => b.P_Id == a.DesignerId)
                                                 ).ToList();
                }
                //اگر رول شخص لاگین شده دیزاینر نبود باید به ازای طراح هاش ستون باشه واسامی شون رو بببینه
                int cnt = 0;
                if (RoleId == DefaultDataIDs.Role_DesignSupervisor)
                {
                    designers.Add(new usp_Personnel_By_RoleResult()
                    {
                        P_Id = LoginedUser.Id,
                    });
                }
                else if (RoleId == DefaultDataIDs.Role_Admin || RoleId == DefaultDataIDs.Role_Secretary)
                {
                    var Supervisordesigners = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_DesignSupervisor).ToList();
                    designers = designers ?? new List<usp_Personnel_By_RoleResult>();
                    foreach (var item in Supervisordesigners)
                    {
                        designers.Add(item);
                    }

                }
                foreach (var fs in fs_List)
                {
                    html = "";
                    if (fs.D_ID == DefaultDataIDs.FactorStatus_UnderDesign && RoleId != DefaultDataIDs.Role_Designer)
                    {
                        foreach (var per in designers)
                        {
                            factorForShow = factors.Where(a => a.FactorStatus == DefaultDataIDs.FactorStatus_UnderDesign && a.DesignerId == per.P_Id).ToList().OrderByDescending(b => b.ForceDesign).ThenBy(d => d.LastLogDate).ToList();
                            cnt = factorForShow.Count;
                            html += @"<div class='column' id='column_" + fs.D_ID + @"_" + per.P_Id + @"'>
                                        <h3>" + (per.P_Id == LoginedUser.Id ? "خودم" : per.FullName) + " <span id='cnt_div_" + fs.D_ID + @"' style='background-color: #08c5f7; color: white; padding:3px; border-radius: 5px;'> " + cnt + @"</span></h3>
                                        <div id='dz_" + fs.D_ID + @"' class='dropzone_FS h-100'>";

                            foreach (var fac in factorForShow)
                            {
                                html += @"<div class='task" + (fac.ModPrice > 0 ? " unpaid" : "") + @"' id='task_" + fs.D_ID + @"_" + fac.FactorID + @"' " + (
                                                                RoleId == DefaultDataIDs.Role_Admin || //ادمین بود دسترسی به همه چی داشته باشه
                                                                RoleId == DefaultDataIDs.Role_DesignSupervisor ||
                                                                (RoleId == DefaultDataIDs.Role_Secretary && (fs.D_ID == DefaultDataIDs.FactorStatus_IncompleteFactor || fs.D_ID == DefaultDataIDs.FactorStatus_WaitForPaid || fs.D_Priority >= pariSendTo_PrintingHouse)) ?
                                                                        @" draggable='true' ondragstart='drag(event)'" : "")
                                                                 + @">
                                                <div class='task-header'>
                                                    <span class='customer-name'>" + PublicMethod.Tag_A_for_Family(fac.FamilyTitle, fac.FamilyId.ToCodeNumber()) + @"</span>
                                                    " + (RoleId == DefaultDataIDs.Role_DesignSupervisor && fac.DesignerId != LoginnedCauserId ? PersonnelName_For_DesignSupervisor.Replace("PersonnelName", per.FullName) : "") + @"
                                                    <span class='date'>" + fac.FactorDate + @"</span>
                                                    
                                                </div>
                                                <div class='task-footer'>
                                                    " + ((fac.ForceDesign ?? false) ? "<span class='force-design-label'>طراحی فورس</span>" : "") + @"
                                                    " + (fac.ModPrice > 0 && (RoleId == DefaultDataIDs.Role_Admin || RoleId == DefaultDataIDs.Role_Secretary) ? @"<button class='btnDataTable btnDataTable-print' data-bs-toggle='modal' data-bs-target='#m_SetPaidPrice' onclick='PayFactor_Or_Turn(" + fac.FactorID + @"," + (fac.ModPrice) + @",1)' title='پرداخت'>💰</button>" : "") + @" 
                                                    <span class='edit-btn' data-bs-target='#m_DetailFactor' data-bs-toggle='modal' onclick='FactorDetail(" + fac.FactorID + @")'>جزئیات</span>
                                                </div>
                                            </div>";
                            }
                            html += "</div>\r\n </div>";
                        }
                    }
                    else
                    {
                        factorForShow = factors.Where(a => a.FactorStatus == fs.D_ID).ToList().OrderByDescending(b => b.ForceDesign).ThenBy(d => d.LastLogDate).ToList();
                        cnt = factorForShow.Count;
                        html += @"<div class='column' id='column_" + fs.D_ID + @"'>
                                        <h3>" + fs.D_Title + " <span id='cnt_div_" + fs.D_ID + @"' style='background-color: #08c5f7; color: white; padding:3px; border-radius: 5px;'>" + cnt + @"</span></h3>
                                        <div id='dz_" + fs.D_ID + @"' class='dropzone_FS h-100'>";

                        foreach (var fac in factorForShow)
                        {
                            html += @"<div class='task" + (fac.ModPrice > 0 ? " unpaid" : "") + @"' id='task_" + fs.D_ID + @"_" + fac.FactorID + @"' " + (
                                                            RoleId == DefaultDataIDs.Role_Admin || //ادمین بود دسترسی به همه چی داشته باشه
                                                            (RoleId == DefaultDataIDs.Role_Secretary && (fs.D_ID == DefaultDataIDs.FactorStatus_IncompleteFactor || fs.D_ID == DefaultDataIDs.FactorStatus_WaitForPaid || fs.D_Priority >= pariSendTo_PrintingHouse)) ||
                                                            ((RoleId == DefaultDataIDs.Role_Designer || RoleId == DefaultDataIDs.Role_DesignSupervisor) && (fs.D_ID != DefaultDataIDs.FactorStatus_SendTo_PrintingHouse)) ?
                                                                    @" draggable='true' ondragstart='drag(event)'" :
                                                                    "")
                                                             + @">
                                                <div class='task-header'>
                                                    <span class='customer-name'>" + PublicMethod.Tag_A_for_Family(fac.FamilyTitle, fac.FamilyId.ToCodeNumber()) + @"</span>
                                                    " + (RoleId == DefaultDataIDs.Role_DesignSupervisor && fac.DesignerId != LoginnedCauserId ? PersonnelName_For_DesignSupervisor.Replace("PersonnelName", fac.DesignerFullName) : "") + @"
                                                    <span class='date'>" + fac.FactorDate + @"</span>
                                                    
                                                </div>
                                                <div class='task-footer'>
                                                    " + ((fac.ForceDesign ?? false) ? "<span class='force-design-label'>طراحی فورس</span>" : "") + @"
                                                    " + ((fac.FactorStatus == DefaultDataIDs.FactorStatus_DeliveredToCustomer) ? "<span class='edit-btn' onclick='DeliveredFactor(" + fac.FactorID + @"," + fs.D_ID + @")'>اتمام</span>" : "") + @"
                                                    " + (fac.ModPrice > 0 && (RoleId == DefaultDataIDs.Role_Admin || RoleId == DefaultDataIDs.Role_Secretary) ? @"<button class='btnDataTable btnDataTable-print' data-bs-toggle='modal' data-bs-target='#m_SetPaidPrice' onclick='PayFactor_Or_Turn(" + fac.FactorID + @"," + (fac.ModPrice) + @",1)' title='پرداخت'>💰</button>" : "") + @" 
                                                    <span class='edit-btn' data-bs-target='#m_DetailFactor' data-bs-toggle='modal' onclick='FactorDetail(" + fac.FactorID + @")'>جزئیات</span>
                                                </div>
                                            </div>";
                        }
                        html += "</div>\r\n </div>";
                    }
                    htmls.Add(new FactorStat()
                    {
                        ColumnHtml = html,
                        ColumnId = "column_" + fs.D_ID,
                        ZoneId = "dz_" + fs.D_ID
                    });
                }

                return new
                {
                    Htmls = htmls,
                    Result = true
                };
            }
            catch (Exception ex)
            {
                return new
                {
                    Html = ex.Message,
                    Result = false
                };
            }
        }

        [WebMethod]
        public static dynamic ChangeFactorStatus(string sourceFS, string factorId, string DesFS, bool updateDesigner, string designerId)
        {
            if (updateDesigner && designerId.IsNullOrEmpty())
            {
                designerId = LoginedUser.Id.ToString();
            }
            string mes = "";
            int? haserror = 0;

            if (LoginedUser.Role == DefaultDataIDs.Role_Designer)
            {
                updateDesigner = true;
                designerId = LoginedUser.Id.ToString();
            }

            AdakDB.Db.usp_FactorChangeStatus(factorId.ToLong(), sourceFS.ToLong(), DesFS.ToLong(), LoginedUser.Id, updateDesigner, designerId.ToLong(), ref mes, ref haserror);
            return new
            {
                Result = haserror == 0,
                Message = mes
            };
        }

        [WebMethod]
        public static dynamic AddFactorLog(long FactorId, string logtext)
        {
            if (logtext.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "لطفا توضیحات را مشخص کنید"
                };
            }
            AdakDB.Db.usp_FactorLog_Add(FactorId, LoginedUser.Id, logtext);
            return new
            {
                Result = true,
                Message = ""
            };
        }

        [WebMethod]
        public static dynamic FactorLogs(long FactorId)
        {
            string html = "";
            int? haserror = 0;
            var LogList = AdakDB.Db.usp_FactorLog_Select(FactorId);
            foreach (var item in LogList)
            {
                html += @"<li class='log-item'>
                            <span class='log-details'>تاریخ: " + item.Date + @" - ساعت: " + item.Time + @" - ثبت‌ کننده: " + item.CauserName + @"</span>
                            <span class='log-text'>" + item.FL_LogText + @"</span>
                         </li>";
            }
            return new
            {
                Result = true,
                Message = html
            };
        }
        [WebMethod]
        public static dynamic FactorDetail(long FactorId)
        {
            var FactorDetails = AdakDB.Db.usp_FactorDetail_By_FactorId(FactorId).ToList();
            var facinfo = AdakDB.Db.usp_Factor_Select_By_Id(FactorId).SingleOrDefault();
            var familyInfo = AdakDB.Db.usp_Family_Select_By_Id(facinfo.F_FamilyId).SingleOrDefault();
            FactorDetails = FactorDetails ?? new List<usp_FactorDetail_By_FactorIdResult>();
            List<ProductDetails_ForStatus> proDetails = new List<ProductDetails_ForStatus>();
            foreach (var p in FactorDetails)
            {
                proDetails.Add(new ProductDetails_ForStatus()
                {
                    ProductId = p.FD_ProductId,
                    notes = p.FD_Desc,
                    price = p.FD_Fee ?? 0,
                    quantity = p.FD_Count,
                    title = p.ProductTitle,
                    GTitle = p.ProductGroupTitle,
                    ShotCount = p.FD_ShotCount ?? 0,
                    Gift = p.FD_IsGift ?? false,

                });
            }
            return new
            {
                Result = true,
                Products = proDetails,
                FamilyTitle = (familyInfo.F_Title + (familyInfo.F_MotherMobile.IsMobileNumber() ? " - M " + familyInfo.F_MotherMobile : "") + (familyInfo.F_FatherMobile.IsMobileNumber() ? " - F " + familyInfo.F_FatherMobile : ""))
            };
        }
        [WebMethod]
        public static dynamic DeliveredFactor(long FactorId)
        {
            if (FactorId <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه فاکتور مشخص نیست"
                };
            }
            string mes = "";
            int? haserror = 0;
            AdakDB.Db.usp_Factor_Set_Delivered(FactorId, true, LoginedUser.Id);
            return new
            {
                Result = true,
                Message = ""
            };
        }

        [WebMethod]
        public static dynamic FactorInfo(long FactorId)
        {
            var FactorDetails = AdakDB.Db.usp_FactorDetail_By_FactorId(FactorId).ToList();
            var facinfo = AdakDB.Db.usp_Factor_Select_By_Id(FactorId).SingleOrDefault();
            var familyInfo = AdakDB.Db.usp_Family_Select_By_Id(facinfo.F_FamilyId).SingleOrDefault();
            return new
            {
                Result = true,
                Desc = facinfo.F_Desc,
                FamilyTitle = (familyInfo.F_Title + (familyInfo.F_MotherMobile.IsMobileNumber() ? " - M " + familyInfo.F_MotherMobile : "") + (familyInfo.F_FatherMobile.IsMobileNumber() ? " - F " + familyInfo.F_FatherMobile : ""))
            };
        }
    }
    public class FactorStat
    {
        public string ZoneId { get; set; }
        public string ColumnId { get; set; }
        public string ColumnHtml { get; set; }

    }
    public class ProductDetails_ForStatus
    {
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