<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="AdakStudio.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <style>
        .headercalendar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #007BFF;
            color: white;
            padding: 15px 20px;
        }

            .headercalendar button {
                background: white;
                color: #007BFF;
                border: none;
                border-radius: 5px;
                padding: 8px 15px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

        .header button:hover {
            background: #0056b3;
            color: white;
        }

        .days-row {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: #f9f9f9;
            border-bottom: 2px solid #ddd;
            text-align: center;
        }

        .day {
            padding: 10px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            border-right: 1px solid #ddd;
        }

            .day:last-child {
                border-right: none;
            }

            .day:hover {
                background: #007BFF;
                color: white;
            }

            .day.selected {
                background: #0056b3;
                color: white;
            }

        .schedule {
            display: grid;
            grid-template-columns: 100px 1fr;
            margin: 0;
        }

        .time-slot {
            padding: 10px;
            font-size: 14px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            background: #f8f8f8;
            cursor: pointer;
        }

            .time-slot:hover {
                background-color: #e0e0e0;
                border-color: #999;
            }

        .appointments {
            display: flex; /* نوبت‌ها کنار هم قرار می‌گیرند */
            flex-wrap: wrap; /* در صورت کمبود جا، به خط بعدی می‌روند */
            margin: 5px; /* فاصله میان نوبت‌ها */
        }

        .appointment {
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 5px 10px;
            font-size: 12px;
            cursor: pointer;
            transition: 0.2s;
            margin: 5px;
        }

            .appointment:hover {
                background-color: #e0e0e0;
                border-color: #999;
            }
    </style>
    <style>
        /* Tabs Container */
        .tabs-container {
            display: flex;
            justify-content: space-around;
            border-bottom: 2px solid #e5e5e5;
            margin-bottom: 15px;
        }

        .tab-button {
            flex: 1;
            text-align: center;
            background: transparent;
            color: #333;
            border: none;
            font-size: 14px;
            font-weight: 500;
            padding: 10px 0;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

            .tab-button:hover {
                color: #007BFF;
            }

            .tab-button.active {
                color: #007BFF;
                font-weight: 600;
            }

                .tab-button.active::after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 50%;
                    height: 2px;
                    background: #007BFF;
                    border-radius: 5px;
                }

        /* Tabs Content */
        .tabs-content {
            padding: 20px;
            border-radius: 8px;
            background: #f9f9f9;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
        }

        .tab-content {
            display: none;
        }

            .tab-content.active {
                display: block;
            }

        .label-tips {
            display: flex;
            justify-content: flex-start; /* برای قرار دادن محتوا در سمت راست */
            margin: 10px; /* حاشیه برای فاصله از لبه */
            color: red;
            font-size: 16px
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <button class='btnDataTable btnDataTable-print' style="display:none" id="btnOpenSetPay" data-bs-toggle='modal' data-bs-target='#m_SetPaidPrice' title='پرداخت' disabled>💰</button>
    <div class="d-flex-column-auto flex-fill"">
    <div id="kt_content_container" >
        <div class="card">
            <!-- Tabs Header -->
            <div class="tabs-container">
                <button class="tab-button active" data-tab="calendarTab">تقویم</button>
                <button class="tab-button" data-tab="monthlyTab">رویدادها(10 روز آینده)</button>
                <button class="tab-button" data-tab="followupsTab">پیگیری ها(5 روز آینده)</button>
            </div>

            <!-- Tabs Content -->
            <div class="tabs-content">
                <!-- Calendar Tab -->
                <div class="tab-content active" id="calendarTab">
                    <label class="label-tips">برای دریافت نوبت روی تایم بزنید</label>
                    <label class="label-tips">برای ویرایش نوبت رزرو شده بروی نوبت دوبارکلیک کنید</label>
                    <div class="calendar-container">
                        <!-- Header -->
                        <div class="headercalendar">
                            <button id="prevWeek">هفته قبل</button>
                            <div id="currentWeek">12 تا 18 آذر</div>
                            <button id="nextWeek">هفته بعد</button>
                        </div>
                        <!-- Days Row -->
                        <div class="days-row" id="daysRow"></div>
                        <!-- Schedule -->
                        <div class="schedule" id="schedule"></div>
                    </div>
                </div>

                <!-- Monthly Tab -->
                <div class="tab-content" id="monthlyTab">
                    <table class="table table-striped table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="min-w-50px">ردیف</th>
                                    <th class="min-w-130px">عنوان خانواده</th>
                                    <th class="min-w-100px">نام فرزند</th>
                                    <th class="min-w-100px">نام پدر</th>
                                    <th class="min-w-100px">نام مادر</th>
                                    <th class="min-w-100px">تاریخ تولد</th>
                                    <th class="min-w-100px">شماره مادر</th>
                                    <th class="min-w-100px">شماره پدر</th>
                                    <th class="min-w-100px">وضعیت</th>
                                </tr>
                            </thead>
                            <tbody id="dt_lunar">
                                <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                            </tbody>
                        </table>
                </div>

                <!-- Followups Tab -->
                <div class="tab-content" id="followupsTab">
                  <span style="color:red">این قسمت در دست طراحی هست</span>
                </div>
            </div>
        </div>
    </div>
</div>
  <%--  <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="calendar-container">
                    <!-- Header -->
                    <div class="headercalendar">
                        <button id="prevWeek">هفته قبل</button>
                        <div id="currentWeek">12 تا 18 آذر</div>
                        <button id="nextWeek">هفته بعد</button>
                    </div>

                    <!-- Days Row -->
                    <div class="days-row" id="daysRow">
                        <!-- روزهای هفته به صورت داینامیک اضافه می‌شوند -->
                    </div>

                    <!-- Schedule -->
                    <div class="schedule" id="schedule">
                        <!-- زمان‌بندی‌ها و نوبت‌ها به صورت داینامیک اضافه می‌شوند -->
                    </div>
                </div>
            </div>
        </div>
    </div>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">
    <script>
        const daysRow = document.getElementById('daysRow');
        const schedule = document.getElementById('schedule');
        const currentWeek = document.getElementById('currentWeek');

        const daysOfWeek = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];
        var currentIndex = 0;
        let currentDate = new Date(); // تاریخ جاری
        let selectedDate = new Date();
        // تبدیل تاریخ میلادی به شمسی
        const toJalaliDate = (date) => {
            const formatter = new Intl.DateTimeFormat('fa-IR', { dateStyle: 'short' });
            return formatter.format(date);
        };

        // گرفتن تاریخ شمسی آغاز هفته (شنبه)
        const getStartOfWeek = (date) => {
            const dayOfWeek = date.getDay();
            const diff = dayOfWeek === 6 ? 0 : dayOfWeek + 1; // محاسبه فاصله تا شنبه
            const startOfWeek = new Date(date);
            startOfWeek.setDate(startOfWeek.getDate() - diff);
            return startOfWeek;
        };

        // گرفتن آرایه‌ای از تاریخ‌های هفته جاری
        const getWeekDates = (startOfWeek) => {
            const dates = [];
            for (let i = 0; i < 7; i++) {
                const day = new Date(startOfWeek);
                day.setDate(startOfWeek.getDate() + i);
                dates.push(day);
            }
            return dates;
        };

        // به‌روزرسانی روزهای هفته در سطر بالا
        const updateDaysRow = () => {
            daysRow.innerHTML = '';
            const startOfWeek = getStartOfWeek(currentDate);
            const weekDates = getWeekDates(startOfWeek);
            selectedDate = currentDate;
            weekDates.forEach((date, index) => {
                const dayDiv = document.createElement('div');
                dayDiv.className = 'day';
                var dateweek = getPersianMonthAndDay(toJalaliDate(date), '/');
                dayDiv.textContent = `${daysOfWeek[index]} - ${dateweek}`;
                dayDiv.onclick = () => {
                    document.querySelectorAll('.day').forEach(el => el.classList.remove('selected'));
                    dayDiv.classList.add('selected');
                    selectedDate = date;
                    loadAppointments(index);
                };
                if (toJalaliDate(date) == toJalaliDate(currentDate)) {
                    dayDiv.classList.add('selected'); // روز اول پیش‌فرض انتخاب می‌شود
                    currentIndex = index;
                    selectedDate = date;
                }
                daysRow.appendChild(dayDiv);
            });
        };
        // گرفتن نوبت‌ها برای روز خاص
        const getAppointmentsForDay = (dayIndex) => {
            var sampleAppointments = [
                { hour: 0, time: '', title: '', RequestId: 0, Date: "", TurnId: "", TurnTitle: "", Desc: "", BaseFamilyTitle: "", Cost: 0, Duration: 0, LocationId: "", LocationTitle: "", ModPrice: 0, DurationText: "" }
            ];
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetTurns_By_Date",
                data: JSON.stringify({
                    date: selectedDate
                }),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    sampleAppointments = msg.d;
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                    sampleAppointments = [];
                }
            });
            return sampleAppointments;
        };
        // بارگذاری نوبت‌ها در پایین تقویم
        const loadAppointments = (dayIndex) => {
            schedule.innerHTML = '';
            var appointments = getAppointmentsForDay(dayIndex);
            let beforTime = "00:00";
            var locationTitle = "";
            var DurationText = "";
            for (let hour = 8; hour < 23; hour++) {
                for (let minutes = 0; minutes < 60; minutes += 30) {
                    var min = minutes == 0 ? "00" : minutes.toString();
                    var h = hour < 10 ? ("0" + hour.toString()) : hour.toString();
                    let time = `${h}:${min}`;
                    var timeSlot = document.createElement('div');
                    timeSlot.className = 'time-slot';
                    timeSlot.textContent = time;
                    timeSlot.onclick = () => {
                        document.getElementById("btnEditRequestModal").click();
                        openModalRequest(0, time, toJalaliDate(selectedDate), "", "", 0, 0, "");
                    };

                    var appointmentsCell = document.createElement('div');
                    appointmentsCell.className = 'appointments';
                    var matchedAppointments = appointments.filter(a => a.time > beforTime && a.time <= time);
                    matchedAppointments.forEach(app => {
                        //دیو برای ویرایش نوبت
                        const appointmentDiv = document.createElement('div');
                        appointmentDiv.className = 'appointment';
                        locationTitle = app.LocationTitle == null || app.LocationTitle == undefined ? "" : " " + app.LocationTitle;
                        if (app.Duration > 0) {
                            DurationText = " مدت زمان:" + app.DurationText;
                        }
                        appointmentDiv.innerHTML = `${app.title} - ساعت: ${app.time} - ${app.TurnTitle} - ${app.Desc} ${locationTitle} ${DurationText}`;
                        appointmentDiv.ondblclick = () => updateTurn(app.RequestId, app.time, app.Date, app.BaseFamilyTitle, app.TurnId, app.Desc, app.Cost, app.Duration, app.LocationId);
                        appointmentsCell.appendChild(appointmentDiv);
                        //افزودن یک باتن برای حذف نوبت
                        const appointmentBtnDel = document.createElement('button');
                        appointmentBtnDel.className = 'btnDataTable btnDataTable-delete';
                        appointmentBtnDel.textContent = `🗑`;
                        appointmentBtnDel.onclick = () => RequestDelete(app.RequestId);
                        appointmentsCell.appendChild(appointmentBtnDel);
                        if (app.ModPrice > 0) {
                            //افزودن یک باتن برای حذف نوبت
                            const appointmentBtnPay = document.createElement('button');
                            appointmentBtnPay.className = 'btnDataTable btnDataTable-print';
                            appointmentBtnPay.textContent = `💰`;
                            appointmentBtnPay.id = "btnPayTurn" + app.RequestId;
                            appointmentBtnPay.setAttribute('data-bs-toggle', 'modal');
                            appointmentBtnPay.setAttribute('data-bs-target', '#m_SetPaidPrice');
                            appointmentBtnPay.onclick = () => PayFactor_Or_Turn(app.RequestId, app.ModPrice, 2, ("پرداخت هزینه نوبت " + app.BaseFamilyTitle));
                            appointmentsCell.appendChild(appointmentBtnPay);
                        }
                    });
                    beforTime = time;
                    schedule.appendChild(timeSlot);
                    schedule.appendChild(appointmentsCell);
                }
            }

            //دیو بدون ساعت واسه اونهایی که تایم شون مشخص نیست
            var timeSlotRezerv = document.createElement('div');
            timeSlotRezerv.className = 'time-slot';
            timeSlotRezerv.textContent = "رزروی ها";
            timeSlotRezerv.onclick = () => {
                document.getElementById("btnEditRequestModal").click();
                openModalRequest(0, "", toJalaliDate(selectedDate), "", "", 0, 0, "");
            };

            var appointmentsCellRezerv = document.createElement('div');
            appointmentsCellRezerv.className = 'appointments';
            var matchedAppointmentsRezerv = appointments.filter(a => a.time == null || a.time == "" || a.time == "00:00");
            matchedAppointmentsRezerv.forEach(app => {
                //دیو برای ویرایش نوبت
                const appointmentDiv = document.createElement('div');
                appointmentDiv.className = 'appointment';
                locationTitle = app.LocationTitle == null || app.LocationTitle == undefined ? "" : " " + app.LocationTitle;
                if (app.Duration > 0) {
                    DurationText = " مدت زمان:" + app.DurationText;
                }
                appointmentDiv.innerHTML = `${app.title} - ${app.TurnTitle} - ${app.Desc} ${locationTitle} ${DurationText}`;
                appointmentDiv.ondblclick = () => updateTurn(app.RequestId, "", app.Date, app.BaseFamilyTitle, app.TurnId, app.Desc, app.Cost, app.Duration, app.LocationId);
                appointmentsCellRezerv.appendChild(appointmentDiv);
                //افزودن یک باتن برای حذف نوبت
                const appointmentBtnDel = document.createElement('button');
                appointmentBtnDel.className = 'btnDataTable btnDataTable-delete';
                appointmentBtnDel.textContent = `🗑`;
                appointmentBtnDel.onclick = () => RequestDelete(app.RequestId);
                appointmentsCellRezerv.appendChild(appointmentBtnDel);
                if (app.ModPrice > 0) {
                    //افزودن یک باتن برای حذف نوبت
                    const appointmentBtnPay = document.createElement('button');
                    appointmentBtnPay.className = 'btnDataTable btnDataTable-print';
                    appointmentBtnPay.textContent = `💰`;
                    appointmentBtnPay.setAttribute('data-bs-toggle', 'modal');
                    appointmentBtnPay.setAttribute('data-bs-target', '#m_SetPaidPrice');
                    appointmentBtnPay.onclick = () => PayFactor_Or_Turn(app.RequestId, app.ModPrice, 2, ("پرداخت هزینه نوبت " + app.BaseFamilyTitle));
                    appointmentsCellRezerv.appendChild(appointmentBtnPay);
                }
            });
            schedule.appendChild(timeSlotRezerv);
            schedule.appendChild(appointmentsCellRezerv);
        };
        // به‌روزرسانی هفته جاری
        const updateWeek = (offset) => {
            currentDate.setDate(currentDate.getDate() + (offset * 7));
            const startOfWeek = getStartOfWeek(currentDate);
            const endOfWeek = new Date(startOfWeek);
            endOfWeek.setDate(startOfWeek.getDate() + 6);
            var sdate = toJalaliDate(startOfWeek);
            var tdate = toJalaliDate(endOfWeek);
            currentWeek.textContent = `${getPersianMonthAndDay(sdate, '/')} تا ${getPersianMonthAndDay(tdate, '/')}`;
            updateDaysRow();
            //selectedDate = startOfWeek;
            loadAppointments(currentIndex);
        };
        // دکمه‌های هفته قبل و بعد
        document.getElementById('prevWeek').onclick = () => updateWeek(-1);
        document.getElementById('nextWeek').onclick = () => updateWeek(1);

        function updateTurn(requestId, time, date, title, turnid, desc, cost, duration, locationId) {
            document.getElementById("btnEditRequestModal").click();
            openModalRequest(requestId, time, date, turnid, desc, cost, duration, locationId);
            document.getElementById("div_Family_For_Request").style.display = "none";
            document.getElementById("header_modalSetRequest").textContent = "اصلاح نوبت خانواده " + title;
        };
        // مقداردهی اولیه
        updateWeek(0);
    </script>
    <script>
        var load_monthlyTab = false;
        function LunarCalendar() {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/LunarCalendar",
                data: JSON.stringify({

                }),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    load_monthlyTab = true;
                    const data = response.d.Data.data;
                    const tbody = $("#dt_lunar");
                    tbody.empty(); // پاک کردن داده‌های قدیمی
                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                        <tr>
                            <td>${row.Row}</td>
                            <td>${row.FamilyTitle}</td>
                            <td>${row.ChildName}</td>
                            <td>${row.FatherFullName}</td>
                            <td>${row.MotherFullName}</td>
                            <td>${row.BirthDate}</td>
                            <td>${row.MotherMobile}</td>
                            <td>${row.FatherMobile}</td>
                            <td>${row.Desc}</td>
                        </tr>
                    `);
                    });
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                }
            });
        }
        document.querySelectorAll(".tab-button").forEach(button => {
            button.addEventListener("click", () => {
                // حذف کلاس active از همه تب‌ها و محتوای تب‌ها
                document.querySelectorAll(".tab-button").forEach(btn => btn.classList.remove("active"));
                document.querySelectorAll(".tab-content").forEach(content => content.classList.remove("active"));

                // افزودن کلاس active به تب کلیک شده و محتوای مرتبط
                const tabId = button.getAttribute("data-tab");
                button.classList.add("active");
                document.getElementById(tabId).classList.add("active");
                if (tabId == "monthlyTab" && !load_monthlyTab) {
                    LunarCalendar();
                }
            });
        });
    </script>
</asp:Content>
