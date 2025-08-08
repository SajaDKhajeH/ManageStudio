<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Personnel.aspx.cs" Inherits="AdakStudio.Personnel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">

    <style>
        .filter-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

            .filter-bar input {
                flex: 1;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 14px;
                margin-right: 10px;
            }

            .filter-bar button {
                padding: 8px 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
            }

                .filter-bar button:hover {
                    background-color: #0056b3;
                }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

            table th, table td {
                padding: 10px;
                text-align: center;
                border: 1px solid #dddddd;
            }

            table th {
                background-color: #f4f4f4;
                color: #333;
            }

            table tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            table tr:hover {
                background-color: #f1f1f1;
            }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

            .pagination button {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background-color: #fff;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
            }

                .pagination button:hover {
                    background-color: #f4f4f4;
                }

                .pagination button:disabled {
                    background-color: #e0e0e0;
                    cursor: not-allowed;
                }

            .pagination span {
                font-size: 14px;
                color: #555;
            }
    </style>
    <style>
        .card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
        }

        .custom-checkbox .form-check-input {
            width: 22px;
            height: 22px;
            cursor: pointer;
        }

        .custom-checkbox .form-check-label {
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            margin-left: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-4">
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2  open-modal-btn" onclick="ResetFeilds()" data-bs-toggle="modal" data-bs-target="#kt_modal_add_personnel">افزودن پرسنل</button>
                                </div>

                            </div>

                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <%--<th data-priority="1">سمت</th>--%>
                                        <th class="min-w-150px">نام و نام خانوادگی</th>
                                        <th class="min-w-150px">شماره همراه</th>
                                        <th class="min-w-150px">نام کاربری</th>
                                        <th class="min-w-70px">وضعیت</th>
                                        <th class="min-w-110px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Personnels">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataPersonnel()">
                                        <%Response.Write(PublicMethod.Pagination()); %>
                                    </select>
                                </span>
                                <button id="nextPageBtn" class="btn btn-secondary">صفحه بعد</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="kt_modal_add_personnel" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header" id="kt_modal_add_customer_header">
                    <h2 class="fw-bolder" id="header_AddPersonnel">افزون اطلاعات</h2>
                    <div id="btn_close" class="btn btn-icon btn-sm btn-active-icon-primary">
                        <span class="svg-icon svg-icon-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="black" />
                                <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="black" />
                            </svg>
                        </span>
                    </div>
                </div>
                <div class="modal-body py-10 px-lg-17">
                    <div class="scroll-y me-n7 pe-7" id="kt_modal_add_customer_scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#kt_modal_add_customer_header" data-kt-scroll-wrappers="#kt_modal_add_customer_scroll" data-kt-scroll-offset="300px">
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <input id="p_firstname" maxlength="20" class="form-control form-control-solid" placeholder="نام" name="firstname" value="" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <input id="p_lastname" maxlength="30" class="form-control form-control-solid" placeholder="نام خانوادگی" name="lastname" value="" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="p_active" class="form-check-input" name="billing" type="checkbox" value="1" checked="checked" />
                                        <span class="form-check-label fw-bold text-muted" for="kt_modal_add_customer_billing">وضعیت</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <span class="form-check-label fw-bold text-muted">خانم</span>
                                        <input id="p_sex" class="form-check-input" name="billing" style="margin: 5px" type="checkbox" value="1" checked="checked" />
                                        <span class="form-check-label fw-bold text-muted">آقا</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <input id="p_mobile" maxlength="11" class="form-control form-control-solid" placeholder="شماره همراه" value="" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <input id="p_phone" maxlength="15" class="form-control form-control-solid" placeholder="تلفن منزل" value="" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <input id="p_username" maxlength="10" class="form-control form-control-solid" placeholder="نام کاربری فقط اعداد و حروف انگلیسی" name="firstname" value="" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <input id="p_pass" maxlength="10" class="form-control form-control-solid" placeholder="رمز عبور" name="lastname" value="" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7" id="div_showCall_A_discount">
                            <%--<div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="p_showpopup" class="form-check-input" type="checkbox" checked="checked" />
                                        <span class="form-check-label fw-bold text-muted" for="kt_modal_add_customer_billing">نمایش فرم تماس</span>
                                    </label>
                                </div>
                            </div>--%>
                            <div class="col-md-6 fv-row">
                                <input id="p_maxdiscount" maxlength="15" class="form-control form-control-solid" placeholder="حداکثر اعمال تخفیف" value="" />
                            </div>
                        </div>
                        <div class="fv-row mb-15">
                            <input type="text" id="p_desc" class="form-control form-control-solid" placeholder="توضیحات" name="description" />
                        </div>
                        <div class="fv-row mb-15">
                            <input type="text" id="p_address" class="form-control form-control-solid" placeholder="آدرس" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer flex-center">
                    <button id="btn_submitdata" class="btn btn-primary">
                        <span class="indicator-label">ثبت اطلاعات</span>
                    </button>
                    <button type="reset" id="btncancel" class="btn btn-light me-3">انصراف</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="personnelAccessModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="personnelAccessModal-title">تنظیمات دسترسی پرسنل</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">
                    <!-- تب‌ها -->
                    <ul class="nav nav-tabs mb-3" id="accessTabs" role="tablist">
                        <li class="nav-item" route="" id="tab-menus"><a class="nav-link" data-bs-toggle="tab" href="#tab-menus-content">منوها</a></li>
                        <li class="nav-item" route="GetProjectStatuses" id="tab-project-status"><a class="nav-link" data-bs-toggle="tab" href="#tab-project-status-content">وضعیت پروژه</a></li>
                        <li class="nav-item" route="GetDesignerSteps" id="tab-photo-steps"><a class="nav-link" data-bs-toggle="tab" href="#tab-photo-steps-content">مراحل آماده‌سازی عکس</a></li>
                        <li class="nav-item" route="GetEditorSteps" id="tab-video-steps"><a class="nav-link" data-bs-toggle="tab" href="#tab-video-steps-content">مراحل آماده‌سازی فیلم</a></li>
                        <li class="nav-item" route="GetProjectTypes" id="tab-project-types"><a class="nav-link" data-bs-toggle="tab" href="#tab-project-types-content">نوع پروژه‌ها</a></li>
                    </ul>

                    <div class="tab-content">
                        <!-- تب منوها -->
                        <div class="tab-pane fade" id="tab-menus-content">
                            <h6 class="mb-3">دسترسی به منوها</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>عنوان منو</th>
                                            <th>مشاهده</th>
                                        </tr>
                                    </thead>
                                    <tbody id="table-tab-menus">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- تب وضعیت پروژه -->
                        <div class="tab-pane fade" id="tab-project-status-content">
                            <h6 class="mb-3">مدیریت وضعیت‌های پروژه</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>مرحله</th>
                                            <th>مشاهده</th>
                                            <th>تغییر به جلو</th>
                                            <th>تغییر به عقب</th>
                                        </tr>
                                    </thead>
                                    <tbody id="table-tab-project-status">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- تب مراحل آماده‌سازی عکس -->
                        <div class="tab-pane fade" id="tab-photo-steps-content">
                            <h6 class="mb-3">مراحل آماده‌سازی عکس</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>مرحله</th>
                                            <th>مشاهده</th>
                                            <th>تغییر به جلو</th>
                                            <th>تغییر به عقب</th>
                                        </tr>
                                    </thead>
                                    <tbody id="table-tab-photo-steps">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- تب مراحل آماده‌سازی فیلم -->
                        <div class="tab-pane fade" id="tab-video-steps-content">
                            <h6 class="mb-3">مراحل آماده‌سازی فیلم</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>مرحله</th>
                                            <th>مشاهده</th>
                                            <th>تغییر به جلو</th>
                                            <th>تغییر به عقب</th>
                                        </tr>
                                    </thead>
                                    <tbody id="table-tab-video-steps">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- تب نوع پروژه‌ها -->
                        <div class="tab-pane fade" id="tab-project-types-content">
                            <h6 class="mb-3">نوع پروژه ها</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>نوع</th>
                                            <th>مشاهده</th>
                                        </tr>
                                    </thead>
                                    <tbody id="table-tab-project-types">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button onclick="btnSaveUserPermissions(this);" class="btn btn-success">ذخیره تغییرات</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">بستن</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="personnelRolesModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="personnelRolesModal-title">نقش های کاربر</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">

                    <div class="card shadow-lg border-0 rounded-lg">
                        <div class="card-header bg-success text-white text-center py-3">
                            <h5 class="mb-0">🛠️ نقش های کاربر</h5>
                        </div>
                        <div class="card-body" id="table-personel-roles">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button onclick="btnSaveUserRoles();" class="btn btn-success">ذخیره تغییرات</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">بستن</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roleSelectorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="roleSelectorModal-title">نقش های کاربر</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">

                    <div class="card shadow-lg border-0 rounded-lg">
                        <div class="card-header bg-success text-white text-center py-3">
                            <h5 class="mb-0">نقش مورد نظر را انتخاب نمایید</h5>
                        </div>
                        <div class="card-body" id="table-roles">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">انصراف</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">
    <script type="text/javascript">
        var personId = '';
        var regex = new RegExp('^(\\+98|0)?9\\d{9}$');
        var d_showCall_A_discount = document.getElementById('div_showCall_A_discount');
        var p_Pass = document.getElementById('p_pass');
        $("#btn_submitdata").click(function (e) {
            var firstname = $("#p_firstname").val();
            var lastname = $("#p_lastname").val();
            var mobile = $("#p_mobile").val();
            if (mobile != "") {
                var result = regex.test(mobile);
                if (result == false) {
                    toastr.error("شماره همراه را بدرستی وارد کنید", "اخطار");
                    return;
                }
            }
            var phone = $("#p_phone").val();
            var username = $("#p_username").val();
            var password = $("#p_pass").val();
            var maxdiscount = $("#p_maxdiscount").val();
            var address = $("#p_address").val();
            var active = $("#p_active").prop("checked");
            var sex = $("#p_sex").prop("checked");
            //var showpopup = $("#p_showpopup").prop("checked");
            var desc = $("#p_desc").val();

            if (!firstname) {
                toastr.warning('لطفاً نام را وارد نمایید', 'نام');
                return;
            }

            if (!lastname) {
                toastr.warning('لطفاً نام خانوادگی را وارد نمایید', 'نام خانوادگی');
                return;
            }

            let createUserCommand =
            {
                id: personId,
                firstName: firstname,
                lastName: lastname,
                gender: sex ? 2 : 1,
                active: active,
                desc: desc,
                mobile: mobile,
                phone: phone,
                userName: username,
                password: password,
                maxDiscount: maxdiscount ? maxdiscount : null,
                address: address
            };
            let method = 'POST';
            let route = '/User/Create';
            if (personId != '') {
                method = 'PUT';
                route = '/User/Update';
            }

            ajaxAuthCall(method, route, createUserCommand, function (res) {
                if (res.success) {
                    toastr.success('اطلاعات ذخیره شد', "موفق");
                    closeModal();
                    loadTableDataPersonnel();
                }
                else {
                    ShowError(res.message);
                }
            }, function (err) {
            });
        });
        $('#btn_close').click(function () {
            closeModal();
        });
        $('#btncancel').click(function () {
            closeModal();
        });
        function closeModal() {
            $('#kt_modal_add_personnel').modal('hide');
            personId = "";
        };
        $("#btn_add").click(function (e) {
            ResetFeilds();
        });
        function ResetFeilds() {
            $("#header_AddPersonnel").text("ثبت پرسنل");
            $("#p_firstname").val("");
            $("#p_lastname").val("");
            $("#p_mobile").val("");
            $("#p_phone").val("");
            $("#p_username").val("");
            $("#p_pass").val("");
            $("#p_maxdiscount").val("");
            $("#p_address").val("");
            personId = "";
            $("#p_active").prop("checked", true);
            $("#p_sex").prop("checked", true);
            $("#p_desc").val("");
            p_Pass.style.visibility = 'visible';
        };
        //$("#p_role").change(function (e) {
        //    var roleid = $("#p_role").val();
        //    if (roleid == "4" || roleid == "5") {
        //        d_showCall_A_discount.style.visibility = 'visible';
        //    }
        //    else {
        //        d_showCall_A_discount.style.visibility = 'hidden';
        //    }
        //});
        function DeletePersonnel(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                let query = `?id=${id}`;
                ajaxDelete('/User/Delete' + query, function (res) {
                    if (res.success) {
                        toastr.success('پرسنل حذف شد', "موفق");
                        loadTableDataPersonnel();
                    }
                    else {
                        ShowError(res.message);
                    }
                },
                    function () {
                        alert("error");
                    });
            }
        };

        function EditPerseonnel(id) {
            personId = id;
            let query = `?id=${id}`;
            ajaxGet('/User/GetUser' + query, function (res) {
                if (res.success) {
                    let data = res.data;
                    $("#header_AddPersonnel").text("ویرایش " + data.firstName + " " + data.lastName);
                    $("#p_firstname").val(data.firstName);
                    $("#p_lastname").val(data.lastName);
                    $("#p_mobile").val(data.mobile);
                    $("#p_phone").val(data.phone);
                    $("#p_username").val(data.userName);
                    $("#p_pass").val(data.password);
                    $("#p_maxdiscount").val(data.maxDiscount);
                    $("#p_address").val(data.address);
                    $("#p_active").prop("checked", data.active);
                    $("#p_sex").prop("checked", data.gender == 2 ? true : false);
                    $("#p_desc").val(data.desc);
                    //p_Pass.style.visibility = data.ShowPass ? 'visible' : 'hidden';//TODO::
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
                alert("error");
            });
        };
        function fillInfo() {
            loadTableDataPersonnel();
        }
        $(document).ready(function () {
            fillInfo();
            $("#master_PageTitle").text("پرسنل");
            $("#s_pageSize").val("5");

            // صفحه بعد
            $("#nextPageBtn").click(function () {
                pageIndex++;
                loadTableDataPersonnel();
            });

            // صفحه قبل
            $("#prevPageBtn").click(function () {
                pageIndex--;
                loadTableDataPersonnel();
            });

            // اعمال فیلتر
            $("#filterBtn").click(function () {
                pageIndex = 0;
                loadTableDataPersonnel();
            });
        });
    </script>
    <script>
        let pageIndex = 0;
        let pageSize = 5;
        let personel = [];
        let gettingData = false;
        const SecretaryRole = 5;
        const AdminRole = 1;
        function loadTableDataPersonnel() {
            var filter = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${filter}`;
            gettingData = true;
            const tbody = $("#dt_Personnels");
            tbody.empty();
            ajaxGet('/User/GetUsers' + query, function (res) {
                gettingData = false;
                personel = res.items;
                const totalRecords = res.totalCount;

                personel.forEach(row => {

                    let actionButtons = ``;
                    let hasRole = true;
                    let isMultiRole = false;
                    let roleId = 0;
                    let userRoleId = '';

                    if (row.roles.length === 0) {
                        hasRole = false;
                    }
                    else if (row.roles.length === 1) {
                        roleId = row.roles[0].roleId;
                        userRoleId = row.roles[0].id;
                    }
                    else if (row.roles.length > 1) {
                        isMultiRole = true;
                    }

                    let actions = ` <div class='action-buttons'>`;

                    if (roleId !== AdminRole) {
                        actions += `<button class='btnDataTable btnDataTable-edit' onclick='personAccessSetting("${row.id}",${hasRole},${isMultiRole},${roleId},"${userRoleId}")' title='تنظیمات دسترسی'>⚙️</button>`;
                    }

                    actions +=
                        `
                       <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#personnelRolesModal' onclick='personRoles("${row.id}")' title='نقش های کاربر'>⚙️</button>
                       <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_add_personnel' onclick='EditPerseonnel("${row.id}")' title='ویرایش'>✎</button>
                       <button class='btnDataTable btnDataTable-delete' onclick='DeletePersonnel("${row.id}")' title='حذف'>🗑</button>
                       `;
                    actions += '</div>';

                    let status = '';
                    if (row.active) {
                        status = `<div class='badge badge-light-success'>فعال</div>`;
                    } else {
                        status = `<div class='badge badge-light-danger'>غیرفعال</div>`;
                    }
                    tbody.append(`
                       <tr>
                           <td>${row.fullName}</td>
                           <td>${row.mobile}</td>
                           <td>${row.userName}</td>
                           <td>${status}</td>
                           <td>${actions}</td>
                       </tr>
                   `);
                });

                // بروزرسانی صفحه فعلی
                $("#pageIndex").text(pageIndex + 1);
                $("#countAllTable").text(totalRecords);
                // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                $("#prevPageBtn").prop("disabled", pageIndex === 0);
                $("#nextPageBtn").prop("disabled", (pageIndex + 1) * pageSize >= totalRecords);
            }, function (err) {
                toastr.error("خطا در دریافت اطلاعات", "خطا");
            });
        }
        let personIdSelectedForSetupRoles = '';
        function personRoles(id) {

            personIdSelectedForSetupRoles = id;
            let query = '?userId=' + id;
            $("#table-personel-roles").html('');

            var person = personel.find(x => x.id == id);
            $('#personnelRolesModal-title').html(`نقش های ${person.fullName}`);
            ajaxGet("/Role/GetAllRoles" + query, function (roles) {
                const permissionsHtml = roles.map(role =>
                    `
                        <div class='form-check custom-checkbox'>
                           <input class='form-check-input access-checkbox' name='PersonRoleChk' type='checkbox' id='${role.id}' ${(role.hasRole ? "checked" : "")}>
                           <label class='form-check-label'>${role.title}</label>
                        </div>
                    `
                ).join('');
                $("#table-personel-roles").html(permissionsHtml);
            });
        }
        let selectedUserRoleId = '';
        let selectedPersonIdForSettingAccess = '';
        function personAccessSetting(personId, hasRole, isMultiRole, roleId, userRoleId) {
            if (gettingData) {
                toastr.warning('لطفاً شکیبا باشید');
                return;
            }

            if (!hasRole) {
                toastr.warning('هنوز هیچ نقشی برای این کاربر تعریف نشده', 'نقش کاربر');
                return;
            }
            var person = personel.find(x => x.id == personId);
            if (isMultiRole) {
                let html = '';
                person.roles.forEach(x => {
                    html += `<button onclick="$('#roleSelectorModal').modal('hide');personAccessSetting('${personId}',${true},${false},${x.roleId},'${x.id}');" class="btn btn-secondary" style="margin:10px">${x.title}</button>`;
                });
                $('#table-roles').html(html);
                $('#roleSelectorModal-title').html(`نقش های ${person.fullName}`);
                $('#roleSelectorModal').modal('show');
                return;
            }
            if (roleId === AdminRole) {
                toastr.warning('امکان تعیین سطح دسترسی برای نقش مدیر وجود ندارد');
                return;
            }
            selectedUserRoleId = userRoleId;
            selectedPersonIdForSettingAccess = personId;

            $('#table-tab-project-types').empty();
            $('#table-tab-photo-steps').empty();
            $('#table-tab-video-steps').empty();
            $('#table-tab-project-status').empty();
            $('#table-tab-menus').empty();

            $('#personnelAccessModal-title').html(`تنظیمات دسترسی ${person.fullName}`);
            $('#personnelAccessModal').modal('show');

            setTimeout(function () {
                if (roleId === SecretaryRole) {
                    $('#tab-menus').removeAttr('hidden');
                    const tab = document.querySelector('#tab-menus a');
                    if (tab) {
                        const tabTrigger = new bootstrap.Tab(tab);
                        tabTrigger.show();
                        $('#tab-menus').trigger('click');
                    }
                    
                } else {
                    $('#tab-menus').attr('hidden', 'hidden');
                    const tab = document.querySelector('#tab-project-status a');
                    if (tab) {
                        const tabTrigger = new bootstrap.Tab(tab);
                        tabTrigger.show();
                        $('#tab-project-status').trigger('click');
                    }
                }
            }, 256);
        }
        $('#accessTabs').on('click', '.nav-item', function () {
            const tableId = '#table-' + $(this).attr('id');
            if ($(tableId + ' tr').length > 0) {
                return;
            }
            if (tableId === '#table-tab-menus') {
                GetPermissions();
                return;
            }
            //
            let route = '/User/' + $(this).attr('route');
            route += `?userRoleId=${selectedUserRoleId}`;
            ajaxGet(route, function (res) {
                if (!res.success) {
                    toastr.error(res.message);
                    return;
                }
                const items = res.data;
                let html = '';
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    if (tableId === '#table-tab-project-types') {
                        html +=
                            `
                              <tr id='${(item.id ? item.id : '')}' row-id='${item.rowId}'>
                                 <td>${item.title}</td>
                                 <td><input type="checkbox" ${item.canView ? 'checked' : ''} class="can-view" /></td>
                             </tr>
                        `;
                    } else {
                        html +=
                            `
                              <tr id='${(item.id ? item.id : '')}' row-id='${item.rowId}'>
                                 <td>${item.title}</td>
                                 <td><input type="checkbox" ${item.canView ? 'checked' : ''} class="can-view" /></td>
                                 <td><input type="checkbox" ${item.canGoNext ? 'checked' : ''} class="go-next" /></td>
                                 <td><input type="checkbox" ${item.canGoPre ? 'checked' : ''} class="go-pre" /></td>
                             </tr>
                        `;
                    }

                }

                $(tableId).html(html);
            });
        });
        function GetPermissions() {
            $("#table-tab-menus").html('');
            let query = `?userRoleId=${selectedUserRoleId}`;
            ajaxGet("/Permission/GetPermissions" + query, function (permissions) {
                const permissionsHtml = permissions.map(permission =>
                    `
                       <tr id='${(permission.id ? permission.id : '')}'>
                          <td>${permission.title}</td>
                          <td><input type="checkbox" ${permission.hasPermission ? 'checked' : ''} class="can-view" /></td>
                        </tr>
                    `
                ).join('');
                $("#table-tab-menus").html(permissionsHtml);
            });
        }

    </script>

    <script>
        function btnSaveUserRoles() {
            var roles = document.getElementsByName("PersonRoleChk");

            const roleIds = new Set(
                Array.from(roles)
                    .filter(role => role.checked)
                    .map(role => role.id)
            );
            if (!roleIds) {
                toastr.warning("حداقل یک نقش انتخاب کنید");
                return;
            }
            let assignRoleCommand =
            {
                roleIds: Array.from(roleIds),
                userId: personIdSelectedForSetupRoles
            };
            ajaxPost("/Role/Assign", assignRoleCommand, function (res) {
                if (res.success) {
                    $('#personnelRolesModal').modal('hide');
                    $('#filterBtn').trigger('click');
                    toastr.success("ثبت نقش ها با موفقیت انجام شد");
                } else {
                    ShowError(res.message);
                }
            });
        }
    </script>

    <script>
        async function btnSaveUserPermissions(button) {
            let photoSteps = getTableData('table-tab-photo-steps');
            let videoSteps = getTableData('table-tab-video-steps');
            let projectTypes = getTableData('table-tab-project-types');
            let projectStatuses = getTableData('table-tab-project-status');
            let menus = getTableData('table-tab-menus');

            let photoSuccess = true;
            let videoSuccess = true;
            let projectTypesSuccess = true;
            let projectStatusesSuccess = true;
            let menusSuccess = true;


            let btn = $(button);
            let defaultText = btn.html();
            function setDisable() {
                btn.attr('disabled', 'disabed');
                btn.html('لطفاً منتظر بمانید ...');
            }
            function setEnable() {
                btn.removeAttr('disabled');
                btn.html(defaultText);
            }
            setDisable();
            try {
                if (photoSteps.length > 0)
                    photoSuccess = await saveUserPermissions('/AssignDesignerSteps', photoSteps);
                if (videoSteps.length > 0)
                    videoSuccess = await saveUserPermissions('/AssignEditorSteps', videoSteps);
                if (projectTypes.length > 0)
                    projectTypesSuccess = await saveUserPermissions('/AssignProjectTypes', projectTypes);
                if (projectStatuses.length > 0)
                    projectStatusesSuccess = await saveUserPermissions('/AssignProjectStatus', projectStatuses);
                if (menus.length > 0)
                    menusSuccess = await saveMenuPermissions(menus);

                if (photoSuccess && videoSuccess && projectTypesSuccess && projectStatusesSuccess && menusSuccess) {
                    toastr.success("ثبت دسترسی ها با موفقیت انجام شد");
                    $('#personnelAccessModal').modal('hide');
                }
            } catch (err) {
                console.log(err);
            }
            setEnable();
        }
        function saveMenuPermissions(menus) {
            const pageIds = menus.filter(x => x.canView).map(x => x.id);
            let createPermissionCommand =
            {
                pageIds: pageIds,
                userRoleId: selectedUserRoleId
            };
            return new Promise((resolve) => {
                ajaxPost("/Permission/CreatePermission", createPermissionCommand, function (res) {
                    if (res.success) {
                        resolve(true);
                    } else {
                        ShowError(res.message);
                        resolve(false);
                    }
                }, function (err) {
                    resolve(false);
                });
            });
        }
        async function saveUserPermissions(route, data) {

            let assignDataPermissionCommand =
            {
                data: data,
                userRoleId: selectedUserRoleId
            };
            return new Promise((resolve) => {
                ajaxPost("/DataPermission" + route, assignDataPermissionCommand, function (res) {
                    if (res.success) {
                        resolve(true);
                    } else {
                        ShowError(res.message);
                        resolve(false);
                    }
                }, function (err) {
                    resolve(false);
                });
            });
        }
        function getTableData(id) {
            const rows = document.querySelectorAll(`tbody[id="${id}"] tr`);
            const data = [];

            rows.forEach((row, index) => {
                let chkView = row.querySelector('input[type="checkbox"].can-view');
                let chkNext = row.querySelector('input[type="checkbox"].go-next');
                let chkPre = row.querySelector('input[type="checkbox"].go-pre');
                const entry = {
                    id: $(row).attr('id') || null,
                    rowId: $(row).attr('row-id'),
                    canView: chkView.checked,
                    canGoNext: chkNext === undefined || chkNext == null ? false : chkNext.checked,
                    canGoPre: chkPre === undefined || chkPre == null ? false : chkPre.checked,
                };
                data.push(entry);
            });

            return data;
        }
    </script>
</asp:Content>
