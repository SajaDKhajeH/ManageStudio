<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="AddFamilyFromHospital.aspx.cs" Inherits="AddFamilyFromHospital" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="post d-flex-column-auto flex-column-fluid">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="modal-body py-10 px-lg-17">
                            <div class="scroll-y me-n7 pe-7" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-offset="300px">
                                <div class="row g-9 mb-7">
                                    <div class="col-md-6 fv-row">
                                        <input id="h_m_name" maxlength="20" class="form-control form-control-solid" placeholder="نام مادر" name="firstname" value="" />
                                    </div>
                                    <div class="col-md-6 fv-row">
                                        <input id="h_m_lastname" maxlength="30" onchange="ChangeTitleFamily_Hospital()" class="form-control form-control-solid" placeholder="نام خانوادگی مادر" name="lastname" value="" />
                                    </div>
                                </div>
                                <div class="row g-9 mb-7">
                                    <div class="col-md-6 fv-row">
                                        <input id="h_f_name" maxlength="20" class="form-control form-control-solid" placeholder="نام پدر" name="firstname" value="" />
                                    </div>
                                    <div class="col-md-6 fv-row">
                                        <input id="h_f_lastname" maxlength="30" onchange="ChangeTitleFamily_Hospital()" class="form-control form-control-solid" placeholder="نام خانوادگی پدر" name="lastname" value="" />
                                    </div>
                                </div>
                                <div class="row g-9 mb-7">
                                    <div class="col-md-6 fv-row">
                                        <input id="h_m_mobile" maxlength="11" class="form-control form-control-solid" placeholder="شماره همراه مادر" name="lastname" value="" />
                                    </div>
                                    <div class="col-md-6 fv-row">
                                        <input id="h_f_mobile" maxlength="11" class="form-control form-control-solid" placeholder="شماره همراه پدر" name="lastname" value="" />
                                    </div>
                                </div>
                                <div class="row g-9 mb-7">
                                    <div class="col-md-6 fv-row">
                                        <input type="text" maxlength="50" id="h_f_title" class="form-control form-control-solid" placeholder="عنوان خانوادگی" />
                                    </div>
                                    <div class="col-md-6 fv-row">
                                        <input id="h_f_phone" maxlength="14" class="form-control form-control-solid" placeholder="شماره منزل" value="" />
                                    </div>
                                </div>
                                <div class="row g-9 mb-7">
                                    <div class="form-container">
                                        <h3 class="text-center mb-4">افزودن اطلاعات فرزندان</h3>

                                        <!-- دکمه افزودن فرزند -->
                                        <div class="d-flex justify-content-end">
                                            <button id="addRowButtonChild_Hospital" class="btn btn-primary" style="margin: 7px">افزودن فرزند</button>
                                        </div>

                                        <!-- جدول -->
                                        <table id="tbChild_Hospital" class="table table-bordered text-center">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>نام</th>
                                                    <th>جنسیت</th>
                                                    <th>تاریخ تولد</th>
                                                    <th>بیمارستان</th>
                                                    <th>عملیات</th>
                                                </tr>
                                            </thead>
                                            <tbody id="childrenTableBody_Hospital">
                                                <!-- سطرها به صورت داینامیک اضافه می‌شوند -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="row g-9 mb-7">
                                    <div class="col-md-12 fv-row">
                                        <input type="text" id="h_f_address" class="form-control form-control-solid" placeholder="آدرس منزل" />
                                    </div>
                                </div>
                                <div class="fv-row mb-15">
                                    <input type="text" id="h_f_desc" class="form-control form-control-solid" placeholder="توضیحات" name="description" />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer flex-center">
                            <button id="btn_submitdataFamily_FromHospital" class="btn btn-primary">ثبت اطلاعات</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script src="assets/js/hospital/forcmb.js"></script>
    <script>
        const childrenTableBody_H = document.getElementById('childrenTableBody_Hospital');
        const addRowButtonChild_H = document.getElementById('addRowButtonChild_Hospital');
        // افزودن سطر جدید به جدول
        addRowButtonChild_H.addEventListener('click', () => {
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td>
                    <input name="childId" type="text" class="form-control" hidden>
                    <input name="childName" type="text" class="form-control" placeholder="نام فرزند" required>
                </td>
                <td>
                    <label class="form-check form-switch form-check-custom form-check-solid">
                        <span class="form-check-label fw-bold text-muted" style="margin: 5px;" for="kt_modal_add_customer_billing">دختر</span>
                        <input class="form-check-input" name="childSex" style="margin: 5px;" type="checkbox" checked="checked" />
                        <span class="form-check-label fw-bold text-muted" style="margin: 5px;" for="kt_modal_add_customer_billing">پسر</span>
                    </label>
                </td>
                <td>
                     <input name="childBirthDate" type="text" class="form-control datepicker newdatepicker" placeholder="تاریخ تولد">
                </td>
                <td>
                    <select name="childHospital">
                        ${hospitalsHtml}
                    </select>
                </td>
                <td>
                    <button class="btn btn-danger btn-remove">حذف</button>
                </td>
            `;
            childrenTableBody_H.appendChild(newRow);

            $('.newdatepicker').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: true,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
        });
        // حذف سطر
        childrenTableBody_H.addEventListener('click', (e) => {
            if (e.target.classList.contains('btn-remove')) {
                const row = e.target.closest('tr');
                row.remove();
            }
        });
        function ResetFeildsFamily_Hospital() {
            btnAddEdit_ChangeDisable("btn_submitdataFamily_FromHospital", false);
            $("#h_m_name").val("");
            $("#h_m_lastname").val("");
            $("#h_m_mobile").val("");
            $("#h_f_name").val("");
            $("#h_f_lastname").val("");
            $("#h_f_mobile").val("");
            $("#h_f_phone").val("");
            $("#h_f_title").val("");
            $("#h_f_address").val("");
            $("#h_f_desc").val("");
            childrenTableBody_H.innerHTML = "";
        };
        function ChangeTitleFamily_Hospital() {
            var m_lastname = $("#h_m_lastname").val();
            var f_lastname = $("#h_f_lastname").val();
            if (m_lastname != null && m_lastname.length > 0 && f_lastname != null && f_lastname.length > 0) {
                $("#h_f_title").val(m_lastname + " / " + f_lastname);
            }
            else if (m_lastname != null && m_lastname.length > 0) {
                $("#h_f_title").val(m_lastname);
            }
            else if (f_lastname != null && f_lastname.length > 0) {
                $("#h_f_title").val(f_lastname);
            }
        };
        $("#btn_submitdataFamily_FromHospital").click(function () {
            var childNames = document.getElementsByName("childName");
            var childIds = document.getElementsByName("childId");
            var childSexs = document.getElementsByName("childSex");
            var childHospitals = document.getElementsByName("childHospital");
            var childBirthDates = document.getElementsByName("childBirthDate");
            var childNamesArray = [];
            var childIdsArray = [];
            var childSexArray = [];
            var childHospitalArray = [];
            var childBirthDateArray = [];
            for (var i = 0; i < childNames.length; i++) {
                if (childNames[i].value.trim() == "") {
                    alert("لطفا نام فرزند را مشخص کنید");
                    return;
                }
                if (childBirthDates[i].value.trim() == "") {
                    alert("لطفا تاریخ تولد فرزند را مشخص کنید");
                    return;
                }
                childHospitalArray.push(childHospitals[i].value);
                childNamesArray.push(childNames[i].value);
                childSexArray.push(childSexs[i].checked);
                childBirthDateArray.push(childBirthDates[i].value);
                childIdsArray.push(childIds[i].value);
            }
            var m_name = $("#h_m_name").val();
            var m_lastname = $("#h_m_lastname").val();
            var f_name = $("#h_f_name").val();
            var f_lastname = $("#h_f_lastname").val();
            var m_mobile = $("#h_m_mobile").val();
            var f_mobile = $("#h_f_mobile").val();
            var phone = $("#h_f_phone").val();
            var title = $("#h_f_title").val();
            var address = $("#h_f_address").val();
            var desc = $("#h_f_desc").val();
            btnAddEdit_ChangeDisable("btn_submitdataFamily_FromHospital", true);

            //let data = {
            //    id: "", m_name: m_name, m_lastname: m_lastname,
            //    f_name: f_name, f_lastname: f_lastname, archive: false,
            //    desc: desc, f_mobile: f_mobile, m_mobile: m_mobile,
            //    phone: phone, title: title, address: address,
            //    childNames: childNamesArray, childSexs: childSexArray, childBirthDates: childBirthDateArray, childIds: childIdsArray,
            //    Hospitals: childHospitalArray, FromHospital: true,
            //    MotherBirthDate: "", FatherBirthDate: "", MarriageDate: "", InviteTypeId: ""
            //};

            let createFamilyWithDetailsCommand = {
                title: title, // نام خانواده
                father: {
                    firstName: f_name, // نام پدر
                    lastName: f_lastname, // نام خانوادگی پدر
                    mobile: f_mobile, // شماره موبایل پدر
                    birthDate: "", // تاریخ تولد پدر
                    //birthDateMiladi: FatherBirthDate ? new Date(FatherBirthDate) : null, // تاریخ میلادی تولد پدر
                    gender: 1 // جنسیت پدر (اگر مشخص باشد، اینجا مقدار استاتیک قرار داده شود)
                },
                mother: {
                    firstName: m_name, // نام مادر
                    lastName: m_lastname, // نام خانوادگی مادر
                    mobile: m_mobile, // شماره موبایل مادر
                    birthDate: "", // تاریخ تولد مادر
                    //birthDateMiladi: MotherBirthDate ? new Date(MotherBirthDate) : null, // تاریخ میلادی تولد مادر
                    gender: 2 // جنسیت مادر (اگر مشخص باشد، اینجا مقدار استاتیک قرار داده شود)
                },
                children: childNamesArray.map((name, index) => ({
                    firstName: name, // نام کودک
                    gender: childSexArray[index] ? 1 : 2, // جنسیت کودک 
                    birthDate: childBirthDateArray[index], // تاریخ تولد کودک
                    //birthDateMiladi: childBirthDateArray[index] ? new Date(childBirthDateArray[index]) : null, // تاریخ میلادی تولد کودک
                    hospitalId: childHospitalArray[index] // آیدی بیمارستان مربوط به کودک
                }))
            };

            ajaxPost("/Family/CreateFamilyWithDetails", createFamilyWithDetailsCommand, function (msg) {
                btnAddEdit_ChangeDisable("btn_submitdataFamily_FromHospital", false);
                if (msg.d.Result == false) {//خطا داریم
                    ShowError(msg.d.Message);
                }
                else {
                    ResetFeildsFamily_Hospital();
                    toastr.success(msg.d.Message, "موفق");
                }
            }, function () {
                btnAddEdit_ChangeDisable("btn_submitdataFamily_FromHospital", false);
                alert("خطا هنگام ثبت اطلاعات");
            });
        });
        let hospitalsHtml = '';
        $(document).ready(function () {
            getHospitalsForCMBAsync(false, (html) => {
                hospitalsHtml = html;
            });
            $("#master_PageTitle").text("ثبت خانواده در بیمارستان");
            addFamily_FromHospital_Setting(true);
            ResetFeildsFamily_Hospital();
        });
    </script>
</asp:Content>

