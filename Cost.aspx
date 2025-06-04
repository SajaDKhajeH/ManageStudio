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
                                        <option value="">انتخاب ثبت کننده</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_PaidFrom">
                                        <option value="">پرداخت کننده</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_PaidTo">
                                        <option value="">دریافت کننده</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_CostType">
                                        <option value="">انتخاب هزینه</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_PaidType">
                                        <option value="">انتخاب نوع پرداخت</option>
                                    </select>
                                </div>
                            </div>

                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-130px">پرداخت کننده</th>
                                        <th class="min-w-100px">تاریخ پرداخت</th>
                                        <th class="min-w-120px">بابت</th>
                                        <th id="lblPrice" class="min-w-130px">مبلغ</th>
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
        var c_Id = "";
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

            if (!co_PaidFrom) {
                toastr.warning('شخص پرداخت کننده را انتخاب کنید', 'پرداخت کننده');
                return;
            }
            if (!co_CostType) {
                toastr.warning('موضوع پرداخت را مشخص کنید', 'موضوع پرداخت');
                return;
            }
            if (!co_PaidType) {
                toastr.warning('طریقه پرداخت را مشخص کنید', 'طریقه پرداخت');
                return;
            }
            if (!PaidDate) {
                toastr.warning('تاریخ پرداخت را مشخص کنید', 'تاریخ پرداخت');
                return;
            }
            if (parseInt(co_PaidPrice) <= 0) {
                toastr.warning('مبلغ معتبر وارد کنید', 'مبلغ');
                return;
            }

            let createCostCommand =
            {
                id: c_Id,
                payFromId: co_PaidFrom,
                price: co_PaidPrice,
                expenseTypeId: co_CostType,
                date: PaidDate,
                payTypeId: co_PaidType,
                trackingCode: co_RefNumber,
                payToId: co_PaidTo || null,
                desc: co_desc,
            };
            let method = 'POST';
            let route = '/Cost/Create';
            if (c_Id != '') {
                method = 'PUT';
                route = '/Cost/Update';
            }
            ajaxAuthCall(method, route, createCostCommand, function (res) {
                if (res.success) {
                    toastr.success('اطلاعات ذخیره شد', "موفق");
                    closeModal();
                    loadTableDataCost();
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
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
            c_Id = "";
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
            c_Id = "";
        };
        function DeleteCost(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                let query = `?id=${id}`;
                ajaxDelete('/Cost/Delete' + query, function (res) {
                    if (res.success) {
                        toastr.success('هزینه حذف شد', "موفق");
                        loadTableDataCost();
                    }
                    else {
                        ShowError(res.message);
                    }
                },
                    function () {
                        toastr.error("خطا در حذف اطلاعات", "خطا");
                    });
            }
        }
        function EditCost(id) {
            c_Id = id;
            let query = `?id=${id}`;
            ajaxGet('/Cost/GetCost' + query, function (res) {
                if (res.success) {
                    let data = res.data;
                    $("#header_AddEidtCost").text("ویرایش هزینه " + data.expenseTitle + "- پرداخت کننده:" + data.payFrom);
                    $("#co_PaidFrom").val(data.payFromId);
                    $("#co_PaidPrice").val(data.price);
                    $("#co_CostType").val(data.expenseTypeId);
                    $("#co_PaidType").val(data.payTypeId);
                    $("#co_PaidDate").val(data.date);
                    $("#co_RefNumber").val(data.trackingCode);
                    $("#co_PaidTo").val(data.payToId);
                    $("#co_desc").val(data.desc);
                    TextFormatPrice($("#co_PaidPrice"));
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
                toastr.error("خطا در دریافت اطلاعات", "خطا");
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
        function fillPayTypes() {
            const defaultOption = '<option value="">انتخاب نوع پرداخت</option>';
            ajaxGet('/BasicData/PayTypes', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');

                $('#filter_PaidType').html(defaultOption + options);
                $('#co_PaidType').html(options);
            });
        }
        function fillInfo() {
            fillAllUsers();
            fillInvoiceCreatorsCMBAsync('filter_CauserId', false);
            fillExpenseTypes();
            fillPayTypes();
        }
        $(document).ready(function () {
            $("#lblPrice").text(`مبلغ(${currency})`);
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
            $("#nextPageBtn").click(function () {
                pageIndex++;
                loadTableDataCost();
            });
            $("#prevPageBtn").click(function () {
                pageIndex--;
                loadTableDataCost();
            });
            $("#filterBtn").click(function () {
                pageIndex = 0;
                loadTableDataCost();
            });
        });
    </script>
    <script>
        let pageIndex = 0;
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

            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${filter}`;
            query += `&fromDate=${filter_From_Date}&toDate=${filter_To_Date}`;
            query += `&creatorId=${filter_CauserId}&payFromId=${filter_PaidFrom}&payToId=${filter_PaidTo}`;
            query += `&expenseTypeId=${filter_CostType}&payTypeId=${filter_PaidType}`;

            const tbody = $("#dt_Costs");
            tbody.empty();

            ajaxGet('/Cost/GetCosts' + query, function (res) {
                const data = res.items;
                const totalRecords = res.totalCount;


                let sumPrice = 0;
                data.forEach(row => {

                    sumPrice += row.price;

                    let actions =
                        `
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#model_AddEditCost' onclick='EditCost("${row.id}")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='DeleteCost("${row.id}")' title='حذف'>🗑</button>
                </div>
                        `;
                    tbody.append(`
                        <tr>
                            <td>${row.payFrom}</td>
                            <td>${row.date}</td>
                            <td>${row.expenseType}</td>
                            <td>${CurrencyFormatted(row.price)}</td>
                            <td>${row.payType}</td>
                            <td>${row.trackingCode}</td>
                            <td>${row.payTo}</td>
                            <td>${row.createdBy}</td>
                            <td>${row.creationTime}</td>
                            <td>${actions}</td>
                        </tr>
                    `);
                });
                $("#sumPriceCost").text(CurrencyFormatted(sumPrice) + ' ' + currency);

                // بروزرسانی صفحه فعلی
                $("#pageIndex").text(pageIndex + 1);
                $("#countAllTable").text(totalRecords);
                // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                $("#prevPageBtn").prop("disabled", pageIndex === 0);
                $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecords);
            },
                function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                });
        }
    </script>
</asp:Content>

