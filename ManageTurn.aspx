<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="ManageTurn.aspx.cs" Inherits="ManageTurn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
    
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                                <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                             <div class="col-md-2">
                                <select id="filter_Causer">
                                    <%Response.Write(PublicMethod.GetAdmin_A_Monshi()); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_TypePhotographi">
                                    <%Response.Write(PublicMethod.GetTypePhotographi(true)); %>
                                </select>
                            </div>
                            
                        </div>
                    </div>
                    <div class="row mt-3">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-130px">عنوان خانواده</th>
                                    <th class="min-w-80px">موضوع</th>
                                    <th class="min-w-80px">تاریخ</th>
                                    <th class="min-w-80px">ساعت</th>
                                    <th class="min-w-80px">لوکیشن</th>
                                     <th class="min-w-120px">تاریخ و ساعت ثبت سیستم</th>
                                    <th class="min-w-100px">توضیحات</th>
                                </tr>
                            </thead>
                            <tbody id="dt_Turn">
                                <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-between align-items-center">
                            <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                            <span>صفحه فعلی: <span id="currentPage" class="fw-bold">1</span></span>
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
<asp:Content ID="Content3" ContentPlaceHolderID="End" Runat="Server">
    <script>
        let currentPage = 1;
        let pageSize = 5;
        
        
        // صفحه بعد
        $("#nextPageBtn").click(function () {
            currentPage++;
            loadTableDataFacotrs();
        });
        
        // صفحه قبل
        $("#prevPageBtn").click(function () {
            currentPage--;
            loadTableDataFacotrs();
        });

        // اعمال فیلتر
        $("#filterBtn").click(function () {
            currentPage = 1;
            loadTableDataFacotrs();
        });
        
        function loadTableDataFacotrs() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Family = $("#filter_Family").val();
            var filter_Causer = $("#filter_Causer").val();
            var filter_TypePhotographi = $("#filter_TypePhotographi").val();
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "ManageTurn.aspx/ForGrid",
                data: JSON.stringify({
                    page: currentPage, perPage: pageSize, fromDate: filter_From_Date, toDate: filter_To_Date, familyId: filter_Family, searchText: searchText,
                    causer: filter_Causer, typePhoto: filter_TypePhotographi
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    var totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Turn");

                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.FamilyTitle}</td>
                            <td>${row.TypeTitle}</td>
                            <td>${row.Date}</td>
                            <td>${row.Time}</td>
                            <td>${row.Location}</td>
                            <td>${row.CreationTime}</td>
                            <td>${row.Desc}</td>
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
        $(document).ready(function () {
            $("#master_PageTitle").text("مدیریت نوبت ها");
            $("#s_pageSize").val("10");
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
</asp:Content>

