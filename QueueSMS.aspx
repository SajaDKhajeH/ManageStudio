<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="QueueSMS.aspx.cs" Inherits="QueueSMS" %>

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
                                <button id="filterBtn" class="btn btn-primary w-100">جستجو</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <select id="filter_typeId">
                                    <%Response.Write(PublicMethod.GetSMSType()); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_OnlyQueued" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">پیامک های ارسال نشده</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                </div>
                            <div class="col-md-3">
                                <button onclick="DelSMS()" class="btn btn-danger w-100">حذف پیام های انتخاب شده</button>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-80px">
                                        <input type="checkbox" id="selectAll" onclick="selectAllSMS(this)" /></th>
                                    <th class="min-w-130px">عنوان خانواده</th>
                                    <th class="min-w-80px">شماره همراه</th>
                                    <th class="min-w-100px">متن</th>
                                    <th class="min-w-100px">زمان ثبت</th>
                                    <th class="min-w-80px">ثبت کننده</th>
                                    <th class="min-w-100px">وضعیت ارسال</th>
                                    <th class="min-w-100px">زمان ارسال</th>
                                    <th class="min-w-100px">نوع پیام</th>
                                </tr>
                            </thead>
                            <tbody id="dt_SMS">
                                <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-between align-items-center">
                            <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                            <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                            <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                            <span>
                                <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataSMS()">
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
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>
        let pageIndex = 1;
        let pageSize = 5;
        var totalRecordsSMSQueue = 0;
        var selectedSMSs = 0;
        function DelSMS() {
            const checkboxes = document.querySelectorAll(".customer-checkbox");
            var SMSIds = [];
            checkboxes.forEach(cb => {
                if (cb.checked) {
                    SMSIds.push(parseFloat(cb.id.replace("ch_", "")));
                }
            });

            if (SMSIds.length == 0) {
                ShowError("لطفا ابتدا پیامی رو انتخاب کنید");
                return;
            }
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "QueueSMS.aspx/DelSMS",
                    data: JSON.stringify({
                        SMSIds
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        if (msg.d.Result == false) {
                            ShowError(msg.d.Message);
                        }
                        else {
                            toastr.success("حذف با موفقیت انجام شد", "موفق");
                            loadTableDataSMS();
                        }
                    },
                    error: function () {
                        alert("خطا در دریافت داده‌ها");
                    }
                });
            }
        }
        // انتخاب همه پیام ها
        function selectAllSMS(checkbox) {
            const checkboxes = document.querySelectorAll(".customer-checkbox");
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
        }
        $("#nextPageBtn").click(function () {
            pageIndex++;
            loadTableDataSMS();
        });
        // صفحه قبل
        $("#prevPageBtn").click(function () {
            pageIndex--;
            loadTableDataSMS();
        });
        // اعمال فیلتر
        $("#filterBtn").click(function () {
            pageIndex = 1;
            loadTableDataSMS();
        });
        function loadTableDataSMS() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_Family = $("#filter_Family").val();
            var filter_typeId = $("#filter_typeId").val();
            var filter_Causer = $("#filter_Causer").val();
            var OnlyQueued = $("#filter_OnlyQueued").prop("checked");
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "QueueSMS.aspx/ForGrid",
                data: JSON.stringify({
                    page: pageIndex, perPage: pageSize, SearchText: searchText,
                    Fromdate: filter_From_Date, Todate: filter_To_Date, FamilyId: filter_Family,
                    CauserId: filter_Causer, OnlyQueued: OnlyQueued, TypeId: filter_typeId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    totalRecordsSMSQueue = response.d.Data.recordsTotal;
                    const tbody = $("#dt_SMS");
                    tbody.empty(); // پاک کردن داده‌های قدیمی

                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.Select}</td>
                            <td>${row.FamilyTitle}</td>
                            <td>${row.Mobile}</td>
                            <td>${row.Text}</td>
                            <td>${row.SendTime}</td>
                            <td>${row.CauserName}</td>
                            <td>${row.StatusSended}</td>
                            <td>${row.SendedTime}</td>
                            <td>${row.TypeTitle}</td>
                        </tr>
                    `);
                    });

                    // بروزرسانی صفحه فعلی
                    $("#pageIndex").text(pageIndex);
                    $("#countAllTable").text(totalRecordsSMSQueue);
                    // غیرفعال کردن دکمه‌های صفحه‌بندی در صورت نیاز
                    $("#prevPageBtn").prop("disabled", pageIndex === 1);
                    $("#nextPageBtn").prop("disabled", pageIndex * pageSize >= totalRecordsSMSQueue);
                },
                error: function () {
                    alert("خطا در دریافت داده‌ها");
                }
            });
        }
        $(document).ready(function () {
            $("#master_PageTitle").text("صف پیامک");
            $("#s_pageSize").val("5");
            loadTableDataSMS();
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

