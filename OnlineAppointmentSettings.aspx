<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="OnlineAppointmentSettings.aspx.cs" Inherits="OnlineAppointmentSettings" %>

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
                                <div class="col-md-5">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>

                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-3">
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2" onclick="ResetFeildsSetting()" data-bs-toggle="modal" data-bs-target="#kt_modal_AddEditOnlineTurnSetting">افزودن اطلاعات</button>
                                </div>
                            </div>
                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th class="min-w-120px">عنوان</th>
                                        <th class="min-w-110px">نوع عکاسی</th>
                                        <th class="min-w-90px">وضعیت</th>
                                        <th class="min-w-120px">بازه تاریخی</th>
                                        <th class="min-w-120px">بازه زمانی</th>
                                        <th class="min-w-110px">مبلغ بیعانه</th>
                                        <th class="min-w-80px">ظرفیت</th>
                                        <th class="min-w-130px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Settings">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>صفحه فعلی: <span id="currentPage" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableSettings()">
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
    <div class="modal fade" id="kt_modal_AddEditOnlineTurnSetting">
        <div class="modal-dialog mw-950px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bolder" id="OnlineTurnSettingHeader">افزون اطلاعات</h2>
                    <div onclick="closeModalOnlineTurnSetting()" class="btn btn-icon btn-sm btn-active-icon-primary">
                        <span class="svg-icon svg-icon-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="black" />
                                <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="black" />
                            </svg>
                        </span>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="scroll-y me-n7 pe-7">
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">عنوان</label>
                                <input type="text" id="ots_title" class="form-control form-control-solid" placeholder="" name="name" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">نوع عکاسی</label>
                                <select id="ots_turnType">
                                    <%Response.Write(PublicMethod.GetTypePhotographi());%>
                                </select>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">وضعیت نمایش</label>
                                <div class="d-flex flex-stack">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="ots_active" class="form-check-input" name="billing" type="checkbox" value="1" checked="checked" />
                                        <span class="form-check-label fw-bold text-muted" for="kt_modal_AddEditOnlineTurnSetting">وضعیت نمایش</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">مبلغ بیعانه</label>
                                <input type="text" onkeyup="TextFormatPrice(this)" id="ots_depositeamount" class="form-control form-control-solid" placeholder="مبلغ بیعانه" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">نمایش از تاریخ</label>
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="ots_fromdate" placeholder="از تاریخ">
                            </div>
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">نمایش تا تاریخ</label>
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="ots_todate" placeholder="تا تاریخ">
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">نمایش از ساعت</label>
                                <select id="ots_fromtime">
                                    <option value="06:00">06:00</option>
                                    <option value="07:00">07:00</option>
                                    <option value="08:00">08:00</option>
                                    <option value="09:00">09:00</option>
                                    <option value="10:00">10:00</option>
                                    <option value="11:00">11:00</option>
                                    <option value="12:00">12:00</option>
                                    <option value="13:00">13:00</option>
                                    <option value="14:00">14:00</option>
                                    <option value="15:00">15:00</option>
                                    <option value="16:00">16:00</option>
                                    <option value="17:00">17:00</option>
                                    <option value="18:00">18:00</option>
                                    <option value="19:00">19:00</option>
                                    <option value="20:00">20:00</option>
                                    <option value="21:00">21:00</option>
                                    <option value="22:00">22:00</option>
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">نمایش تا ساعت</label>
                                <select id="ots_totime">
                                    <option value="08:00">08:00</option>
                                    <option value="09:00">09:00</option>
                                    <option value="10:00">10:00</option>
                                    <option value="11:00">11:00</option>
                                    <option value="12:00">12:00</option>
                                    <option value="13:00">13:00</option>
                                    <option value="14:00">14:00</option>
                                    <option value="15:00">15:00</option>
                                    <option value="16:00">16:00</option>
                                    <option value="17:00">17:00</option>
                                    <option value="18:00">18:00</option>
                                    <option value="19:00">19:00</option>
                                    <option value="20:00">20:00</option>
                                    <option value="21:00">21:00</option>
                                    <option value="22:00">22:00</option>
                                    <option value="23:00">23:00</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">فاصله زمانی بین نوبت ها</label>
                                <select id="ots_TimeEachTurn">
                                    <option value="30">سی دقیقه</option>
                                    <option value="45">چهل و پنج دقیقه</option>
                                    <option value="60">یک ساعت</option>
                                    <option value="90">یک ساعت و سی دقیقه</option>
                                    <option value="120">دو ساعت</option>
                                    <option value="150">دو ساعت و سی دقیقه</option>
                                    <option value="180">سه ساعت</option>
                                    <option value="210">سه ساعت و سی دقیقه</option>
                                    <option value="240">چهار ساعت</option>
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label class="required fs-6 fw-bold mb-2">ظرفیت</label>
                                <select id="ots_capacity">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-12 fv-row">
                                <label class="fs-6 fw-bold mb-2">عکس لوکیشن</label>
                                <input type="file" class="form-control" id="ots_filepath" name="file-upload" accept="image/*">
                                <p id="file-info"></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 fv-row">
                                <label class="fs-6 fw-bold mb-2">توضیحات و قوانین عکاسی</label>
                                <textarea id="ots_desc" placeholder="توضیحات و قوانین عکاسی" rows="5" ></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer flex-center">
                    <button onclick="AddEdit()" class="btn btn-primary">ثبت اطلاعات</button>
                    <button id="btncancel" class="btn btn-light me-3">انصراف</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">
        var ots_Id = 0;
        function AddEdit() {
            var title = $("#ots_title").val();
            var turnType = $("#ots_turnType").val();
            var active = $("#ots_active").prop("checked");
            var depositeamount = $("#ots_depositeamount").val();
            depositeamount = depositeamount.replaceAll(",", "");
            var fromdate = $("#ots_fromdate").val();
            var todate = $("#ots_todate").val();
            var fromtime = $("#ots_fromtime").val();
            var totime = $("#ots_totime").val();
            var TimeEachTurn = $("#ots_TimeEachTurn").val();
            var capacity = $("#ots_capacity").val();
            var fileInput = $('#ots_filepath')[0];
            var filepath = fileInput.files.length === 0 ? null : fileInput.files[0];
            var desc = $("#ots_desc").val();
            alert(filepath);
            var fileName = filepath === null ? "" : filepath?.name;
            $.ajax({
                type: "POST",
                url: "OnlineAppointmentSettings.aspx/AddEdit",
                data: JSON.stringify({
                    ots_Id, title, turnType, active, depositeamount, fromdate, todate,
                    fromtime, totime, TimeEachTurn, capacity, desc
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        var formfiles = new FormData();
                        formfiles.append("file", filepath);
                        formfiles.append('createThumbnail', "0");
                        formfiles.append('fromProfile', "1");


                        toastr.success(msg.d.Message, "موفق");
                        closeModalOnlineTurnSetting();
                        loadTableSettings();
                    }
                },
                error: function () {
                    Swal.fire({
                        type: "error",
                        title: "خطا",
                        text: "خطا در ثبت اطلاعات",
                        confirmButtonText: "متوجه شدم"
                    });
                }
            });
        };
        $('#btncancel').click(function () {
            closeModalOnlineTurnSetting();
        });
        function closeModalOnlineTurnSetting() {
            $('#kt_modal_AddEditOnlineTurnSetting').modal('hide');
        };
        function ResetFeildsSetting() {
            $("#ots_title").val("");
            ots_Id = 0;
            $("#ots_active").prop("checked", true);
            $("#OnlineTurnSettingHeader").text("ثبت تنظیمات نوبت دهی ");
            $("#ots_depositeamount").val("0");
            $("#ots_fromdate").val("");
            $("#ots_todate").val("");
            $("#ots_fromtime").val("06:00");
            $("#ots_totime").val("06:00");
            $("#ots_TimeEachTurn").val("60");
            $("#ots_capacity").val("1");
            document.getElementById('ots_filepath').value = "";
            $("#ots_desc").val("");

        };
        function DeleteOnlineAppointmentSettings(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                $.ajax({
                    type: "POST",
                    url: "OnlineAppointmentSettings.aspx/DeleteOnlineAppointmentSettings",
                    data: "{id:" + id + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var result = res.d;
                        if (result.Result == false) {//خطا داریم
                            ShowError(result.Message);
                        }
                        else {
                            loadTableSettings();
                            toastr.success(result.Message, "موفق");
                        }

                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
        };
        function EditSettings(id) {
            ots_Id = id;
            $.ajax({
                type: "POST",
                url: "OnlineAppointmentSettings.aspx/EditSettings",
                data: "{id:" + id + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var result = res.d;
                    if (result.Result == false) {//خطا داریم
                        ShowError(result.Message);
                    }
                    else {
                        $("#ots_title").val(result.Title);
                        $("#ots_active").prop("checked", result.Active);
                        $("#OnlineTurnSettingHeader").text("ویرایش " + result.Title);
                        $("#ots_depositeamount").val(result.DepositeAmount);
                        $("#ots_fromdate").val(result.FromDate);
                        $("#ots_todate").val(result.ToDate);
                        $("#ots_fromtime").val(result.FromTime);
                        $("#ots_totime").val(result.ToTime);
                        $("#ots_TimeEachTurn").val(result.TimeEachTurn);
                        $("#ots_capacity").val(result.Capacity);
                        $("#ots_filepath").files = null;
                        $("#ots_desc").val(result.Desc);
                        $('#file-info').text('فایل فعلی: ' + result.FileName);
                    }
                },
                error: function () {
                    ShowError("خطا در دریافت اطلاعات");
                }
            });
        };
    </script>
    <%-- این قسمت مربوط به دیتاتیبل هست --%>
    <script type="text/javascript">
        let currentPage = 1;
        let pageSize = 5;
        var isFileChanged = false;
        $(document).ready(function () {
            $("#master_PageTitle").text("تنظیمات نوبت دهی آنلاین");
            $("#s_pageSize").val("5");
            loadTableSettings();
            ResetFeildsSetting();
            isFileChanged = false;
            $('#ots_filepath').on('change', function () {
                isFileChanged = true;
                var fileName = $(this)[0].files[0]?.name || 'فایلی انتخاب نشده است';
                alert(fileName);
                $('#file-info').text('فایل جدید: ' + fileName);
            });
        });
        // صفحه بعد
        $("#nextPageBtn").click(function () {
            currentPage++;
            loadTableSettings();
        });
        // صفحه قبل
        $("#prevPageBtn").click(function () {
            currentPage--;
            loadTableSettings();
        });

        // اعمال فیلتر
        $("#filterBtn").click(function () {
            currentPage = 1;
            loadTableSettings();
        });
        function loadTableSettings() {
            var searchText = $("#filterInput").val();
            pageSize = parseInt($("#s_pageSize").val());
            $.ajax({
                type: "POST",
                url: "OnlineAppointmentSettings.aspx/ForGrid",
                data: JSON.stringify({ page: currentPage, perPage: pageSize, searchText: searchText }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const data = response.d.Data.data;
                    var totalRecords = response.d.Data.recordsTotal;
                    const tbody = $("#dt_Settings");
                    tbody.empty(); // پاک کردن داده‌های قدیمی
                    // اضافه کردن داده‌های جدید
                    data.forEach(row => {
                        tbody.append(`
                     <tr>
                         <td>${row.Title}</td>
                         <td>${row.TurnType}</td>
                         <td>${row.Status}</td>
                         <td>${row.RangeDate}</td>
                         <td>${row.RangeTime}</td>
                         <td>${row.DepositeAmount}</td>
                         <td>${row.Capacity}</td>
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
                    ShowError("خطا در دریافت اطلاعات");
                }
            });
        }
    </script>
</asp:Content>

