<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="FactorPaids.aspx.cs" Inherits="FactorPaids" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-2">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="از تاریخ" id="filter_From_Date">
                                </div>
                                <div class="col-md-2">
                                    <input class="form-control datepicker" placeholder="تا تاریخ" id="filter_To_Date">
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_Family" data-dropdown-parent="#kt_post" data-control="select2" class="form-select form-select-solid select2-hidden-accessible" data-placeholder="انتخاب مشتری">
                                        <%Response.Write(PublicMethod.GetCustomer()); %>
                                    </select>
                                </div>
                                 <div class="col-md-2">
                                    <select id="filter_PaidType">
                                        <%Response.Write(PublicMethod.GetPaidType(true)); %>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                            </div>
                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-50px">ردیف</th>
                                        <th class="min-w-130px">عنوان خانواده</th>
                                        <th class="min-w-100px">مبلغ پرداختی</th>
                                        <th class="min-w-100px">طریقه پرداخت</th>
                                        <th class="min-w-100px">شماره پیگیری</th>
                                        <th class="min-w-100px">صندوق/بانک</th>
                                        <th class="min-w-150px">توضیحات</th>
                                        <th class="min-w-130px">ثبت کننده</th>
                                        <th class="min-w-130px">تاریخ و ساعت ثبت</th>
                                        <th class="min-w-130px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Paid">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>مجموع: <span id="sumPricePaids" class="fw-bold">0</span></span>
                                <span>صفحه فعلی: <span id="currentPage" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataPaids()">
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

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" Runat="Server">
    <script>
        let currentPage = 1;
        let pageSize = 5;
        function PaidDelete(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "FactorPaids.aspx/PaidDelete",
                    data: JSON.stringify({
                        id: id
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var res = msg.d;
                        if (msg.d.Result == false) {//خطا داریم
                            ShowError(msg.d.Message);
                        }
                        else {
                            toastr.success(msg.d.Message, "موفق");
                            loadTableDataPaids();
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
        };
        function loadTableDataPaids() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Family = $("#filter_Family").val();
            var filter_PaidType = $("#filter_PaidType").val();
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "FactorPaids.aspx/ForGrid",
                data: JSON.stringify({ page: currentPage, perPage: pageSize, fromDate: filter_From_Date, toDate: filter_To_Date, familyId: filter_Family, searchText: searchText, PaidType: filter_PaidType }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    var totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Paid");
                    $("#sumPricePaids").text(response.d.Message);
                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.Row}</td>
                            <td>${row.FamilyTitle}</td>
                            <td>${row.PaidPrice}</td>
                            <td>${row.PaidType}</td>
                            <td>${row.RefNumber}</td>
                            <td>${row.CashBankTitle}</td>
                            <td>${row.SubjectText}</td>
                            <td>${row.Causer}</td>
                            <td>${row.Date_A_TimePaid}</td>
                            <td>${row.Actions}</td>
                        </tr>
                    `);
                    });

                    // بروزرسانی صفحه فعلی
                    $("#currentPage").text(currentPage);
                    $("#countAllTable").text(totalRecords);
                    // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                    $("#prevPageBtn").prop("disabled", currentPage === 1);
                    $("#nextPageBtn").prop("disabled", currentPage * pageSize >= totalRecords);
                },
                error: function () {
                    alert("خطا در دریافت داده‌ها");
                }
            });
        }
        // صفحه قبل
        $("#prevPageBtn").click(function () {
            currentPage--;
            loadTableDataPaids();
        });

        // اعمال فیلتر
        $("#filterBtn").click(function () {
            currentPage = 1;
            loadTableDataPaids();
        });
        // صفحه بعد
        $("#nextPageBtn").click(function () {
            currentPage++;
            loadTableDataPaids();
        });
        $(document).ready(function () {
            $("#master_PageTitle").text("مدیریت پرداختی ها");
            $("#s_pageSize").val("5");
            loadTableDataPaids();
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
        });
    </script>
</asp:Content>

