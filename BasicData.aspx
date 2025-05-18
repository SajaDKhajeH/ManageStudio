<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="BasicData.aspx.cs" Inherits="AdakStudio.BasicData" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <!--begin::Container-->
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-2">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_typeId">
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-3">
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2 open-modal-btn" onclick="ResetFeilds()" data-bs-toggle="modal" data-bs-target="#kt_modal_add_customer">افزودن اطلاعات</button>
                                </div>
                            </div>
                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-150px">عنوان</th>
                                        <th class="min-w-150px">اولویت نمایش</th>
                                        <th class="min-w-130px">وضعیت</th>
                                        <th class="min-w-130px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_BasicData">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataBasicData()">
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
    <div class="modal fade" id="kt_modal_add_customer" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header" id="kt_modal_add_customer_header">
                    <h2 class="fw-bolder" id="model_basicDataHeader">افزون اطلاعات</h2>
                    <div id="btn_close" class="btn btn-icon btn-sm btn-active-icon-primary">
                        <span class="svg-icon svg-icon-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="black" />
                                <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="black" />
                            </svg>
                        </span>
                        <!--end::Svg Icon-->
                    </div>
                    <!--end::Close-->
                </div>
                <div class="modal-body py-10 px-lg-17">
                    <!--begin::Scroll-->
                    <div class="scroll-y me-n7 pe-7" id="kt_modal_add_customer_scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#kt_modal_add_customer_header" data-kt-scroll-wrappers="#kt_modal_add_customer_scroll" data-kt-scroll-offset="300px">
                        <div class="d-flex flex-column mb-7 fv-row">
                            <div id="div_typeData">
                                <label class="fs-6 fw-bold mb-2">
                                    <span class="required">انتخاب نوع</span>
                                </label>
                                <select id="d_Typeid">
                                </select>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-bold mb-2">عنوان</label>
                            <input type="text" id="d_title" class="form-control form-control-solid" placeholder="" name="name" />
                        </div>
                        <div class="fv-row mb-7">
                            <div class="d-flex flex-stack">
                                <label class="form-check form-switch form-check-custom form-check-solid">
                                    <input id="d_active" class="form-check-input" name="billing" type="checkbox" value="1" checked="checked" />
                                    <span class="form-check-label fw-bold text-muted" for="kt_modal_add_customer_billing">وضعیت</span>
                                </label>
                            </div>
                        </div>
                        <div class="fv-row mb-7" id="div_priority">
                            <label class="required fs-6 fw-bold mb-2">اولویت نمایش</label>
                            <input type="text" id="d_pariority" class="form-control form-control-solid" placeholder="اولویت" />
                        </div>
                        <%-- <div class="fv-row mb-15">
                            <label class="fs-6 fw-bold mb-2">توضیحات</label>
                            <textarea id="d_desc" class="form-control form-control-solid" placeholder="" name="description"></textarea>
                        </div>--%>

                        <div class="fv-row mb-15" id="div_defaultsms">
                            <label class="fs-6 fw-bold mb-2">متن پیش فرض</label>
                            <textarea type="text" id="d_defaultsms" class="form-control form-control-solid" placeholder="" name="description"></textarea>
                            <label class="fs-6 fw-bold mb-2" id="d_KeywordSMS"></label>
                        </div>
                        <div class="fv-row mb-7" id="div_Show_SendFor_Men_Or_Women">
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="d_SendForMen" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">ارسال به آقا</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="d_SendForWomen" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">ارسال به خانم</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="fv-row mb-7" id="div_DurationForSend">
                            <label class="fs-6 fw-bold mb-2" id="d_lbl_DusrationForSend"></label>
                            <input type="number" id="d_DurationForSend" maxlength="1000" class="form-control form-control-solid" placeholder="مدت زمان" />
                        </div>
                        <div class="fv-row mb-15" id="div_DescForUser">
                            <label class="fs-6 fw-bold mb-2">توضیحات برای کاربر</label>
                            <textarea id="d_DescForUser" class="form-control form-control-solid" placeholder="" name="description" disabled></textarea>
                        </div>
                        <%-- <div class="fv-row mb-15" id="div_state">
                            <select id="d_stateid" data-placeholder="انتخاب استان" data-allow-clear="true" data-kt-customer-table-filter="state" data-dropdown-parent="#kt-toolbar-filter">
                                <%Response.Write(PublicMethod.GetState()); %>
                            </select>
                        </div>--%>
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
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">
        var d_id = "";
        var defaultsms = document.getElementById('div_defaultsms');
        //var state = document.getElementById('div_state');
        var div_priority = document.getElementById('div_priority');
        var div_DurationForSend = document.getElementById('div_DurationForSend');
        var div_DescForUser = document.getElementById('div_DescForUser');
        var div_Show_SendFor_Men_Or_Women = document.getElementById('div_Show_SendFor_Men_Or_Women');
        var ShowDurationForSend = false;
        var currentTypeId = "";
        var editData = false;
        $("#btn_submitdata").click(function (e) {
            var typeId = $("#d_Typeid").val();
            if (editData) {
                typeId = currentTypeId;
            }
            var title = $("#d_title").val();
            var active = $("#d_active").prop("checked");
            var priority = $("#d_pariority").val();
            if (!priority || priority == undefined) {
                priority = '0';
            }
            var success = function (res) {
                if (res.success) {
                    toastr.success('اطلاعات ذخیره شد', "موفق");
                    closeModal();
                    loadTableDataBasicData();
                }
                else {
                    ShowError(res.message);
                }
            }
            var error = function (err) {
            }
            if (typeId == '1001') {
                var defulatsms = $("#d_defaultsms").val();
                var SendForWomen = $("#d_SendForWomen").prop("checked");
                var SendForMen = $("#d_SendForMen").prop("checked");
                let createInvoiceStatusCommand =
                {
                    title: title,
                    active: active,
                    notificationTemplate: defulatsms,
                    priority: priority,
                    sendToFather: SendForMen,
                    sendToMother: SendForWomen,
                    isRemovable: true,
                    isEditable: true
                };
                ajaxPost('/InvoiceStatus/Create', createInvoiceStatusCommand, success, error);
            } else {
                let createItemCommand =
                {
                    title: title,
                    categoryId: typeId,
                    active: active,
                    priority: priority
                };
                ajaxPost('/BasicData/Create', createItemCommand, success, error);
            }

            //var desc = ""; //$("#d_desc").val();
            //var state = "0";// $("#d_stateid").val();
            //var SendForWomen = $("#d_SendForWomen").prop("checked");
            //var SendForMen = $("#d_SendForMen").prop("checked");
            //var DurationForSend = $("#d_DurationForSend").val();
            //if (!ShowDurationForSend) {
            //    DurationForSend = "0";
            //}
        });
        $('#btn_close').click(function () {
            closeModal();
        });
        $('#btncancel').click(function () {
            closeModal();
        });
        function closeModal() {
            $('#kt_modal_add_customer').modal('hide');
        };
        $("#btn_add").click(function (e) {
            ResetFeilds();
        });
        $("#d_Typeid").change(function (e) {
            var typeId = $("#d_Typeid").val();

            if (typeId == null || typeId == undefined || typeId == "") {
                typeId = currentTypeId
            }

            if (typeId == '1001') {
                //invoiceStatus
                $("#d_KeywordSMS").text("کلید واژه ها: {{عنوان خانواده}}-{{عنوان وضعیت}}");
                $("#d_defaultsms").val(`خانواده {{عنوان خانواده}} عزیز سفارش شما در مرحله { {عنوان وضعیت } } قرار گرفته است`);
                div_Show_SendFor_Men_Or_Women.style.visibility = 'visible';
                defaultsms.style.visibility = 'visible';
            } else {
                div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
                defaultsms.style.visibility = 'hidden';
            }
            if (typeId == '13') {
                //نوع هزینه
                div_priority.style.visibility = 'hidden';
            } else {
                div_priority.style.visibility = 'visible';
            }

            return;
            $.ajax({
                type: "POST",
                url: "BasicData.aspx/ChangeType",
                data: "{typeId:'" + typeId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var result = res.d;
                    if (result.Result == false) {//خطا داریم
                        ShowError(result.Message);
                    }
                    else {
                        if (result.ShowDefaultSMS == true) {
                            defaultsms.style.visibility = 'visible';
                        }
                        else {
                            defaultsms.style.visibility = 'hidden';
                        }
                        //ارسال پیام به آقا یا خانم
                        if (result.Show_SendFor_Men_Or_Women ?? false) {
                            div_Show_SendFor_Men_Or_Women.style.visibility = 'visible';
                            if (d_id == "") {
                                $("#d_KeywordSMS").text("کلید واژه ها: {{عنوان خانواده}}-{{عنوان وضعیت}}");
                                $("#d_defaultsms").val(result.DefaultSMS);
                            }
                        }
                        else {
                            div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
                        }
                        if (result.ShowPriority == true) {
                            div_priority.style.visibility = 'visible';
                        }
                        else {
                            div_priority.style.visibility = 'hidden';
                        }

                    }
                },
                error: function () {
                    ShowError("خطا در دریافت اطلاعات");
                }
            });
        });
        function ResetFeilds() {
            defaultsms.style.visibility = 'hidden';
            $("#d_title").val("");
            d_id = "";
            editData = false;
            $("#d_active").prop("checked", true);
            //$("#d_desc").val("");
            $("#model_basicDataHeader").text("ثبت اطلاعات پایه ");
            $("#d_defaultsms").val("");
            $("#d_DurationForSend").val("");
            div_DurationForSend.style.visibility = 'hidden';
            div_DescForUser.style.visibility = 'hidden';
            div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
            document.getElementById("div_typeData").style.display = "block";
            document.getElementById("div_priority").style.display = 'block';
            $("#d_pariority").val("0");
            $('#d_Typeid').trigger('change');

        };
        function DeleteBasicData(id, filterTypeId) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                let query = `?id=${id}`;
                let route = '';
                if (filterTypeId == '1001') {
                    route = '/InvoiceStatus/Delete';
                } else {
                    route = '/BasicData/Delete';
                }
                ajaxDelete(route + query, function (res) {
                    if (res.success) {
                        toastr.success('با موفقیت حذف شد', "موفق");
                        loadTableDataBasicData();
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
        function EditBasicData(id) {
            $.ajax({
                type: "POST",
                url: "BasicData.aspx/EditData",
                data: "{id:'" + id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var result = res.d;
                    if (result.Result == false) {//خطا داریم
                        ShowError(result.Message);
                    }
                    else {
                        editData = true;
                        d_id = id;
                        $("#d_title").val(result.title);
                        $("#d_active").prop("checked", result.active);
                        //$("#d_desc").val(result.desc);
                        $("#d_defaultsms").val(result.defaultsms);
                        //$("#d_stateid").val(result.state);
                        currentTypeId = result.typeId;
                        $("#d_Typeid").val(result.typeId);
                        $("#d_pariority").val(result.pari);
                        $("#d_DurationForSend").val(result.D_DurationForSend);
                        $("#d_DescForUser").val(result.D_DescForUser);
                        $("#d_lbl_DusrationForSend").text(result.D_Desc_For_DurationForSend);
                        $("#model_basicDataHeader").text("ویرایش اطلاعات پایه " + result.title);
                        $("#d_KeywordSMS").text("کلید واژه ها: " + result.D_SmsKeys);
                        $("#d_SendForMen").prop("checked", result.D_SendForMen);
                        $("#d_SendForWomen").prop("checked", result.D_SendForWomen);
                        document.getElementById("div_typeData").style.display = 'none';
                        if (result.systematic) {
                            document.getElementById("div_priority").style.display = 'none';
                        }
                        ShowDurationForSend = result.D_ShowDurationForSend ?? false;
                        //نمایش مدت زمان ارسال پیام
                        if (result.D_ShowDurationForSend ?? false) {
                            div_DurationForSend.style.visibility = 'visible';
                        }
                        else {
                            div_DurationForSend.style.visibility = 'hidden';
                        }
                        //توضیحات برای کاربر
                        if (result.ShowDescForUser ?? false) {
                            div_DescForUser.style.visibility = 'visible';
                        }
                        else {
                            div_DescForUser.style.visibility = 'hidden';
                        }
                        //ارسال پیام به آقا یا خانم
                        if (result.D_Show_SendFor_Men_Or_Women ?? false) {
                            div_Show_SendFor_Men_Or_Women.style.visibility = 'visible';
                        }
                        else {
                            div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
                        }
                        $("#d_Typeid").change();
                    }
                },
                error: function () {
                    ShowError("خطا در دریافت اطلاعات");
                }
            });
        };
    </script>
    <%-- این قسمت مربوط به دیتاتیبل هست --%>
    <script type="text/javascript">
        let pageIndex = 0;
        let pageSize = 10;
        $(document).ready(function () {
            $("#master_PageTitle").text("مدیریت اطلاعات پایه");
            $("#s_pageSize").val("10");
            ResetFeilds();
            fillInfo();
        });
        function fillInfo() {
            fillCmbCategories(function () {
                loadTableDataBasicData();
            });

        }
        function fillCmbCategories(callback) {
            ajaxGet('/BasicData/GetCategories', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                options += `<option value='${1001}'>وضعیت فاکتور</option>`;
                $("#d_Typeid").html(options);
                $("#filter_typeId").html(options);
                callback();
            });
        }

        // صفحه بعد
        $("#nextPageBtn").click(function () {
            pageIndex++;
            loadTableDataBasicData();
        });
        // صفحه قبل
        $("#prevPageBtn").click(function () {
            pageIndex--;
            loadTableDataBasicData();
        });

        // اعمال فیلتر
        $("#filterBtn").click(function () {
            pageIndex = 0;
            loadTableDataBasicData();
        });
        function loadTableDataBasicData() {
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            var filter_typeId = $("#filter_typeId").val();
            let route = '';
            //let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${filter}&groupId=${groupId}`;
            if (filter_typeId == '1001' || filter_typeId == 1001) {
                route = '/InvoiceStatus/GetStatuses';
            } else {
                route = '/BasicData/GetItems?category=' + filter_typeId;
            }

            const tbody = $("#dt_BasicData");
            tbody.empty();
            ajaxGet(route, function (res) {
                const data = res.items;
                const totalRecords = res.totalCount;

                data.forEach(row => {
                    let deleteAction = `<button class='btnDataTable btnDataTable-delete' onclick='DeleteBasicData("${row.id}","${filter_typeId}")' title='حذف'>🗑</button>`;
                    if (filter_typeId == '1001' || filter_typeId == 1001) {
                        if (!row.isRemovable) {
                            deleteAction = '';
                        }
                    }
                    let actions =
                        `
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_add_customer' onclick='EditBasicData("${row.id}")' title='ویرایش'>✎</button>
                        ${deleteAction}
                        </div>
                `;

                    let status = '';
                    if (row.active) {
                        status = `<div class='badge badge-light-success'>فعال</div>`;
                    } else {
                        status = `<div class='badge badge-light-danger'>غیرفعال</div>`;
                    }

                    tbody.append(`
                        <tr>
                            <td>${row.title}</td>
                            <td>${row.priority}</td>
                            <td>${status}</td>
                            <td>${actions}</td>
                        </tr>
                    `);
                });

                // بروزرسانی صفحه فعلی
                $("#pageIndex").text(pageIndex);
                $("#countAllTable").text(totalRecords);
                // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                $("#prevPageBtn").prop("disabled", pageIndex === 0);
                $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecords);
            }, function (err) {

            });
        }
    </script>
</asp:Content>
