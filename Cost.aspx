<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Cost.aspx.cs" Inherits="Cost" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-header border-0 pt-6">
                    <div class="card-title">
                    </div>
                    <div class="card-toolbar">
                    </div>
                </div>
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="از تاریخ" id="filter_From_Date">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="تا تاریخ" id="filter_To_Date">
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2  open-modal-btn" onclick="ResetFeilds()" data-bs-toggle="modal" data-bs-target="#model_AddEditCost">افزودن هزینه</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-2">
                                    <select id="filter_CauserId">
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_PaidFrom">
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_PaidTo">
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_CostType">
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_PaidType">
                                        <%Response.Write(PublicMethod.GetPaidType(true)); %>
                                    </select>
                                </div>
                            </div>

                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-130px">پرداخت کننده</th>
                                        <th class="min-w-100px">تاریخ پرداخت</th>
                                        <th class="min-w-120px">بابت</th>
                                        <th class="min-w-130px">مبلغ</th>
                                        <th class="min-w-70px">نوع پرداخت</th>
                                        <th class="min-w-70px">پیگیری</th>
                                        <th class="min-w-100px">پرداخت به</th>
                                        <th class="min-w-100px">ثبت کننده</th>
                                        <th class="min-w-120px">تاریخ ثبت</th>
                                        <th class="min-w-100px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Costs">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>مجموع: <span id="sumPriceCost" class="fw-bold">0</span></span>
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataCost()">
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
    <div class="modal fade" id="model_AddEditCost" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header" id="kt_modal_add_customer_header">
                    <h2 class="fw-bolder" id="header_AddEidtCost">افزون اطلاعات</h2>
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
                                <label>شخص پرداخت کننده</label>
                                <select id="co_PaidFrom">
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>مبلغ</label>
                                <input type="text" class="form-control" style="margin: 3px" id="co_PaidPrice" onkeyup="TextFormatPrice(this)" placeholder="مبلغ پرداختی">
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>نوع هزینه</label>
                                <select id="co_CostType">
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>طریقه پرداخت</label>
                                <select id="co_PaidType">
                                    <%Response.Write(PublicMethod.GetPaidType()); %>
                                </select>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-4 fv-row">
                                <label>تاریخ پرداخت</label>
                                <input style="margin: 3px" class="form-control datepicker" id="co_PaidDate">
                            </div>
                            <div class="col-md-4 fv-row">
                                <label>شماره پیگیری</label>
                                <input style="margin: 3px" type="text" id="co_RefNumber" class="form-control" placeholder="شماره پیگیری">
                            </div>
                            <div class="col-md-4 fv-row">
                                <label>پرداخت به</label>
                                <select id="co_PaidTo">
                                </select>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-12 fv-row">
                                <textarea style="margin: 3px" placeholder="توضیحات" class="form-control" id="co_desc"></textarea>
                            </div>
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script src="assets/js/users/forcmb.js"></script>
    <script type="text/javascript">
        var c_Id = 0;
        var loginedUser = "";
        $("#btn_submitdata").click(function (e) {
            var co_PaidFrom = $("#co_PaidFrom").val();
            var co_PaidPrice = $("#co_PaidPrice").val();
            co_PaidPrice = convertPersianToEnglishNumbers(co_PaidPrice);
            co_PaidPrice = co_PaidPrice.replaceAll(",", "");
            var co_CostType = $("#co_CostType").val();
            var co_PaidType = $("#co_PaidType").val();
            var co_RefNumber = $("#co_RefNumber").val();
            co_RefNumber = convertPersianToEnglishNumbers(co_RefNumber);
            var co_desc = $("#co_desc").val();
            var co_PaidTo = $("#co_PaidTo").val();
            var PaidDate = $("#co_PaidDate").val();
            $.ajax({
                type: "POST",
                url: "Cost.aspx/AddEditCost",
                data: JSON.stringify({
                    id: c_Id, PaidFrom: co_PaidFrom, PaidPrice: co_PaidPrice, CostType: co_CostType, PaidType: co_PaidType,
                    RefNumber: co_RefNumber, desc: co_desc, PaidTo: co_PaidTo, PaidDate: PaidDate
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        loadTableDataCost();
                        toastr.success(msg.d.Message, "موفق");
                        closeModal();
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        });
        $('#btn_close').click(function () {
            closeModal();
        });
        $('#btncancel').click(function () {
            closeModal();
        });
        function closeModal() {
            $('#model_AddEditCost').modal('hide');
            c_Id = 0;
        };
        $("#btn_add").click(function (e) {
            ResetFeilds();
        });
        function ResetFeilds() {
            $("#header_AddEidtCost").text("ثبت هزینه");
            $("#co_PaidPrice").val("0");
            $("#co_PaidDate").val("");
            $("#co_PaidType").val("");
            $("#co_RefNumber").val("");
            $("#co_desc").val("");
            $("#co_PaidTo").val("");
            $("#co_PaidFrom").val(loginedUser);
            c_Id = 0;
        };
        function DeleteCost(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "Cost.aspx/DeleteCost",
                    data: "{id:'" + id + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var result = res.d;
                        if (result.Result == false) {//خطا داریم
                            ShowError(result.Message);
                        }
                        else {
                            toastr.success(result.Message, "موفق");
                            loadTableDataCost();
                        }
                    },
                    error: function () {
                        toastr.error("خطا در حذف اطلاعات", "خطا");
                    }
                });
            }
        };
        function EditCost(id) {
            $.ajax({
                type: "POST",
                url: "Cost.aspx/EditCost",
                data: "{id:" + id + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var result = res.d;
                    if (result.Result == false) {//خطا داریم
                        ShowError(result.Message);
                    }
                    else {
                        c_Id = id;
                        $("#header_AddEidtCost").text("ویرایش هزینه " + result.CostTitle + "- پرداخت کننده:" + result.PaidFromFullName);
                        $("#co_PaidFrom").val(result.PaidFrom);
                        $("#co_PaidPrice").val(result.PaidPrice);
                        $("#co_CostType").val(result.CostType);
                        $("#co_PaidDate").val(result.PaidDate);
                        $("#co_PaidType").val(result.PaidType);
                        $("#co_RefNumber").val(result.RefNumber);
                        $("#co_desc").val(result.Desc);
                        $("#co_PaidTo").val(result.PaidTo);
                        TextFormatPrice($("#co_PaidPrice"));
                    }
                },
                error: function () {
                    toastr.error("خطا در دریافت داده‌ها", "خطا");
                }
            });
        };

        function fillAllUsers() {
            let defaultOption = '<option value="">انتخاب پرسنل</option>';
            ajaxGet('/User/GetAllUsers', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');

                $('#co_PaidTo').html(defaultOption + options);

                defaultOption = '<option value="">پرداخت کننده</option>';
                $('#filter_PaidFrom').html(defaultOption + options);

                defaultOption = '<option value="">دریافت کننده</option>';
                $('#filter_PaidTo').html(defaultOption + options);

                $('#co_PaidFrom').html(options);

            });
        }
        function fillExpenseTypes() {
            const defaultOption = '<option value="">انتخاب هزینه</option>';
            ajaxGet('/BasicData/ExpenseTypes', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');

                $('#filter_CostType').html(defaultOption + options);
                $('#co_CostType').html(options);
            });
        }
        function fillInfo() {
            fillAllUsers();
            fillInvoiceCreatorsCMBAsync('filter_CauserId', false);
            fillExpenseTypes();
        }
        $(document).ready(function () {
            fillInfo();
            $("#master_PageTitle").text("هزینه ها");
            $("#s_pageSize").val("5");
            $.ajax({
                type: "POST",
                url: "Cost.aspx/GetLoginedUserIdCoded",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    loginedUser = res.d;
                },
                error: function () {
                    toastr.error("خطا در حذف اطلاعات", "خطا");
                }
            });
            loadTableDataCost();
            $('#co_PaidDate').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: true,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
            $('#filter_From_Date').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: false,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
            $('#filter_To_Date').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: false,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
            // صفحه بعد
            $("#nextPageBtn").click(function () {
                pageIndex++;
                loadTableDataCost();
            });
            // صفحه قبل
            $("#prevPageBtn").click(function () {
                pageIndex--;
                loadTableDataCost();
            });
            // اعمال فیلتر
            $("#filterBtn").click(function () {
                pageIndex = 1;
                loadTableDataCost();
            });
        });
    </script>
    <script>
        let pageIndex = 1;
        let pageSize = 5;
        function loadTableDataCost() {
            var filter = $("#filterInput").val();
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_CauserId = $("#filter_CauserId").val();
            var filter_PaidFrom = $("#filter_PaidFrom").val();
            var filter_PaidTo = $("#filter_PaidTo").val();
            var filter_CostType = $("#filter_CostType").val();
            var filter_PaidType = $("#filter_PaidType").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "Cost.aspx/ForGrid",
                data: JSON.stringify({
                    page: pageIndex, perPage: pageSize, fromDate: filter_From_Date,
                    toDate: filter_To_Date, PaidTypeId: filter_PaidType, searchText: filter,
                    causerId: filter_CauserId, CostTypeId: filter_CostType, PaidFromId: filter_PaidFrom, PaidToId: filter_PaidTo
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    const totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Costs");
                    $("#sumPriceCost").text(response.d.Message);
                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.PaidFromFullName}</td>
                            <td>${row.PaidDate}</td>
                            <td>${row.CostType}</td>
                            <td>${row.PaidPrice}</td>
                            <td>${row.PaidType}</td>
                            <td>${row.RefNumber}</td>
                            <td>${row.PaidToFullName}</td>
                            <td>${row.CauserName}</td>
                            <td>${row.Date_A_Time}</td>
                            <td>${row.Actions}</td>
                        </tr>
                    `);
                    });

                    // بروزرسانی صفحه فعلی
                    $("#pageIndex").text(pageIndex);
                    $("#countAllTable").text(totalRecords);
                    // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                    $("#prevPageBtn").prop("disabled", pageIndex === 1);
                    $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecords);
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                }
            });
        }
    </script>
</asp:Content>

