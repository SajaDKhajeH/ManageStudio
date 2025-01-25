<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="SendSms.aspx.cs" Inherits="AdakStudio.SendSms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <style>
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .customers-section, .message-section {
            flex: 1;
            min-width: 200px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .customers-section {
            max-width: 500px;
        }

            .customers-section h2 {
                font-size: 18px;
                margin-bottom: 15px;
            }

        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

            .filters select,
            .filters input[type="date"] {
                padding: 5px 10px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                flex: 1;
                min-width: 120px;
            }

        .checkbox-filters {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

            .checkbox-filters label {
                font-size: 14px;
                color: #333;
                display: flex;
                align-items: center;
                gap: 5px;
            }

        .customer-list {
            max-height: 700px;
            overflow-y: auto;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

            table thead {
                background-color: #f5f5f5;
            }

            table th, table td {
                text-align: left;
                padding: 8px;
                border-bottom: 1px solid #eee;
            }

            table th {
                font-size: 14px;
                color: #555;
            }

            table td {
                font-size: 14px;
                color: #333;
            }

                table td:first-child {
                    width: 40px;
                    text-align: center;
                }

                table td:nth-child(2) {
                    width: 60%;
                }

        .message-section h2 {
            font-size: 18px;
            margin-bottom: 15px;
        }

        textarea {
            width: 100%;
            height: 200px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            color: #333;
            resize: none;
            margin-bottom: 5px;
        }

        .char-count {
            font-size: 12px;
            color: #555;
            text-align: right;
        }

        .keywords {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .keyword {
            background-color: #aaa;
            color: #fff;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit-btn {
            display: inline-block;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 15px;
        }
        /* Scrollbar Styling */
        .customer-list::-webkit-scrollbar {
            width: 8px;
        }

        .customer-list::-webkit-scrollbar-thumb {
            background-color: #ccc;
            border-radius: 4px;
        }

            .customer-list::-webkit-scrollbar-thumb:hover {
                background-color: #aaa;
            }
    </style>
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
    <div class="d-flex-column-auto flex-fill" style="padding: 1px">
        <div id="kt_content_container" style="padding: 1px">
            <div class="card" style="padding: 1px">
                <div class="card-body pt-0">
                    <div class="row mt-3">
                        <!-- Customers Section -->
                        <div class="customers-section">
                            <h2>لیست مشتریان</h2>
                            <div class="filters">
                                <label>فیلترها: </label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <input type="text" id="filter_From_Date" class="form-control datepicker" placeholder="از تاریخ ثبت" />
                                    </div>
                                    <div class="col-md-6">
                                        <input type="text" id="filter_To_Date" class="form-control datepicker" placeholder="تا تاریخ ثبت">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <select id="filter_Hospital">
                                            <%Response.Write(PublicMethod.GetHospitals()); %>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="d-flex flex-stack" style="margin: 3px">
                                            <label class="form-check form-switch form-check-custom form-check-solid">
                                                <input id="filter_BedFamily" class="form-check-input" type="checkbox" />
                                                <span class="form-check-label fw-bold text-dark">فقط خانواده بدهکار</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">1</span></span>
                                    </div>
                                    <div class="col-md-4">
                                        <span>تعداد انتخاب شده: <span id="countSelectd" class="fw-bold">0</span></span>
                                    </div>
                                    <div class="col-md-4">
                                        <button id="filterBtn" onclick="loadTableDataFamily()" class="btn btn-primary w-70">جستجو</button>
                                    </div>
                                </div>
                            </div>
                            <div class="customer-list">
                                <table class="table table-striped table-hover table-bordered">
                                    <thead class="table-primary">
                                        <tr>
                                            <th class="min-w-80px">
                                                <input type="checkbox" id="selectAll" onclick="selectAllCustomers(this)" /></th>
                                            <th class="min-w-200px">عنوان خانواده</th>
                                        </tr>
                                    </thead>
                                    <tbody id="FamilyList">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Message Section -->
                        <div class="message-section">
                            <h2>متن پیام</h2>
                            <textarea id="messageText" placeholder="متن پیام خود را وارد کنید..." oninput="updateCharCount()"></textarea>
                            <div class="char-count" id="charCount">0 کاراکتر</div>
                            <div class="keywords">
                                <div class="keyword" onclick="addKeyword('عنوان خانوادگی')">عنوان خانوادگی</div>
                                <div class="keyword" onclick="addKeyword('نام کامل پدر')">نام کامل پدر</div>
                                <div class="keyword" onclick="addKeyword('نام کامل مادر')">نام کامل مادر</div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="checkbox-filters col-md-4">
                                    <label>ارسال به: </label>
                                    <label>
                                        <input type="checkbox" id="sendToFather" />
                                        ارسال به پدر
                                    </label>
                                    <label>
                                        <input type="checkbox" id="sendToMother" />
                                        ارسال به مادر
                                    </label>
                                </div>
                                <div class="col-md-5">
                                <button class="submit-btn btn-primary" onclick="sendSMS()">ارسال پیام</button>
                                 </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">

    <script>
        var selectedFamily_SMS = 0;
        var totalRecordsSMS = 0;
        // اضافه کردن کلمه کلیدی به متن پیام
        function addKeyword(keyword) {
            const messageBox = document.getElementById("messageText");
            const cursorPosition = messageBox.selectionStart;
            const textBeforeCursor = messageBox.value.substring(0, cursorPosition);
            const textAfterCursor = messageBox.value.substring(cursorPosition);
            if (!messageBox.value.includes(keyword)) {
                messageBox.value = textBeforeCursor + `{{${keyword}}}` + textAfterCursor;
                messageBox.focus();
                messageBox.selectionEnd = cursorPosition + keyword.length + 4;
                updateCharCount();
            }
        }

        // بروزرسانی تعداد کاراکترهای متن پیام
        function updateCharCount() {
            const messageBox = document.getElementById("messageText");
            document.getElementById("charCount").innerText = `${messageBox.value.length} کاراکتر`;
        }

        // ارسال پیامک
        function sendSMS() {
            const sendToFather = document.getElementById("sendToFather").checked;
            const sendToMother = document.getElementById("sendToMother").checked;
            const message = document.getElementById("messageText").value;
            var checkboxes = document.querySelectorAll(".customer-checkbox");
            var selectedFamily = [];
            checkboxes.forEach(c => {
                if (c.checked) {
                    selectedFamily.push(parseInt(c.id.replace("ch_", "")));
                }
            });
            $.ajax({
                type: "POST",
                url: "SendSms.aspx/SendSMS",
                data: JSON.stringify({
                    sendToFather, sendToMother, message, selectedFamily
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {
                        ShowError(msg.d.Message);
                    }
                    else {
                        toastr.success("ثبت پیام در صف با موفقیت انجام شد", "موفق");
                        const checkboxes = document.querySelectorAll(".customer-checkbox");
                        checkboxes.forEach(cb => cb.checked = false);
                        selectedFamily_SMS = 0;
                        $("#countSelectd").text(selectedFamily_SMS);
                    }
                },
                error: function () {
                    alert("خطا در دریافت داده‌ها");
                }
            });
        }

        // انتخاب همه مشتریان
        function selectAllCustomers(checkbox) {
            const checkboxes = document.querySelectorAll(".customer-checkbox");
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
            if (checkbox.checked) {
                $("#countSelectd").text(totalRecordsSMS);
                selectedFamily_SMS = totalRecordsSMS;
            }
            else {
                $("#countSelectd").text("0");
                selectedFamily_SMS = 0;
            }
        }
        // انتخاب همه مشتریان
        function selectOneCustomer(checkbox) {
            if (checkbox.checked) {
                selectedFamily_SMS = selectedFamily_SMS + 1;
            }
            else {
                selectedFamily_SMS = selectedFamily_SMS - 1;
            }
            $("#countSelectd").text(selectedFamily_SMS);
        }

        function loadTableDataFamily() {
            var filter_From_Date = $("#filter_From_Date").val();
            var filter_To_Date = $("#filter_To_Date").val();
            var filter_hospital = $("#filter_Hospital").val();
            var filter_FamilyBed = $("#filter_BedFamily").prop("checked");
            $.ajax({
                type: "POST",
                url: "SendSms.aspx/ForGrid",
                data: JSON.stringify({
                    Fromdate: filter_From_Date, Todate: filter_To_Date, Hospital: filter_hospital, BedFamily: filter_FamilyBed
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    totalRecordsSMS = response.d.Data.recordsTotal;
                    const tbody = $("#FamilyList");

                    tbody.empty(); // پاک کردن داده‌های قدیمی
                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.Actions}</td>
                            <td>${row.FamilyTitle}</td>
                        </tr>
                    `);
                    });
                    $("#countAllTable").text(totalRecordsSMS);
                },
                error: function () {
                    alert("خطا در دریافت داده‌ها");
                }
            });
        }

        $(document).ready(function () {
            $("#master_PageTitle").text("ارسال پیامک");
            loadTableDataFamily();
            selectedFamily_SMS = 0;
            document.getElementById("messageText").value = "";
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
