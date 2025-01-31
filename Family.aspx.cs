using Bank;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class Family : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role != DefaultDataIDs.Role_Admin && LoginedUser.Role != DefaultDataIDs.Role_Secretary)
            {
                Response.Redirect("Logout.aspx");
            }
        }
        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string searchText, string fromDate, string todate, bool Only_Archive, string CauserId, string HospitalId, string InviteType)
        {
            perPage = perPage == 0 ? 10 : perPage;
            searchText = searchText.Trim();
            int? countt = 0;
            fromDate = fromDate.ToEnglishNumber();
            todate = todate.ToEnglishNumber();
            InviteType = InviteType.ToDecodeNumber();
            CauserId = CauserId.ToDecodeNumber();
            HospitalId = HospitalId.ToDecodeNumber();
            var data = AdakDB.Db.usp_Family_Select_For_Grid_New(searchText, page, perPage, ref countt, CauserId.ToLong(), fromDate, todate, Only_Archive, HospitalId.ToLong(), InviteType.ToLong()).ToList();
            data = data ?? new List<Bank.usp_Family_Select_For_Grid_NewResult>();
            List<FamilyForGrid> list = new List<FamilyForGrid>();
            data.ForEach(x => list.Add(new FamilyForGrid()
            {
                Title = x.F_Title,
                Row = 1,
                FatherFullName = x.FatherFullName,
                MotherFullName = x.MotherFullName,
                MotherMobile = x.F_MotherMobile,
                CauserName = x.CauserName,
                FatherMobile = x.F_FatherMobile,
                Desc = x.F_Desc,
                Date_A_Time = x.F_CreationTime.ToShamsi() + "-" + x.F_CreationTime.TimeOfDay.ToString().Substring(0, 5),
                Status = !x.F_Archive ? "<div class='badge badge-light-success'>فعال</div>" : "<div class='badge badge-light-danger'>غیرفعال</div>",
                Actions = @"

                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#modal_addedit_family' onclick='GetInfoForEditFamily(""" + x.F_Id.ToCodeNumber() + @""")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='FamilyDelete(""" + x.F_Id.ToCodeNumber() + @""")' title='حذف'>🗑</button>
                </div>
                "
            })); ;


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
        protected static void CloseConnectios(Bank.AdakBankDataContext db)
        {
            try { db.Transaction?.Rollback(); } catch { };
            try { db.Connection.Close(); } catch { };
            try
            { db.Dispose(); }
            catch { };
        }
        [WebMethod]
        public static dynamic AddEditFamily(string id, string m_name, string m_lastname, string f_name, string f_lastname, bool archive, string desc, string f_mobile, string m_mobile, string phone, string title, string address, string[] childNames, bool[] childSexs, string[] childBirthDates, string[] childIds, string[] Hospitals, bool FromHospital, string MotherBirthDate, string FatherBirthDate, string MarriageDate, string InviteTypeId)
        {
            var db = AdakDB.Db;
            try
            {
                id = id.ToDecodeNumber();
                InviteTypeId = InviteTypeId.ToDecodeNumber();
                if (title.Trim().IsNullOrEmpty())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا عنوان خانوادگی را مشخص کنید"
                    };
                }
                if (!m_mobile.IsNullOrEmpty() && !m_mobile.IsMobileNumber())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا شماره همراه مادر را بدرستی وارد کنید"
                    };
                }
                if (!f_mobile.IsNullOrEmpty() && !f_mobile.IsMobileNumber())
                {
                    return new
                    {
                        Result = false,
                        Message = "لطفا شماره همراه پدر را بدرستی وارد کنید"
                    };
                }
                int? hasError = 0;
                string mes = "";
                long CauserId = LoginedUser.Id;// LoginedUser.Id == null ? 0 : LoginedUser.Id;
                bool IsEdit = false;
                long? FamilyId = id.IsNullOrEmpty() ? 0 : id.ToLong();
                List<usp_FamilyChild_By_FamilyIdResult> OldChilds = new List<usp_FamilyChild_By_FamilyIdResult>();
                if (db.Connection.State != System.Data.ConnectionState.Open)
                {
                    db.Connection.Open();
                }
                db.Transaction = db.Connection.BeginTransaction();
                //ثبت اطلاعات خانواده
                if (FamilyId == 0)
                {
                    db.usp_Family_Add_14031018(title, f_name, f_lastname, m_name, m_lastname, m_mobile, f_mobile, null, null, address, !archive, null, null, phone, desc, MarriageDate.ToEnglishNumber(), CauserId, ref mes, ref hasError, ref FamilyId, MotherBirthDate.ToEnglishNumber(), FatherBirthDate.ToEnglishNumber(), InviteTypeId.ToLong());
                }
                else
                {
                    IsEdit = true;
                    db.usp_Family_Edit_14031018(FamilyId, title, f_name, f_lastname, m_name, m_lastname, m_mobile, f_mobile, null, null, address, !archive, null, null, phone, desc, MarriageDate.ToEnglishNumber(), CauserId, ref mes, ref hasError, MotherBirthDate.ToEnglishNumber(), FatherBirthDate.ToEnglishNumber(), InviteTypeId.ToLong());
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
                    OldChilds = db.usp_FamilyChild_By_FamilyId(FamilyId).ToList();
                }
                if (childNames != null && childNames.Length > 0)
                {
                    for (int i = 0; i < childNames.Length; i++)
                    {
                        long childId = childIds[i].IsNullOrEmpty() ? 0 : childIds[i].ToDecodeNumber().ToLong();
                        if (childId > 0)
                        {
                            var itemDel = OldChilds.SingleOrDefault(a => a.FC_Id == childId);
                            if (itemDel != null)
                            {
                                OldChilds.Remove(itemDel);
                            }
                            db.usp_FamilyChild_Edit(childId, childNames[i], childSexs[i], childBirthDates[i].ToEnglishNumber(), CauserId, ref mes, ref hasError, Hospitals[i].ToDecodeNumber().ToLong());
                        }
                        else
                        {
                            long? childId_result = 0;
                            db.usp_FamilyChild_Add(FamilyId, childNames[i], childSexs[i], childBirthDates[i].ToEnglishNumber(), CauserId, ref mes, ref hasError, ref childId_result, Hospitals[i].ToDecodeNumber().ToLong());
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
                }
                //حذف بچه هایی که حذف کردند
                if (OldChilds != null && OldChilds.Count > 0)
                {
                    foreach (var ii in OldChilds)
                    {
                        db.usp_FamilyChild_Delete(ii.FC_Id, CauserId, ref mes, ref hasError);
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
                //برای خانواده هایی که در بیمارستان ثبت میکنند پیامک ارسال می شود
                if (FromHospital)
                {
                    SetSMS.Wellcome_To_Family_FromHospital(title, f_mobile, m_mobile, (FamilyId ?? 0), db);
                }
                db.Transaction.Commit();
                db.Connection.Close();
                db.Connection.Dispose();
                return new
                {
                    Result = true,
                    Message = "ثبت اطلاعات با موفقیت انجام شد"
                };

            }
            catch (Exception ex)
            {
                CloseConnectios(db);
                return new { Result = false, Message = ex.Message };
            }
        }
        [WebMethod]
        public static dynamic GetFamilyInfo(string id)
        {
            id = id.ToDecodeNumber();
            if (id.IsNullOrEmpty() || id == "0")
            {
                return new
                {
                    Result = false,
                    Message = "شناسه خانواده مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            var FamilyInfo = db.usp_Family_Select_By_Id(id.ToLong()).SingleOrDefault();
            var Familychilds = db.usp_FamilyChild_By_FamilyId(id.ToLong()).ToList();
            Familychilds = Familychilds ?? new List<usp_FamilyChild_By_FamilyIdResult>();
            string childsInnerHtml = "";
            foreach (var child in Familychilds)
            {
                childsInnerHtml += @"<tr>
                                <td>
                                    <input name='childId' value=""" + child.FC_Id.ToCodeNumber() + @""" type='text' class='form - control' hidden>
                                    <input name = 'childName' value=""" + child.FC_Name + @""" type='text' class='form-control' placeholder='نام فرزند' required>
                                </td>
                                <td>
                                    <label class='form-check form-switch form-check-custom form-check-solid'>
                                        <span class='form-check-label fw-bold text-muted' style ='margin: 5px;' for='kt_modal_add_customer_billing'>دختر</span>
                                        <input class='form-check-input' name='childSex' style ='margin: 5px;' type='checkbox' " + (child.FC_Sex ? "checked" : "") + @" />
                                        <span class='form-check-label fw-bold text-muted' style ='margin: 5px;' for='kt_modal_add_customer_billing'>پسر</span>
                                    </label>
                                </td>
                                <td>
                                    <input id='fDate_" + child.FC_Id + @"' name='childBirthDate' type='text' class='form-control datepickerBirthDate' placeholder='تاریخ تولد'>
                                </td>
                                <td>
                                    <select name='childHospital'>
                                        " + PublicMethod.GetHospitals(child.FC_HospitalId ?? 0) + @"
                                    </select>
                                </td>
                                <td>
                                    <button class='btn btn-danger btn-remove'>حذف</button>
                                </td></tr>";
            }

            return new
            {
                Result = true,
                FamilyInfo = FamilyInfo,
                Childs = childsInnerHtml,
                Familychilds,
                InviteTypeIdCoded = FamilyInfo.F_InviteTypeId.ToCodeNumber()
            };
        }

        [WebMethod]
        public static dynamic FamilyDelete(string id)
        {
            id = id.ToDecodeNumber();
            if (id.IsNullOrEmpty() || id == "0")
            {
                return new
                {
                    Result = false,
                    Message = "شناسه خانواده مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            int? haserror = 0;
            string mes = "";
            db.usp_Family_Delete(id.ToLong(), LoginedUser.Id, ref mes, ref haserror);
            return new
            {
                Result = haserror == 0,
                Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
            };
        }
        [WebMethod]
        public static List<Customer_ForCombo> GetCustomer_ForCombo()
        {
            var family = AdakDB.Db.usp_Family_Select_ForCombo().ToList();
            family = family ?? new List<Bank.usp_Family_Select_ForComboResult>();
            List<Customer_ForCombo> clist = new List<Customer_ForCombo>();
            int index = 1;
            foreach (var item in family)
            {
                clist.Add(new Customer_ForCombo()
                {
                    Value = item.F_ID.ToCodeNumber(),
                    Title = item.FamilyTitle,
                    Index = index
                });
                index++;
            }
            return clist;
        }
    }
    public class Customer_ForCombo
    {
        public string Value { get; set; }
        public string Title { get; set; }
        public int Index { get; set; }
    }
    public class Childs
    {
        public string Name { get; set; }
        public string BDate { get; set; }
        public bool Sex { get; set; }
        public string Id { get; set; }
    }
    public class FamilyForGrid
    {
        public int Row { get; set; }
        public string Title { get; set; }
        public string MotherFullName { get; set; }
        public string FatherFullName { get; set; }
        public string MotherMobile { get; set; }
        public string FatherMobile { get; set; }
        public string Status { get; set; }
        public string Actions { get; set; }
        public string Date_A_Time { get; set; }
        public string CauserName { get; set; }
        public string Desc { get; set; }

    }
}