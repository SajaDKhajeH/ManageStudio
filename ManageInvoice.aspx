<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="ManageInvoice.aspx.cs" Inherits="AdakStudio.ManageInvoice" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex-column-auto flex-fill">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-body pt-0">
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
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Causer">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-80px">شماره فاکتور</th>
                                    <th class="min-w-130px">عنوان خانواده</th>
                                    <th class="min-w-80px">تاریخ ثبت</th>
                                    <th class="min-w-100px">مجموع فاکتور</th>
                                    <th class="min-w-100px">مجموع تخفیف</th>
                                    <th class="min-w-150px">وضعیت مالی</th>
                                    <th class="min-w-130px">عملیات</th>
                                </tr>
                            </thead>
                            <tbody id="dt_Invoice">
                                <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-between align-items-center">
                            <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                            <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                            <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                            <span>
                                <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataFacotrs()">
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">
    <script src="assets/js/basic-data/forcmb.js"></script>
    <script src="assets/js/users/forcmb.js"></script>
    <script>
        let pageIndex = 0;
        let pageSize = 5;


        // صفحه بعد
        $("#nextPageBtn").click(function () {
            pageIndex++;
            loadTableDataFacotrs();
        });

        // صفحه قبل
        $("#prevPageBtn").click(function () {
            pageIndex--;
            loadTableDataFacotrs();
        });

        // اعمال فیلتر
        $("#filterBtn").click(function () {
            pageIndex = 0;
            loadTableDataFacotrs();
        });

        function FactorDelete(id) {
            const userResponse = confirm("آیا از حذف فاکتور مطمئن هستید؟");
            if (userResponse) {
                let query = `?id=${id}`;
                ajaxDelete('/Invoice/Delete' + query, function (res) {
                    if (res.success) {
                        toastr.success("فاکتور حذف شد", "موفق");
                        loadTableDataFacotrs();
                    }
                    else {
                        ShowError(res.message);
                    }
                }, function (err) {
                    console.log(err);
                    alert("error");
                });
            }
        }

        function PrintFactor(id) {
            $.ajax({
                type: "POST",
                url: "ManageInvoice.aspx/PrintFactor",
                data: JSON.stringify({
                    id: id
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (res.Result) {
                        setTimeout(function () {
                            window.open(res.Url, '_blank').focus();
                        }, 110);
                    }
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                }
            });
        };
        function GoToAddEditFactor(id) {
            window.open("AddEditFactor.aspx?id=" + id, '_blank');
        }
        $(document).ready(function () {
            fillInfo();
            $("#master_PageTitle").text("مدیریت فاکتور");
            $("#s_pageSize").val("5");
            loadTableDataFacotrs();
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



    <script>
        function loadTableDataFacotrs() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Family = $("#filter_Family").val();
            var filter_Causer = $("#filter_Causer").val();
            var searchText = $("#filterInput").val();
            
            const tbody = $("#dt_Invoice");
            tbody.empty();

            pageSize = parseInt($("#s_pageSize").val());
            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${searchText}`;
            query += `&fromDate=${filter_From_Date}&toDate=${filter_To_Date}`;
            ajaxGet('/Invoice/GetInvoices' + query, function (res) {
                const data = res.items;
                const totalRecords = res.totalCount;
         

                // اضافه کردن داده‌های جدید
                data.forEach(row => {
                    let actions =
                        `
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-print' data-bs-toggle='modal' data-bs-target='#m_SetPaidPrice' onclick='PayDeposit("${row.familyId}",""" + (x.BedPrice > 0 ? "دریافت بدهی از " + x.FamilyTitle : "دریافت بیعانه از " + x.FamilyTitle) + @"""," + (x.BedPrice ?? 0) + @")' title='پرداخت'>💰</button>
                        <button class='btnDataTable btnDataTable-print' onclick='PrintFactor("${row.id}")' title='چاپ'>🖨</button>
                        <button class='btnDataTable btnDataTable-edit' onclick='GoToAddEditFactor("${row.id}")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='FactorDelete("${row.id}")' title='حذف'>🗑</button>
                </div>
                        `;
                    let familyTitle = `<a style='color: blue;text-decoration: underline;cursor: pointer' onclick='HideBtnAdd_Family("${row.familyId}")' data-bs-toggle='modal' data-bs-target='#modal_addedit_family'>${row.familyTitle}</a>`;
                    tbody.append(`
                <tr>
                    <td>${row.invoiceNumber}</td>
                    <td>${familyTitle}</td>
                    <td>${convertEnglishToPersianNumbers(row.date)}</td>
                    <td>${PersianCurrencyFormatted(row.sumPrice)}</td>
                    <td>${PersianCurrencyFormatted(row.sumDiscount)}</td>
                    <td>${row.finanStatus}</td>
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
            },
                function () {
                    alert("خطا در دریافت داده‌ها");
                });
        }
    </script>
    <script>
        function fillInfo() {
            fillFamiliesAsync();
            fillInvoiceCreatorsCMBAsync('filter_Causer', false);
        }
        function fillFamiliesAsync() {
            const defaultOption = '<option value="0">انتخاب خانواده</option>';
            ajaxGet('/Family/GetAllFamilies', function (families) {
                const options = families.map(family =>
                    `<option value="${family.id}">${family.title}</option>`
                ).join('');
                $('#filter_Family').html(defaultOption + options);
            });
        }

    </script>
</asp:Content>
