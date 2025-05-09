<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="RequestStatus.aspx.cs" Inherits="AdakStudio.RequestStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">


    <style>
        .containerRequestStatus {
            display: flex;
            gap: 20px;
            overflow-x: auto;
            padding: 10px;
        }

        .invoice-card {
            border-radius: 8px;
            padding: 15px;
            margin: 10px;
            background-color: #fff; /* رنگ پس‌زمینه */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* شادو اولیه */
            transition: box-shadow 0.3s ease; /* انیمیشن تغییر شادو */
        }

        .column {
            background: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 250px;
            padding: 15px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
            position: relative;
        }

            .column h3 {
                font-size: 18px;
                color: #333;
                text-align: center;
                margin-bottom: 10px;
            }

        .dropzone_FS {
            border-radius: 5px;
            height: 40px;
            margin-top: 3px;
            margin-bottom: 3px;
            text-align: center;
            color: #bbb;
            transition: background-color 0.2s;
            overflow-y: auto;
        }


        /* .task {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 5px;
            margin-bottom: 10px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }*/
        .task {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 5px;
            margin-bottom: 15px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
            /* استایل فاکتورهای بدهکار */
            .task.unpaid {
                box-shadow: 0 4px 8px #dc994a; /* سایه قرمز ملایم */
                border: 2px solid #e2a309; /* حاشیه قرمز کم‌رنگ */
            }

            /* افکت هنگام هاور */
            /*.task.unpaid:hover {
            box-shadow: 0 6px 12px rgba(255, 0, 0, 0.4);*/ /* شادو قوی‌تر */
            /*transform: translateY(-2px);*/ /* حرکت جزئی به بالا */
            /*}*/

            .task:hover {
                transform: scale(1.03);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            }

        .task-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .customer-name {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        .date {
            font-size: 12px;
            color: #777;
        }

        .task-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .force-design-label {
            background: #ff9999;
            color: #fff;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }

        .edit-btn {
            background: #007bff;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            cursor: pointer;
        }

            .edit-btn:hover {
                background: #0056b3;
            }
    </style>
    <%-- واسه لاگ فاکتورهست --%>
    <style>
        .log-container {
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .log-header {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }

        .log-form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

            .log-form textarea {
                height: 60px;
                padding: 10px;
                resize: none;
                border: 1px solid #ddd;
                border-radius: 4px;
                margin-bottom: 10px;
            }

            .log-form button {
                align-self: flex-end;
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }

                .log-form button:hover {
                    background-color: #0056b3;
                }

        .log-list {
            list-style: none;
            padding: 0;
            margin: 0;
            max-height: 300px;
            overflow-y: auto;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }

        .log-item {
            border-bottom: 1px solid #ddd;
            padding: 10px 0;
            display: flex;
            flex-direction: column;
        }

            .log-item:last-child {
                border-bottom: none;
            }

            .log-item .log-details {
                font-size: 14px;
                color: #555;
            }

            .log-item .log-text {
                font-size: 16px;
                margin: 5px 0;
                color: #333;
            }


        .scroll-top {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 15px;
            overflow-x: scroll;
            overflow-y: hidden;
            background-color: #f0f0f0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex-column-auto flex-fill" style="padding: 1px">
        <div id="kt_content_container" style="padding: 1px">
            <div class="card" style="padding: 1px">
                <div class="card-body pt-0">
                    <div class="container mt-5 px-1" style="max-width: 1200px; margin-left: auto; margin-right: 0;">
                        <div class="row">
                            <div class="col-md-3">
                                <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                            </div>
                            <div class="col-md-2">
                                <input class="form-control datepicker" placeholder="از تاریخ" id="filter_From_Date">
                            </div>
                            <div class="col-md-2">
                                <input class="form-control datepicker" placeholder="تا تاریخ" id="filter_To_Date">
                            </div>
                            <div class="col-md-3">
                                <select id="filter_Causer">
                                    <%Response.Write(PublicMethod.GetAdmin_A_Monshi(true, "ثبت کننده فاکتور")); %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="filterBtn" onclick="GetFactors()" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="scroll-top" id="scrolltop" onscroll="syncScroll(this, 'div_FactorStaus')"></div>
                        <div class="containerRequestStatus" onscroll="syncScroll(this, 'scrolltop')" id="div_FactorStaus"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="m_DetailFactor">
        <div class="modal-dialog modal-fullscreen">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bolder" id="header_modalDetailFactor">جزئیات فاکتور</h2>
                    <div onclick="closeModalDetailFactor()" class="btn btn-icon btn-sm btn-active-icon-primary">
                        <span class="svg-icon svg-icon-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="black" />
                                <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="black" />
                            </svg>
                        </span>
                    </div>
                </div>
                <div class="row g-10" style="margin: 5px">
                    <div class="col-lg-6">
                        <label>توضیحات فاکتور:</label>
                        <textarea id="factorDesccc" placeholder="توضیحات خود را وارد کنید..."></textarea>
                        <div class="log-container">
                            <div class="log-header">تغییرات فاکتور</div>
                            <!-- فرم ثبت لاگ جدید -->
                            <div class="log-form">
                                <textarea id="logText" placeholder="توضیحات خود را وارد کنید..."></textarea>
                                <button onclick="addLog()">ثبت لاگ</button>
                            </div>
                            <!-- لیست لاگ‌ها -->
                            <ul class="log-list" id="logList">
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-6" style="margin: 5px">
                        <div class="item-table">
                            <table>
                                <thead>
                                    <tr>
                                        <th class="min-w-70px">هدیه</th>
                                        <th class="min-w-80px">عنوان کالا</th>
                                        <th class="min-w-50px">تعداد</th>
                                        <th class="min-w-50px">فی</th>
                                        <th class="min-w-120px">توضیحات</th>
                                        <th class="min-w-50px">تعداد عکس</th>
                                    </tr>
                                </thead>
                                <tbody id="itemTableBodyDetailFactor">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer flex-center">
                    <button class="btn btn-light me-3" onclick="closeModalDetailFactor()" id="cancelBtn_DetailFactor">بستن</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">
    <script>
        function syncScroll(source, targetId) {
            const target = document.getElementById(targetId);
            target.scrollLeft = source.scrollLeft;
        }
        let draggedTask = null;
        var fId = 0;
        var resultChangeStatus = false;

        function drag(ev) {
            draggedTask = ev.target;
            ev.dataTransfer.setData("text", ev.target.id);
        }

        function allowDrop(ev) {
            ev.preventDefault();
        }

        function drop(ev, columnId) {
            ev.preventDefault();
            // جلوگیری از افزودن به داخل آیتم‌های دیگر
            if (ev.target.classList.contains('task')) {
                return; // اگر هدف یک task است، کار نکن
            }

            var taskId = ev.dataTransfer.getData("text");
            var task = document.getElementById(taskId);
            // اگر dropzone باشد، آیتم را اضافه کن
            if (ev.target.classList.contains('dropzone_FS')) {
                var targetColumn = ev.target.parentNode.id;//آیدی ستون نوع فاکتور
                taskId = taskId.replace("task_", "");// آیدی فاکتور و وضعیت فاکتور فعلی
                var sourceColumnInfo = taskId.split('_');
                targetColumn = targetColumn.replace("column_", "");
                var targetColumnItems = targetColumn.split('_');
                var result = false;
                var factorId = "";
                var newColumnId = "";
                if (targetColumnItems.length > 1) {
                    newColumnId = targetColumnItems[0];
                    factorId = sourceColumnInfo[1];
                    ChangeFactorStatus(sourceColumnInfo[0], sourceColumnInfo[1], targetColumnItems[0], true, targetColumnItems[1]);
                }
                else {
                    newColumnId = targetColumn;
                    factorId = sourceColumnInfo[1];
                    ChangeFactorStatus(sourceColumnInfo[0], sourceColumnInfo[1], targetColumn, false, "");
                }
                if (resultChangeStatus == true) {
                    task.id = "task_" + newColumnId + "_" + factorId;
                    ev.target.appendChild(task);
                    $("#cnt_div_" + sourceColumnInfo[0]).text(parseInt($("#cnt_div_" + sourceColumnInfo[0]).text()) - 1);
                    $("#cnt_div_" + newColumnId).text(parseInt($("#cnt_div_" + newColumnId).text()) + 1);
                }
            }
        }
        function ChangeFactorStatus(sourceFS, factorId, DesFS, updateDesigner = false, designerId = "") {
            resultChangeStatus = false;
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/ChangeFactorStatus",
                data: JSON.stringify({
                    sourceFS: sourceFS, factorId: factorId, DesFS: DesFS, updateDesigner: updateDesigner, designerId: designerId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                        resultChangeStatus = false;
                    }
                    else {
                        resultChangeStatus = true;
                        //GetFactors();
                    }
                },
                error: function () {
                    resultChangeStatus = false;
                    alert("error");
                }
            });
        }
        function FactorDetail(factorId) {
            fId = factorId;
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/FactorInfo",
                data: JSON.stringify({
                    FactorId: fId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $("#header_modalDetailFactor").text("جزئیات فاکتور " + msg.d.FamilyTitle);
                    GetFactorDetail();
                    GetLogs();
                    $("#factorDesccc").val(msg.d.Desc);
                },
                error: function () {
                    alert("error");
                }
            });

        };
    </script>
    <%-- اسکریپت مربوط به لاگ فاکتور --%>
    <script>
        function addLog() {
            // دریافت مقدار توضیحات
            var logText = document.getElementById('logText').value;

            if (!logText) {
                alert('لطفاً توضیحات را وارد کنید.');
                return;
            }
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/AddFactorLog",
                data: JSON.stringify({
                    FactorId: fId, logtext: logText
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        GetLogs();
                        // پاک کردن فیلد توضیحات
                        document.getElementById('logText').value = '';

                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function GetLogs() {
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/FactorLogs",
                data: JSON.stringify({
                    FactorId: fId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        document.getElementById('logList').innerHTML = "";
                        document.getElementById('logList').innerHTML = msg.d.Message;
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function GetFactorDetail() {
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/FactorDetail",
                data: JSON.stringify({
                    FactorId: fId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        var tbody = document.getElementById("itemTableBodyDetailFactor");
                        tbody.innerHTML = "";
                        $("#header_modalDetailFactor").text("جزئیات فاکتور " + msg.d.FamilyTitle);
                        msg.d.Products.forEach((item, index) => {
                            const row = document.createElement("tr");
                            row.innerHTML = `
                                <td><input name="IsGift" class="form-check-input" type="checkbox" ${item.Gift ? "checked" : ""} disabled/></td>
                                <td>${item.GTitle}-${item.title}</td>
                                <td><input type="number" value="${item.quantity}" min="1" max="100" disabled></td>
                                <td><input type="text" value="${CurrencyFormatted(item.price)}" min="1" max="100000000" disabled></td>
                                <td><textarea onchange="updateNotes(${index}, this.value)" disabled>${item.notes}</textarea></td>
                                <td><input type="number" maxlength="110" value="${item.ShotCount}" disabled></td>
                            `;
                            tbody.appendChild(row);
                        });
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function DeliveredFactor(factorId, status) {
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/DeliveredFactor",
                data: JSON.stringify({
                    FactorId: factorId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        toastr.success("بستن فاکتور با موفقیت انجام شد", "موفق");
                        $("#task_" + status + "_" + factorId).remove();
                        $("#cnt_div_" + status).text(parseInt($("#cnt_div_" + status).text()) - 1);
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
    </script>
    <script>
        function closeModalDetailFactor() {
            $('#m_DetailFactor').modal('hide');
        };
        function GetFactors() {
            var searchText = $("#filterInput").val();
            var fromdate = $("#filter_From_Date").val();
            var todate = $("#filter_To_Date").val();
            var causer = $("#filter_Causer").val();
            $.ajax({
                type: "POST",
                url: "RequestStatus.aspx/GetFactors",
                data: JSON.stringify({
                    searchText: searchText, fromdate: fromdate, todate: todate, causer: causer
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        $("#div_FactorStaus").innerHTML = "";
                        $("#div_FactorStaus").children().remove();
                        var res = msg.d.Htmls;
                        for (var i = 0; i < res.length; i++) {
                            $("#div_FactorStaus").append(res[i].ColumnHtml);
                        }
                        document.querySelectorAll('.dropzone_FS').forEach(dropzone => {
                            dropzone.addEventListener('dragover', allowDrop);
                            dropzone.addEventListener('drop', ev => drop(ev, dropzone.parentNode.id));
                        });
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        };
        function GetInvoices() {
            var searchText = $("#filterInput").val();
            var fromdate = $("#filter_From_Date").val();
            var todate = $("#filter_To_Date").val();
            var causer = $("#filter_Causer").val();
            ajaxGet('/RequestTracking/GetInvoices', function (res) {
                if (!res.success) {//خطا داریم
                    ShowError(res.message);
                }
                else {
                    $("#div_FactorStaus").innerHTML = "";
                    $("#div_FactorStaus").children().remove();
                    var res = res.Htmls;
                    for (var i = 0; i < res.length; i++) {
                        $("#div_FactorStaus").append(res[i].ColumnHtml);
                    }
                    document.querySelectorAll('.dropzone_FS').forEach(dropzone => {
                        dropzone.addEventListener('dragover', allowDrop);
                        dropzone.addEventListener('drop', ev => drop(ev, dropzone.parentNode.id));
                    });
                }
            },
            function (err) {
                console.log(err);
            });
        };
        $(document).ready(function () {
            $("#itemTableBodyDetailFactor").attr("disabled", "disabled");
            $("#master_PageTitle").text("وضعیت فاکتورها");

            GetInvoices();
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




        function createFactorHtml(groupedFactors) {
            const container = document.getElementById('div_FactorStaus');
            container.innerHTML = ''; // پاک کردن محتوای قبلی

            groupedFactors.forEach(status => {
                const column = document.createElement('div');
                column.className = 'column';
                column.id = `column_${status.StatusId}`;

                const header = document.createElement('h3');
                header.innerHTML = `${status.Title} <span style="background-color: #08c5f7; color: white; padding:3px; border-radius: 5px;">${status.Factors.length}</span>`;
                column.appendChild(header);

                const dropzone = document.createElement('div');
                dropzone.className = 'dropzone_FS h-100';
                dropzone.id = `dz_${status.StatusId}`;
                column.appendChild(dropzone);

                status.Factors.forEach(factor => {
                    const task = document.createElement('div');
                    task.className = 'task';
                    task.id = `task_${status.StatusId}_${factor.FactorID}`;

                    const header = document.createElement('div');
                    header.className = 'task-header';
                    header.innerHTML = `
        <span class="customer-name">${factor.FamilyTitle}</span>
        <span class="date">${factor.FactorDate}</span>
      `;

                    const footer = document.createElement('div');
                    footer.className = 'task-footer';
                    footer.innerHTML = `
        ${factor.ForceDesign ? '<span class="force-design-label">طراحی فورس</span>' : ''}
        <button class="edit-btn" onclick="FactorDetail(${factor.FactorID})">جزئیات</button>
      `;

                    task.appendChild(header);
                    task.appendChild(footer);
                    dropzone.appendChild(task);
                });

                container.appendChild(column);
            });
            document.querySelectorAll('.dropzone_FS').forEach(dropzone => {
                dropzone.addEventListener('dragover', allowDrop);
                dropzone.addEventListener('drop', ev => drop(ev, dropzone.parentNode.id));
        }



    </script>
</asp:Content>
