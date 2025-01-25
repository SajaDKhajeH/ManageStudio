<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Family.aspx.cs" Inherits="AdakStudio.Family" %>

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
    <div class="d-flex-column-auto flex-fill" id="kt_post">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container mt-5">
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                            </div>
                            <div class="col-md-3">
                                <input class="form-control datepicker" placeholder="از تاریخ" id="filter_From_Date">
                            </div>
                            <div class="col-md-3">
                                <input class="form-control datepicker" placeholder="تا تاریخ" id="filter_To_Date">
                            </div>
                            <div class="col-md-2">
                                <button id="filterBtn" class="btn btn-primary w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_Archive" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">فقط افراد غیرفعال</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select id="filter_Causer">
                                    <%Response.Write(PublicMethod.GetAdmin_A_Monshi_PhotographerHospital()); %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select id="filter_Hospital">
                                    <%Response.Write(PublicMethod.GetHospitals()); %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-130px">عنوان</th>
                                    <th class="min-w-130px">نام کامل خانم</th>
                                    <th class="min-w-130px">نام کامل آقا</th>
                                    <th class="min-w-100px">شماره همراه خانم</th>
                                    <th class="min-w-100px">شماره همراه آقا</th>
                                    <th class="min-w-100px">ثبت کننده</th>
                                    <th class="min-w-100px">زمان ثبت</th>
                                    <th class="min-w-70px">وضعیت</th>
                                    <th class="min-w-150px">توضیحات</th>
                                    <th class="min-w-110px">عملیات</th>
                                </tr>
                            </thead>
                            <tbody id="dt_Family">
                                <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-between align-items-center">
                            <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                            <span>صفحه فعلی: <span id="currentPage" class="fw-bold">1</span></span>
                            <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                            <span>
                                <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataFamily()">
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
    <script type="text/javascript">

        function FamilyDelete(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "Family.aspx/FamilyDelete",
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
                            loadTableDataFamily();
                            GetCustomer_ForCombo();
                        }
                    },
                    error: function () {
                        toastr.error("خطا", "خطا");
                    }
                });
            }
        };

        $(document).ready(function () {
            $("#master_PageTitle").text("خانواده ها");
            $("#s_pageSize").val("5");
            loadTableDataFamily();
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
                currentPage++;
                loadTableDataFamily();
            });

            // صفحه قبل
            $("#prevPageBtn").click(function () {
                currentPage--;
                loadTableDataFamily();
            });

            // اعمال فیلتر
            $("#filterBtn").click(function () {
                currentPage = 1;
                loadTableDataFamily();
            });
        });
    </script>
    <script>
        let currentPage = 1;
        let pageSize = 5;

        function loadTableDataFamily() {
            var filter = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var Only_Archive = $("#filter_Archive").prop("checked");
            var Causer = $("#filter_Causer").val();
            var Hospital = $("#filter_Hospital").val();

            $.ajax({
                type: "POST",
                url: "Family.aspx/ForGrid",
                data: JSON.stringify({ page: currentPage, perPage: pageSize, searchText: filter, fromDate: filter_From_Date, todate: filter_To_Date, Only_Archive: Only_Archive, CauserId: Causer, HospitalId: Hospital }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    const totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Family");

                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.Title}</td>
                            <td>${row.MotherFullName}</td>
                            <td>${row.FatherFullName}</td>
                            <td>${row.MotherMobile}</td>
                            <td>${row.FatherMobile}</td>
                            <td>${row.CauserName}</td>
                            <td>${row.Date_A_Time}</td>
                            <td>${row.Status}</td>
                            <td>${row.Desc}</td>
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
                    toastr.error("خطا در دریافت داده‌ها", "خطا");
                }
            });
        }
    </script>
</asp:Content>
