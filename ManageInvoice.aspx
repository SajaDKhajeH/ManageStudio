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
                                    <%Response.Write(PublicMethod.GetCustomer()); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Causer">
                                    <%Response.Write(PublicMethod.GetAdmin_A_Monshi()); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <select id="filter_factorStatus">
                                    <%Response.Write(PublicMethod.GetFactorStatus(true)); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_TypePhotographi">
                                    <%Response.Write(PublicMethod.GetTypePhotographi(true)); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Photographer">
                                    <%Response.Write(PublicMethod.GetPhotographer(true)); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Designer">
                                    <%Response.Write(PublicMethod.GetDesigner()); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_ForceDesign" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">فاکتورهای طراحی فورس</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-80px">شماره فاکتور</th>
                                    <th class="min-w-130px">عنوان خانواده</th>
                                    <%--<th class="min-w-80px">موضوع</th>--%>
                                    <th class="min-w-80px">وضعیت</th>
                                    <th class="min-w-100px">عکاس</th>
                                    <th class="min-w-100px">طراح</th>
                                    <%--<th class="min-w-60px">طراحی فورس</th>
                                        <th class="min-w-60px">هدیه</th>--%>
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
        
        function loadTableDataFacotrsOld() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Family = $("#filter_Family").val();
            var filter_Causer = $("#filter_Causer").val();
            var filter_factorStatus = $("#filter_factorStatus").val();
            var filter_TypePhotographi = $("#filter_TypePhotographi").val();
            var filter_Photographer = $("#filter_Photographer").val();
            var filter_Designer = $("#filter_Designer").val();
            var filter_ForceDesign = $("#filter_ForceDesign").prop("checked");
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "ManageInvoice.aspx/ForGrid",
                data: JSON.stringify({
                    page: pageIndex, perPage: pageSize, fromDate: filter_From_Date, toDate: filter_To_Date, familyId: filter_Family, searchText: searchText,
                    causer: filter_Causer, status: filter_factorStatus, typePhoto: filter_TypePhotographi, photographer: filter_Photographer,
                    designer: filter_Designer, isGift: false, forceDesign: filter_ForceDesign
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    var totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Invoice");

                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.FactorNumber}</td>
                            <td>${row.FamilyTitle}</td>
                            <td>${row.FactorStatus}</td>
                            <td>${row.Photographer}</td>
                            <td>${row.Designer}</td>
                            <td>${row.FactorDate}</td>
                            <td>${row.SumFactor}</td>
                            <td>${row.SumDiscount}</td>
                            <td>${row.FinanStatus}</td>
                            <td>${row.Actions}</td>
                        </tr>
                    `);
                    });

                    // بروزرسانی صفحه فعلی
                    $("#pageIndex").text(pageIndex);
                    $("#countAllTable").text(totalRecords);
                    // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                    $("#prevPageBtn").prop("disabled", pageIndex === 0);
                    $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecords);
                },
                error: function () {
                    alert("خطا در دریافت داده‌ها");
                }
            });
        }
        function FactorDelete(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "ManageInvoice.aspx/FactorDelete",
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
                            loadTableDataFacotrs();
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
        };
        
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
            var filter_factorStatus = $("#filter_factorStatus").val();
            var filter_TypePhotographi = $("#filter_TypePhotographi").val();
            var filter_Photographer = $("#filter_Photographer").val();
            var filter_Designer = $("#filter_Designer").val();
            var filter_ForceDesign = $("#filter_ForceDesign").prop("checked");
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${searchText}`;
            query += `&fromDate=${filter_From_Date}&toDate=${filter_To_Date}`;
            //data: JSON.stringify({
            //    page: pageIndex, perPage: pageSize, fromDate: filter_From_Date, toDate: filter_To_Date, familyId: filter_Family, searchText: searchText,
            //    causer: filter_Causer, status: filter_factorStatus, typePhoto: filter_TypePhotographi, photographer: filter_Photographer,
            //    designer: filter_Designer, isGift: false, forceDesign: filter_ForceDesign
            //}),
            ajaxGet('/Invoice/GetInvoices' + query, function (response) {
                const data = response.d.Data.data;
                var totalRecords = response.d.Data.recordsTotal;
                const tbody = $("#dt_Invoice");

                tbody.empty(); // پاک کردن داده‌های قدیمی

                // اضافه کردن داده‌های جدید
                data.forEach(row => {
                    tbody.append(`
                <tr>
                    <td>${row.FactorNumber}</td>
                    <td>${row.FamilyTitle}</td>
                    <td>${row.FactorStatus}</td>
                    <td>${row.Photographer}</td>
                    <td>${row.Designer}</td>
                    <td>${row.FactorDate}</td>
                    <td>${row.SumFactor}</td>
                    <td>${row.SumDiscount}</td>
                    <td>${row.FinanStatus}</td>
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
                 function () {
                    alert("خطا در دریافت داده‌ها");
                });
        }
    </script>
</asp:Content>
