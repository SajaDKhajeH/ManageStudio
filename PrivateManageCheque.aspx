<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="PrivateManageCheque.aspx.cs" Inherits="PrivateManageCheque" %>

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
    <div class="d-flex-column-auto flex-fill" id="kt_post">
        <div id="kt_content_container">
            <div class="card">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="از تاریخ سررسید" id="filter_From_Date">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="تا تاریخ سررسید" id="filter_To_Date">
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-primary w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2  open-modal-btn" onclick="ResetFeilds()" data-bs-toggle="modal" data-bs-target="#model_AddEditCheque">افزودن چک</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                    <select id="filter_Registered">
                                        <option value="0">انتخاب وضعیت ثبت</option>
                                        <option value="1">ثبت شده</option>
                                        <option value="2">ثبت نشده</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_Recived">
                                        <option value="0">انتخاب نوع چک</option>
                                        <option value="1">دریافتی</option>
                                        <option value="2">پرداختی</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_Spent">
                                        <option value="0">انتخاب وضعیت خرج چک</option>
                                        <option value="1">خرج شده</option>
                                        <option value="2">خرج نشده</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select id="filter_bank">
                                    <%Response.Write(PublicMethod.GetBank()); %>
                                    </select>
                                </div>
                            </div>
                            
                        </div>
                <div class="row mt-3">
                    <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-70px">نوع چک</th>
                                        <th class="min-w-130px">تاریخ ثبت</th>
                                        <th class="min-w-100px">تاریخ سررسید</th>
                                        <th class="min-w-120px">بابت</th>
                                        <th class="min-w-130px">مبلغ</th>
                                        <th class="min-w-130px">بانک</th>
                                        <th class="min-w-70px">مالک چک</th>
                                        <th class="min-w-70px">وضعیت ثبت</th>
                                        <th class="min-w-70px">وضعیت خرج چک</th>
                                        <th class="min-w-100px">توضیحات</th>
                                        <th class="min-w-100px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Cheques">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>مجموع: <span id="sumPriceCheque" class="fw-bold">0</span></span>
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataCheque()">
                                        <%Response.Write(PublicMethod.Pagination()); %>
                                    </select>
                                </span>
                                <button id="nextPageBtn" class="btn btn-secondary">صفحه بعد</button>
                            </div>
                    </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="model_AddEditCheque" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header" id="kt_modal_add_customer_header">
                    <h2 class="fw-bolder" id="header_AddEidtCheque">افزون اطلاعات</h2>
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
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="c_Recive" class="form-check-input" name="TypeCheque" type="radio" />
                                        <span class="form-check-label fw-bold text-dark">دریافتی</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="c_Pay" class="form-check-input" name="TypeCheque" type="radio" />
                                        <span class="form-check-label fw-bold text-dark">پرداختی</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>مبلغ</label>
                                <input type="text" class="form-control" style="margin: 3px" id="c_Price" onkeyup="TextFormatPrice(this)" placeholder="مبلغ چک">
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>تاریخ ثبت</label>
                                <input style="margin: 3px" class="form-control datepicker" id="c_ReciveDate">
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>شماره چک</label>
                                <input style="margin: 3px" type="text" id="c_ChequeNumber" class="form-control" placeholder="شماره چک">
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>مالک چک</label>
                                <input style="margin: 3px" type="text" id="c_Owner" class="form-control" placeholder="مالک چک">
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>تاریخ سررسید</label>
                                <input style="margin: 3px" class="form-control datepicker" id="c_WillDate">
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>.</label>
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="c_Registered" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">ثبت شده است؟</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                         <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>بانک ها</label>
                                <select id="c_bank">
                                    <%Response.Write(PublicMethod.GetBank()); %>
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>.</label>
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="c_Spent" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">خرج شده است؟</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-12 fv-row">
                                <label>بابت</label>
                                <textarea style="margin: 3px" placeholder="بابت" class="form-control" id="c_forsubject"></textarea>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-12 fv-row">
                                <textarea style="margin: 3px" placeholder="توضیحات" class="form-control" id="c_desc"></textarea>
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
    <script type="text/javascript">
        var c_Id = 0;
        $("#btn_submitdata").click(function (e) {
            var c_Recive = $("#c_Recive").prop("checked");
            var c_Registered = $("#c_Registered").prop("checked");
            var c_Pay = $("#c_Pay").prop("checked");
            var c_Price = $("#c_Price").val();
            c_Price = c_Price.replaceAll(",", "");
            var c_ReciveDate = $("#c_ReciveDate").val();
            var c_ChequeNumber = $("#c_ChequeNumber").val();
            var c_Owner = $("#c_Owner").val();
            var c_WillDate = $("#c_WillDate").val();
            var c_forsubject = $("#c_forsubject").val();
            var c_desc = $("#c_desc").val();
            var c_Spent = $("#c_Spent").prop("checked");
            var c_bank = $("#c_bank").val();
            $.ajax({
                type: "POST",
                url: "PrivateManageCheque.aspx/AddEditCheque",
                data: JSON.stringify({
                    id: c_Id, c_Recive, c_Pay,
                    c_Price, c_ReciveDate, c_ChequeNumber,
                    c_Owner, c_WillDate, c_forsubject, c_desc, c_Registered,
                    c_Spent, c_bank
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        loadTableDataCheque();
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
            $('#model_AddEditCheque').modal('hide');
            c_Id = 0;
        };
        $("#btn_add").click(function (e) {
            ResetFeilds();
        });
        function ResetFeilds() {
            $("#header_AddEidtCheque").text("ثبت چک");
            $("#c_Recive").prop("checked", true);
            $("#c_Pay").prop("checked", true);
            $("#c_Spent").prop("checked", false);
            $("#c_Price").val("0");
            $("#c_ReciveDate").val("");
            $("#c_ChequeNumber").val("");
            $("#c_Owner").val("");
            $("#c_WillDate").val("");
            $("#c_forsubject").val("");
            $("#c_desc").val("");
            c_Id = 0;
        };
        function DeleteCheque(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "PrivateManageCheque.aspx/DeleteChqeue",
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
                            loadTableDataCheque();
                        }
                    },
                    error: function () {
                        toastr.error("خطا در حذف اطلاعات", "خطا");
                    }
                });
            }
        };
        function EditCheque(id) {
            $.ajax({
                type: "POST",
                url: "PrivateManageCheque.aspx/EditCheque",
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
                        $("#header_AddEidtCheque").text("ویرایش چک " + result.CostTitle + "- پرداخت کننده:" + result.PaidFromFullName);
                        $("#c_Recive").prop("checked", result.ChequeInfo.C_IsRecive == true);
                        $("#c_Pay").prop("checked", result.ChequeInfo.C_IsRecive == false);
                        $("#c_Price").val(result.ChequeInfo.C_Price);
                        $("#c_ReciveDate").val(result.ChequeInfo.C_ReciveDate);
                        $("#c_ChequeNumber").val(result.ChequeInfo.C_ChequeNumber);
                        $("#c_Owner").val(result.ChequeInfo.C_Owner);
                        $("#c_WillDate").val(result.ChequeInfo.C_WillReciveDate);
                        $("#c_forsubject").val(result.ChequeInfo.C_ForSubject);
                        $("#c_desc").val(result.ChequeInfo.C_Desc);
                        $("#c_Spent").prop("checked", result.ChequeInfo.C_Spent);
                        $("#c_bank").val(result.BankId);
                        $("#c_Registered").prop("checked", result.ChequeInfo.C_Registered);
                        TextFormatPrice($("#c_Price"));
                    }
                },
                error: function () {
                    toastr.error("خطا در دریافت داده‌ها", "خطا");
                }
            });
        };
        $(document).ready(function () {
            $("#master_PageTitle").text("چک ها");
            $("#s_pageSize").val("5");
            loadTableDataCheque();
            $('#c_ReciveDate').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: true,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
            $('#c_WillDate').persianDatepicker({
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
                loadTableDataCheque();
            });
            // صفحه قبل
            $("#prevPageBtn").click(function () {
                pageIndex--;
                loadTableDataCheque();
            });
            // اعمال فیلتر
            $("#filterBtn").click(function () {
                pageIndex = 1;
                loadTableDataCheque();
            });
        });
    </script>
    <script>
        let pageIndex = 1;
        let pageSize = 5;
        function loadTableDataCheque() {
            var filter = $("#filterInput").val();
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Registered = $("#filter_Registered").val();
            var filter_Recived = $("#filter_Recived").val();
            var filter_Spent = $("#filter_Spent").val();
            var filter_bank = $("#filter_bank").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "PrivateManageCheque.aspx/ForGrid",
                data: JSON.stringify({
                    page: pageIndex, perPage: pageSize, fromDate: filter_From_Date,
                    toDate: filter_To_Date, filter_Registered, filter_Recived, searchText: filter,
                    spent: filter_Spent, bank: filter_bank
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    const totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Cheques");
                    $("#sumPriceCheque").text(response.d.Message);
                    tbody.empty(); // پاک کردن داده‌های قدیمی
                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                     <tr>
                         <td>${row.C_IsRecive}</td>
                         <td>${row.C_ReciveDate}</td>
                         <td>${row.C_WillReciveDate}</td>
                         <td>${row.C_ForSubject}</td>
                         <td>${row.C_Price}</td>
                          <td>${row.BankTitle}</td>
                         <td>${row.C_Owner}</td>
                         <td>${row.C_Registered}</td>
                        <td>${row.Spent}</td>
                         <td>${row.C_Desc}</td>
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

