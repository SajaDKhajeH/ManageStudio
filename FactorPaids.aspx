<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="FactorPaids.aspx.cs" Inherits="FactorPaids" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                                        <option value="">انتخاب خانواده</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_PaidType">
                                        <option value="">انتخاب نوع پرداخت</option>
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
                                        <th id="lblPrice" class="min-w-100px">مبلغ پرداختی</th>
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
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
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
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>
        let pageIndex = 0;
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
            if (!filter_Family)
                filter_Family = '';

            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${searchText}`;
            query += `&fromDate=${filter_From_Date}&toDate=${filter_To_Date}`;
            query += `&familyId=${filter_Family}&payTypeId=${filter_PaidType}`;

            const tbody = $("#dt_Paid");
            tbody.empty();

            ajaxGet('/Pay/GetPayments' + query, function (res) {
                const data = res.items;
                const totalRecords = res.totalCount;


                let sumPrice = 0;

                data.forEach(row => {

                    sumPrice += row.price;

                    let actions =
                        `
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-delete' onclick='PaidDelete("${row.id}")' title='حذف'>🗑</button>
                </div>
                        `;

                    tbody.append(`
     <tr>
         <td>${0}</td>
         <td>${row.family}</td>
         <td>${row.price}</td>
         <td>${row.payType}</td>
         <td>${row.trackingCode}</td>
         <td>${row.fundAndBank}</td>
         <td>${row.desc}</td>
         <td>${row.createdBy}</td>
         <td>${row.creationTime}</td>
         <td>${actions}</td>
     </tr>
 `);

                });
                $("#sumPricePaids").text(CurrencyFormatted(sumPrice) + ' ' + currency);

                $("#pageIndex").text(pageIndex);
                $("#countAllTable").text(totalRecords);
                $("#prevPageBtn").prop("disabled", pageIndex === 0);
                $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecords);
            },
                function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                });
        }
        $("#prevPageBtn").click(function () {
            pageIndex--;
            loadTableDataPaids();
        });

        $("#filterBtn").click(function () {
            pageIndex = 0;
            loadTableDataPaids();
        });
        $("#nextPageBtn").click(function () {
            pageIndex++;
            loadTableDataPaids();
        });
        function fillFamiliesAsync() {
            const defaultOption = '<option value="">انتخاب خانواده</option>';
            ajaxGet('/Family/GetAllFamilies', function (families) {
                const options = families.map(family =>
                    `<option value="${family.id}">${family.title}</option>`
                ).join('');
                $('#filter_Family').html(defaultOption + options);
            });
        }
        function fillPayTypes() {
            const defaultOption = '<option value="">انتخاب نوع پرداخت</option>';
            ajaxGet('/BasicData/PayTypes', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');

                $('#filter_PaidType').html(defaultOption + options);
            });
        }
        function fillInfo() {
            fillFamiliesAsync();
            fillPayTypes();
            loadTableDataPaids();
        }
        $(document).ready(function () {
            $("#lblPrice").text(`مبلغ(${currency})`);
            $("#master_PageTitle").text("مدیریت پرداختی ها");
            $("#s_pageSize").val("5");
            fillInfo();
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

