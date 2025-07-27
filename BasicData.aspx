<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="BasicData.aspx.cs" Inherits="AdakStudio.BasicData" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="Server">
    <style>
        .checklist-input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
    </style>
    <style>
            .circle {
      display: inline-flex; /* Center content */
      justify-content: center;
      align-items: center;
      width: 25px;          /* Set the width and height to make it look circular */
      height: 25px;
      border-radius: 50%;   /* Makes a perfect circle */
      background-color: #007BFF; /* Background color */
      color: white;         /* Text color */
      font-size: 10px;      /* Number font size */
      font-weight: bold;    /* Make the number bold */
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* Adds a subtle shadow for effect */
    }
    </style>
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
                        <select id="cmbProjectStatusSteps" class="d-none">
                            <option value="0">-</option>
                            <option value="1">آماده برای طراحی یا تدوین</option>
                            <option value="2">اتمام پروژه و موفق</option>
                            <option value="3">اتمام پروژه و ناموفق</option>
                        </select>
                   
                        <div id="divColorPicker" class="color-picker-container" hidden="hidden">
                          <label for="colorPicker" class="label">انتخاب رنگ</label>
                          <input type="color" id="colorPicker">
                        </div>

                        <div class="fv-row mb-15" id="div_defaultsms">
                            <label id="descTitle" class="fs-6 fw-bold mb-2">متن پیش فرض</label>
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

    <!-- Modal Structure -->
    <div class="modal fade" id="kt_modal_check_list" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header" id="kt_modal_check_list_header">
                    <h2 class="fw-bolder" id="model_CheckListDataHeader"></h2>
                    <div id="btn_close_modal_check_list" class="btn btn-icon btn-sm btn-active-icon-primary">
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

                    <h3>افزودن موارد چک‌لیست</h3>
                    <div id="checklistItemsContainer">
                        <div class="row">
                            <input type="text" class="checklist-input" placeholder="عنوان" />
                            <input type="text" class="checklist-input" placeholder="اولویت" />
                        </div>
                    </div>
                    <button class="btn btn-add" onclick="addChecklistRow()">➕ افزودن</button>

                </div>
                <div class="modal-footer flex-center">
                    <button onclick="saveChecklist();" class="btn btn-primary">
                        <span class="indicator-label">ثبت اطلاعات</span>
                    </button>
                    <button type="reset" id="btncancel_check_list" class="btn btn-light me-3">انصراف</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">


        const ExpenseType = '50';
        const ProjectType = '80';
        const InvoiceStatus = '1001';
        const NotificationTemplate = '1002';
        const ProjectStatus = '1003';

        var d_id = "";
        var defaultsms = document.getElementById('div_defaultsms');
        //var state = document.getElementById('div_state');
        var div_priority = document.getElementById('div_priority');
        var cmbProjectStatusSteps = document.getElementById('cmbProjectStatusSteps');
        var divColorPicker = document.getElementById('divColorPicker');
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
            if (typeId == InvoiceStatus || typeId == NotificationTemplate || typeId == ProjectStatus) {
                var defulatsms = $("#d_defaultsms").val();
                var SendForWomen = $("#d_SendForWomen").prop("checked");
                var SendForMen = $("#d_SendForMen").prop("checked");

                let route = '';
                let method = 'POST';
                if (typeId == InvoiceStatus) {
                    route = '/InvoiceStatus/Create';
                    let createInvoiceStatusCommand =
                    {
                        id: d_id,
                        title: title,
                        active: active,
                        notificationTemplate: defulatsms,
                        priority: priority,
                        sendToFather: SendForMen,
                        sendToMother: SendForWomen,
                        isRemovable: true,
                        isEditable: true
                    };
                    ajaxAuthCall(method, route, createInvoiceStatusCommand, success, error);
                } else if (typeId == NotificationTemplate) {
                    route = '/NotificationTemplate/Update';
                    method = 'PUT';
                    let updateTemplateCommand =
                    {
                        id: parseInt(d_id),
                        title: title,
                        active: active,
                        notificationTemplate: defulatsms,
                        priority: parseInt(priority),
                        sendToFather: SendForMen,
                        sendToMother: SendForWomen,
                        isRemovable: true,
                        isEditable: true
                    };
                    ajaxAuthCall(method, route, updateTemplateCommand, success, error);
                } else if (typeId == ProjectStatus) {

                    if (!title) {
                        toastr.warning('لطفا عنوان را مشخص کنید', 'عنوان');
                        return;
                    }
                    if (!priority || priority == '0') {
                        toastr.warning('لطفا اولویت را مشخص کنید', 'اولویت');
                        return;
                    }
                    //if (!defulatsms) {
                    //    toastr.warning('لطفا توضیحات را وارد کنید', 'توضیحات');
                    //    return;
                    //}

                    let color = $('#colorPicker').val();

                    if (d_id == '') {
                        method = 'POST';
                        route = '/ProjectStatus/Create';
                    } else {
                        method = 'PUT';
                        route = '/ProjectStatus/Update';
                    }
                    let createProjectStatusCommand =
                    {
                        id: d_id,
                        title: title,
                        active: active,
                        description: defulatsms,
                        priority: parseInt(priority),
                        step: cmbProjectStatusSteps.value,
                        color: color
                    };
                    ajaxAuthCall(method, route, createProjectStatusCommand, success, error);
                }
            } else {
                if (!title) {
                    toastr.warning('لطفا عنوان را مشخص کنید', 'عنوان');
                    return;
                }
                let createItemCommand =
                {
                    id: d_id,
                    title: title,
                    categoryId: typeId,
                    active: active,
                    priority: priority
                };
                if (d_id == '') {
                    method = 'POST';
                    route = '/BasicData/Create';
                } else {
                    method = 'PUT';
                    route = '/BasicData/Update';
                }

                ajaxAuthCall(method, route, createItemCommand, success, error);
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

            cmbProjectStatusSteps.classList.add('d-none');
            $(divColorPicker).attr('hidden', 'hidden');
            
            div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
            defaultsms.style.visibility = 'hidden';
            document.getElementById('d_defaultsms').style.visibility = 'hidden';
            if (typeId == InvoiceStatus) {
                //invoiceStatus
                $("#descTitle").html('متن پیش فرض');
                $("#d_KeywordSMS").text("کلید واژه ها: {{عنوان خانواده}}-{{عنوان وضعیت}}");
                $("#d_defaultsms").val(`خانواده {{عنوان خانواده}} عزیز سفارش شما در مرحله { {عنوان وضعیت } } قرار گرفته است`);
                div_Show_SendFor_Men_Or_Women.style.visibility = 'visible';
                defaultsms.style.visibility = 'visible';
                document.getElementById('d_defaultsms').style.visibility = 'visible';
            } else if (typeId == ProjectStatus) {
                cmbProjectStatusSteps.classList.remove('d-none');
                $(divColorPicker).removeAttr('hidden');
                defaultsms.style.visibility = 'visible';
                document.getElementById('d_defaultsms').style.visibility = 'visible';
                $("#descTitle").html('توضیحات');
                $("#d_KeywordSMS").text("-");
                $("#d_defaultsms").val(``);
            }

            if (typeId == ExpenseType) {
                //نوع هزینه
                div_priority.style.visibility = 'hidden';
            } else {
                div_priority.style.visibility = 'visible';
            }
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
                if (filterTypeId == InvoiceStatus) {
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
        }

        function EditBasicData(id, filterTypeId) {

            document.getElementById('d_defaultsms').style.visibility = 'hidden';
            cmbProjectStatusSteps.style.visibility = 'hidden';
            $(divColorPicker).attr('hidden', 'hidden');
            

            let query = `?id=${id}`;
            let route = '';
            if (filterTypeId == InvoiceStatus) {
                route = '/InvoiceStatus/Get';
            } else if (filterTypeId == NotificationTemplate) {
                route = '/NotificationTemplate/Get';
            } else if (filterTypeId == ProjectStatus) {
                route = '/ProjectStatus/Get';
            } else {
                route = '/BasicData/Get';
            }

            ajaxGet(route + query, function (res) {

                if (res.success) {
                    var result = res.data;
                    editData = true;
                    d_id = id.toString();
                    $("#d_title").val(result.title);
                    $("#d_active").prop("checked", result.active);

                    if (filterTypeId == NotificationTemplate) {

                        $("#d_defaultsms").val(result.templateText);
                        $("#d_KeywordSMS").text("کلید واژه ها: " + result.keywords);
                        $("#d_SendForMen").prop("checked", result.sendToFather);
                        $("#d_SendForWomen").prop("checked", result.sendToMother);

                        document.getElementById('d_defaultsms').style.visibility = 'visible';

                    } else if (filterTypeId == ProjectStatus) {

                        $("#d_defaultsms").val(result.desc);
                        cmbProjectStatusSteps.style.visibility = 'visible';
                        $(divColorPicker).removeAttr('hidden');
                        document.getElementById('d_defaultsms').style.visibility = 'visible';

                        cmbProjectStatusSteps.value = result.step;
                        $('#colorPicker').val(result.color);
                    }

                    currentTypeId = filterTypeId;
                    $("#d_Typeid").val(filterTypeId);
                    $("#d_pariority").val(result.priority);
                    $("#d_DurationForSend").val(result.sendDaysToEvent);
                    $("#d_DescForUser").val(result.descForUser);
                    $("#d_lbl_DusrationForSend").text('روز مانده به ' + result.title);
                    $("#model_basicDataHeader").text("ویرایش اطلاعات پایه " + result.title);

                    document.getElementById("div_typeData").style.display = 'none';
                    if (result.systematic) {
                        document.getElementById("div_priority").style.display = 'none';
                    }

                    //نمایش مدت زمان ارسال پیام
                    ShowDurationForSend = filterTypeId == NotificationTemplate;
                    if (ShowDurationForSend) {
                        div_DurationForSend.style.visibility = 'visible';
                    }
                    else {
                        div_DurationForSend.style.visibility = 'hidden';
                    }

                    ////توضیحات برای کاربر
                    if (result.descForUser) {
                        div_DescForUser.style.visibility = 'visible';
                    }
                    else {
                        div_DescForUser.style.visibility = 'hidden';
                    }

                    //ارسال پیام به آقا یا خانم
                    if (filterTypeId == InvoiceStatus || filterTypeId == NotificationTemplate) {
                        div_Show_SendFor_Men_Or_Women.style.visibility = 'visible';
                    }
                    else {
                        div_Show_SendFor_Men_Or_Women.style.visibility = 'hidden';
                    }
                    $("#d_Typeid").change();
                } else {
                    ShowError(res.message);
                }
            }, function (err) {
                ShowError("خطا در دریافت اطلاعات");
            });
        }
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

                options += `<option value='${InvoiceStatus}'>وضعیت فاکتور</option>`;
                options += `<option value='${ProjectStatus}'>وضعیت پروژه</option>`;
                $("#d_Typeid").html(options);

                options += `<option value='${NotificationTemplate}'>متن پیشفرض پیام ها</option>`;
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
        let dataTableRows = [];
        function loadTableDataBasicData() {
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            var filter_typeId = $("#filter_typeId").val();
            let route = '';
            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${searchText}&category=${filter_typeId}`;
            if (filter_typeId == InvoiceStatus) {
                route = '/InvoiceStatus/GetStatuses';
            } else if (filter_typeId == NotificationTemplate) {
                route = '/NotificationTemplate/GetTemplates';
            } else if (filter_typeId == ProjectStatus) {
                route = '/ProjectStatus/GetProjectStatuses';
            } else {
                route = '/BasicData/GetItems';
            }

            const tbody = $("#dt_BasicData");
            tbody.empty();
            ajaxGet(route + query, function (res) {
                dataTableRows = res.items;
                const totalRecords = res.totalCount;

                dataTableRows.forEach(row => {
                    let deleteAction = `<button class='btnDataTable btnDataTable-delete' onclick='DeleteBasicData("${row.id}","${filter_typeId}")' title='حذف'>🗑</button>`;
                    if (filter_typeId == InvoiceStatus) {
                        if (!row.isRemovable) {
                            deleteAction = '';
                        }
                    } else if (filter_typeId == NotificationTemplate) {
                        deleteAction = '';
                    }

                    let otherActions = '';
                    if (filter_typeId == ProjectType) {
                        otherActions += `<button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_check_list' onclick='showCheckList("${row.id}")' title='چک لیست'>📋</button>`;
                    }


                    let actions =
                        `
                <div class='action-buttons'>
                        ${otherActions}
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#kt_modal_add_customer' onclick='EditBasicData("${row.id}","${filter_typeId}")' title='ویرایش'>✎</button>
                        ${deleteAction}
                        </div>
                `;

                    let status = '';
                    if (row.active) {
                        status = `<div class='badge badge-light-success'>فعال</div>`;
                    } else {
                        status = `<div class='badge badge-light-danger'>غیرفعال</div>`;
                    }

                    let priority = '';
                    if (filter_typeId == ProjectStatus) {
                        priority = `<div class="circle" style="background-color:${row.color}">${row.priority}</div>`;
                    } else {
                        priority = row.priority ? row.priority : (row.priority == 0 ? '0' : '-');
                    }

                    tbody.append(`
                        <tr>
                            <td>${row.title}</td>
                            <td>${priority}</td>
                            <td>${status}</td>
                            <td>${actions}</td>
                        </tr>
                    `);
                });

                // بروزرسانی صفحه فعلی
                $("#pageIndex").text(pageIndex);
                $("#countAllTable").text(totalRecords);
                // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                $("#prevPageBtn").prop("disabled", !res.hasPreviousPage);
                $("#nextPageBtn").prop("disabled", !res.hasNextPage);
            }, function (err) {

            });
        }
    </script>


    <%--check-list--%>
    <script>
        // Add a new row dynamically
        function addChecklistRow(id = '', title = '', priority = 0) {
            const container = document.getElementById("checklistItemsContainer");

            // Create new row div
            const row = document.createElement("div");
            row.classList.add("row");
            row.id = id;

            // Create the first text input
            const input1 = document.createElement("input");
            input1.type = "text";
            input1.classList.add("checklist-input");
            input1.placeholder = "عنوان";
            input1.value = title;

            // Create the second text input
            const input2 = document.createElement("input");
            input2.type = "text";
            input2.classList.add("checklist-input");
            input2.placeholder = "اولویت";
            input2.value = priority;

            // Append the inputs to the row
            row.appendChild(input1);
            row.appendChild(input2);

            // Append the row to the container
            container.appendChild(row);
        }

        // Save checklist function (example implementation)
        function saveChecklist() {
            const rows = document.querySelectorAll("#checklistItemsContainer .row");
            const checklistItems = [];

            rows.forEach(row => {
                const inputs = row.querySelectorAll("input");
                const item = {
                    id: row.id ? row.id : null,
                    title: inputs[0].value,
                    priority: inputs[1].value ? parseInt(inputs[1].value) : 0,
                    active: true
                };
                checklistItems.push(item);
            });
            if (checklistItems.find(r => !r.title)) {
                toastr.warning('لطفا عنوان را مشخص کنید', 'عنوان');
                return;
            }
            let route = '/BasicData/CreateSubItems';
            let projectCheckList =
            {
                id: currentProjectTypeId,
                subItems: checklistItems
            };
            ajaxAuthCall('POST', route, projectCheckList, closeModalCheckList, function () {
                //err
            });
        }
        let currentProjectTypeId = '';
        function showCheckList(id) {
            let row = dataTableRows.find(r => r.id === id);
            currentProjectTypeId = row.id;
            const container = document.getElementById("checklistItemsContainer");
            container.innerHTML = '';
            const modalHeader = document.getElementById("model_CheckListDataHeader");
            modalHeader.innerHTML = `چک لیست ${row.title}`;


            let query = `?id=${currentProjectTypeId}`;
            let route = '/BasicData/GetSubItems';

            ajaxGet(route + query, function (items) {
                items.forEach(item => {
                    addChecklistRow(item.id, item.title, item.priority);
                });
            }, function (err) {
                ShowError("خطا در دریافت اطلاعات");
            });

        }
        function closeModalCheckList() {
            $('#kt_modal_check_list').modal('hide');
        };

    </script>
</asp:Content>
