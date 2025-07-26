<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="AddEditProject.aspx.cs" Inherits="AddEditProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="d-flex-column-auto flex-fill">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">تعریف پروژه</h3>
                </div>
                <div class="card-body">
                    <form id="projectForm">
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <label class="form-label required">خانواده</label>
                                <select id="familySelect" class="form-select" required>
                                    <!-- آپشن‌های خانواده -->
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label required">نوع پروژه</label>
                                <select id="projectTypeSelect" onchange="projectTypeSelectChanged();" class="form-select" required>
                                    <!-- آپشن‌ها: بارداری، نوزاد، رشد، عروسی etc. -->
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <div class="form-check">
                                    <input id="urgentCheckbox" type="checkbox" class="form-check-input" />
                                    <label class="form-check-label">پروژه به صورت فورس تحویل  داده شود؟</label>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label required">عنوان پروژه</label>
                                <input id="projectTitle" type="text" class="form-control" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label required">تاریخ شروع</label>
                                <%--<input id="startDate" type="date" class="form-control" required />--%>
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="startDate" placeholder="تاریخ شروع" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label required">تاریخ پایان</label>
                                <%--<input id="endDate" type="date" class="form-control" required />--%>
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="endDate" placeholder="تاریخ پایان" required>
                            </div>
                        </div>
                        <div id="failureReasonSection" class="mb-4" style="display: none">
                            <label class="form-label required">دلیل عدم موفقیت</label>
                            <textarea id="failureReason" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" id="btn-submit-project" onclick="btnSubmitClicked();" class="btn btn-primary">ثبت پروژه</button>
                        </div>
                    </form>
                    <ul class="nav nav-tabs mt-4" id="projectTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" onclick="showCheckList();" data-bs-toggle="tab" href="#tab-checklist">📋 چک‌لیست <span class="badge bg-secondary ms-1" id="count-checklist">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-photos">📷 عکس‌ ها <span class="badge bg-secondary ms-1" id="count-photos">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-videos">🎥 فیلم‌ها <span class="badge bg-secondary ms-1" id="count-videos">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-locations">📍 لوکیشن ‌ها <span class="badge bg-secondary ms-1" id="count-locations">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-notes">📝 نوبت ‌ها <span class="badge bg-secondary ms-1" id="count-notes">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-materials">🔌 تجهیزات <span class="badge bg-secondary ms-1" id="count-materials">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-invoices">🧾 فاکتورها <span class="badge bg-secondary ms-1" id="count-invoices">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-payments">💵 پرداختی ‌ها <span class="badge bg-secondary ms-1" id="count-payments">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-sms">✉️ پیامک ‌ها <span class="badge bg-secondary ms-1" id="count-sms">0</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-logs">📄 لاگ‌ ها <span class="badge bg-secondary ms-1" id="count-logs">0</span>
                            </a>
                        </li>
                    </ul>
                    <!-- محتوای تب‌ها -->
                    <div class="tab-content p-3 border border-top-0">
                        <!-- تب عکس‌ها -->
                        <div class="tab-pane fade" id="tab-photos">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لیست عکس‌ها</h5>
                                <button class="btn btn-primary" onclick="btnOpenModalPhotoClicked()" data-bs-toggle="modal" data-bs-target="#modalAddPhoto">➕ افزودن عکس</button>
                            </div>

                            <!-- 🔽 فیلترها و آدرس عکس‌ها -->
                            <div class="row mb-3">
                                <!-- انتخاب طراح -->
                                <div class="col-md-4">
                                    <label for="cmb-designer" class="form-label">انتخاب طراح:</label>
                                    <select id="cmb-designer" class="form-select">
                                        <option value="">انتخاب طراح</option>
                                        <option value="علی رضایی">علی رضایی</option>
                                        <option value="سارا احمدی">سارا احمدی</option>
                                        <option value="محمد کرمی">محمد کرمی</option>
                                    </select>
                                </div>

                                <!-- ورودی آدرس عکس -->
                                <div class="col-md-8">
                                    <label for="photoBaseDir" class="form-label">آدرس اصلی عکس‌ها:</label>
                                    <input type="text" id="photoBaseDir" class="form-control" placeholder="مثلاً: /uploads/photos/">
                                </div>
                            </div>

                            <!-- 🔽 جدول عکس‌ها -->
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>کد</th>
                                        <th>توضیح کوتاه</th>
                                        <th>عکاس</th>
                                        <th>طراح</th>
                                        <th>ثبت‌کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>وضعیت</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="table-photos">
                                </tbody>
                            </table>
                        </div>

                        <!-- تب فیلم‌ها -->
                        <div class="tab-pane fade" id="tab-videos">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لیست فیلم ‌ها</h5>
                                <button class="btn btn-primary" onclick="btnOpenModalVideoClicked()" data-bs-toggle="modal" data-bs-target="#modalAddVideo">➕ افزودن فیلم</button>
                            </div>

                            <div class="row mb-3">
                                <!-- انتخاب تدوینگر -->
                                <div class="col-md-4">
                                    <label for="cmb-editor" class="form-label">انتخاب تدوینگر:</label>
                                    <select id="cmb-editor" class="form-select">
                                    </select>
                                </div>

                                <!-- ورودی آدرس عکس -->
                                <div class="col-md-8">
                                    <label for="videoBaseDir" class="form-label">آدرس اصلی فیلم‌ها:</label>
                                    <input type="text" id="videoBaseDir" class="form-control" placeholder="مثلاً: /uploads/videos/">
                                </div>
                            </div>

                            <!-- 🔽 جدول فیلم‌ها -->
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>کد</th>
                                        <th>توضیح کوتاه</th>
                                        <th>فیلم بردار</th>
                                        <th>تدوینگر</th>
                                        <th>ثبت‌کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>وضعیت</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="table-videos">
                                </tbody>
                            </table>
                        </div>

                        <!-- تب چک‌لیست -->
                        <div class="tab-pane fade show active" id="tab-checklist">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">چک‌لیست پروژه</h5>
                            </div>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>عنوان</th>
                                        <th>وضعیت</th>
                                        <th>ثبت کننده</th>
                                        <th>تاریخ و ساعت انجام</th>
                                        <%--                                        <th>عملیات</th>--%>
                                    </tr>
                                </thead>
                                <tbody id="checklist-items">
                                    <tr data-status="done">
                                        <td>دوربین بررسی شد</td>
                                        <td class="status-text">✅ انجام شد</td>
                                        <td>احمد</td>
                                        <td>1403/01/10</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب لوکیشن‌ها -->
                        <div class="tab-pane fade" id="tab-locations">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لوکیشن‌ها</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" onclick="btnOpenModalLocationClicked()" data-bs-target="#modalAddLocation">➕ افزودن لوکیشن</button>
                            </div>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>نام لوکیشن</th>
                                        <th>هزینه لوکیشن</th>
                                        <th>توضیحات</th>
                                        <th>ثبت‌کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="table-locations">
                                </tbody>
                            </table>
                        </div>

                        <!-- تب نوبت‌ها -->
                        <div class="tab-pane fade" id="tab-notes">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">نوبت ‌ها</h5>
                            </div>
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>تاریخ</th>
                                        <th>ساعت</th>
                                        <th>ثبت‌کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>وضعیت</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="table-schedule">
                                </tbody>
                            </table>
                        </div>

                        <!-- تب تجهیزات -->
                        <div class="tab-pane fade" id="tab-materials">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">تجهیزات</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" onclick="btnOpenModalMaterialClicked()" data-bs-target="#modalAddMaterial">➕ افزودن تجهیزات</button>
                            </div>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>نام تجهیزات</th>
                                        <th>هزینه</th>
                                        <th>توضیحات</th>
                                        <th>ثبت‌کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="table-materials">
                                </tbody>
                            </table>
                        </div>

                        <!-- تب فاکتورها -->
                        <div class="tab-pane fade" id="tab-invoices">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">فاکتورها</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddInvoice">➕ افزودن فاکتور</button>
                            </div>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>تاریخ</th>
                                        <th>کد</th>
                                        <th>مجموع فاکتور</th>
                                        <th>مالیات</th>
                                        <th>تخفیف</th>
                                        <th>ثبت کننده</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>عملیات</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1403/02/01</td>
                                        <td>F-001</td>
                                        <td>2,500,000</td>
                                        <td>250,000</td>
                                        <td>500,000</td>
                                        <td>سجاد قلی</td>
                                        <td>1403/01/01 - 14:30</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب پرداختی‌ها -->
                        <div class="tab-pane fade" id="tab-payments">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">پرداختی‌ها</h5>
                            </div>
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>مبلغ پرداختی</th>
                                        <th>بانک</th>
                                        <th>طریقه پرداخت</th>
                                        <th>شماره پیگیری</th>
                                        <th>تاریخ و ساعت ثبت</th>
                                        <th>ثبت کننده</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1,000,000</td>
                                        <td>ملت</td>
                                        <td>کارت به کارت</td>
                                        <td>123456789</td>
                                        <td>1403/02/05 - 13:40</td>
                                        <td>سجاد خوجه</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب پیامک‌ها -->
                        <div class="tab-pane fade" id="tab-sms">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">پیامک‌ها</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddSms">➕ ارسال پیامک</button>
                            </div>
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>متن</th>
                                        <th>تاریخ - ساعت ثبت</th>
                                        <th>ثبت کننده</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <button
                                                class="btn btn-link p-0"
                                                type="button"
                                                data-bs-toggle="popover"
                                                data-bs-placement="top"
                                                data-bs-trigger="focus"
                                                title="متن پیامک"
                                                data-bs-content="این عکس مربوط به نمای جنوبی پروژه است. گرفته شده در نور روز با دوربین اصلی.">
                                                مشاهده
                                            </button>
                                        </td>
                                        <td>1403/03/01 - 14:30</td>
                                        <td>سجاد کوچه</td>

                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب لاگ‌ها -->
                        <div class="tab-pane fade" id="tab-logs">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لاگ‌های سیستم</h5>
                                <button class="btn btn-primary" type="button" id="addLogPopoverBtn">➕ افزودن لاگ</button>
                            </div>

                            <!-- فیلتر و جستجو -->
                            <div class="row g-2 mb-3">
                                <div class="col-md-4">
                                    <select class="form-select" id="logTypeFilter">
                                        <option value="">همه انواع لاگ</option>
                                        <option value="طراحی">طراحی</option>
                                        <option value="اجرا">اجرا</option>
                                        <option value="بازبینی">بازبینی</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <input type="text" class="form-control" id="logSearch" placeholder="جستجو در توضیحات لاگ...">
                                </div>
                            </div>

                            <!-- جدول لاگ‌ها -->
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>کاربر</th>
                                        <th>تاریخ و ساعت</th>
                                        <th>مرحله</th>
                                        <th>توضیحات</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>مدیر</td>
                                        <td>1403/03/10</td>
                                        <td>در دست طراحی</td>
                                        <td>
                                            <button
                                                class="btn btn-link p-0"
                                                type="button"
                                                data-bs-toggle="popover"
                                                data-bs-placement="top"
                                                data-bs-trigger="focus"
                                                title="متن لاگ"
                                                data-bs-content="این عکس مربوط به نمای جنوبی پروژه است. گرفته شده در نور روز با دوربین اصلی.">
                                                مشاهده
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>


        </div>
    </div>
    <!-- مدال افزودن/ویرایش عکس -->
    <div class="modal fade" id="modalAddPhoto" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ثبت / ویرایش عکس</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">کد عکس *</label>
                            <input id="txt-photo-code" type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات</label>
                            <textarea id="txt-photo-desc" class="form-control"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">عکاس *</label>
                            <select id="cmb-photographer" class="form-select">
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="button" onclick="btnSubmitModalPhotoClicked()" class="btn btn-success">ذخیره</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- مدال افزودن/ویرایش فیلم -->
    <div class="modal fade" id="modalAddVideo" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ثبت / ویرایش فیلم</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">کد فیلم *</label>
                            <input id="txt-video-code" type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات</label>
                            <textarea id="txt-video-desc" class="form-control"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">فیلم بردار *</label>
                            <select id="cmb-videographer" class="form-select">
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="button" onclick="btnSubmitModalVideoClicked()" class="btn btn-success">ذخیره</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- مدال افزودن/ویرایش لوکیشن -->
    <div class="modal fade" id="modalAddLocation" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ثبت / ویرایش لوکیشن</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">لوکیشن *</label>
                            <select name="status" id="cmb-location" class="form-select">
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">هزینه</label>
                            <input id="txt-location-expense" type="number" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات تکمیلی</label>
                            <textarea id="txt-location-desc" class="form-control"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="button" onclick="btnSubmitModalLocationClicked()" class="btn btn-success">ذخیره</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAddMaterial" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ثبت / ویرایش تجهیزات</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="materialForm">
                        <div class="mb-3">
                            <label class="form-label">تجهیزات *</label>
                            <select id="cmb-material" name="status" class="form-select">
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">هزینه</label>
                            <input id="txt-material-expense" type="number" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات تکمیلی</label>
                            <textarea id="txt-material-desc" class="form-control"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="button" onclick="btnSubmitModalMaterialClicked()" class="btn btn-success">ذخیره</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%--مدال کنسل کردن نوبت ها--%>
    <div class="modal fade" id="modalCancel" tabindex="-1" aria-labelledby="modalCancelLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form onsubmit="return validateCancelReason()">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCancelLabel">علت کنسلی نوبت</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="cmb-cancel-reason" class="form-label">علت کنسلی</label>
                            <select id="cmb-cancel-reason" class="form-select">
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="cancelReasonDesc" class="form-label">توضیحات (حداقل ۵ کلمه)</label>
                            <textarea class="form-control" id="cancelReasonDesc" rows="3" required></textarea>
                            <div class="text-danger mt-2 d-none" id="cancelError">لطفاً حداقل ۵ کلمه وارد کنید.</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="btnCancelSecheduleClicked();" class="btn btn-danger">تأیید کنسلی</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%--ثبت لاگ--%>
    <!-- Popover Container -->
    <div id="addLogPopover" class="popover bs-popover-top" role="tooltip" style="display: none; position: absolute; z-index: 1050;">
        <div class="popover-arrow"></div>
        <div class="popover-body">
            <form onsubmit="submitLog(event)">
                <div class="mb-2">
                    <label class="form-label">توضیحات</label>
                    <textarea class="form-control form-control-sm" id="logText" rows="2" required></textarea>
                </div>
                <button type="submit" class="btn btn-sm btn-success">ثبت</button>
            </form>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>

        $(function () {
            $('#familySelect, #projectTypeSelect').on('change', function () {
                const fam = $('#familySelect option:selected').text();
                const typ = $('#projectTypeSelect option:selected').text();
                if (fam && typ) $('#projectTitle').val(`${fam} – ${typ}`);
            });

            $('#projectStatus').on('change', function () {
                if ($(this).val() === 'ناموفق') {
                    $('#failureReasonSection').show();
                    $('#failureReason').prop('required', true);
                } else {
                    $('#failureReasonSection').hide();
                    $('#failureReason').prop('required', false).val('');
                }
            });

            $('#projectForm').on('submit', function (e) {
                e.preventDefault();
                // ارسال داده‌ها از طریق AJAX و جلوگیری از ویرایش بعدی پس از اولین ثبت
            });
        });
    </script>

    <script>
        let editingPhotoId = null;

        $('#photoForm').on('submit', function (e) {
            e.preventDefault();
            const data = Object.fromEntries(new FormData(this));

            if (data.id) {
                // ویرایش عکس موجود
                $(`#photoList tr[data-id="${data.id}"]`).replaceWith(renderPhotoRow(data));
            } else {
                data.id = Date.now(); // تولید شناسه فرضی
                $('#photoList').append(renderPhotoRow(data));
            }

            $('#photoModal').modal('hide');
            this.reset();
        });

        function renderPhotoRow(data) {
            return `
    <tr data-id="${data.id}">
      <td>${data.code}</td>
      <td>${data.title}</td>
      <td>${data.description}</td>
      <td>${data.designer || '-'}</td>
      <td>${data.date || '-'}</td>
      <td>مدیر</td>
      <td>${data.folder || '-'}</td>
      <td>${data.status || '-'}</td>
      <td>
        <button class="btn btn-sm btn-light" onclick='editPhoto(${JSON.stringify(data)})'>ویرایش</button>
        <button class="btn btn-sm btn-danger" onclick='deletePhoto(${data.id})'>حذف</button>
      </td>
    </tr>
  `;
        }

        function editPhoto(data) {
            for (const key in data) {
                $(`#photoForm [name="${key}"]`).val(data[key]);
            }
            $('#photoModal').modal('show');
        }

        function deletePhoto(id) {
            $(`#photoList tr[data-id="${id}"]`).remove();
        }
    </script>

    <%--اسکریپت لاگ ها--%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const btn = document.getElementById('addLogPopoverBtn');
            const popover = document.getElementById('addLogPopover');

            btn.addEventListener('click', function (e) {
                const rect = btn.getBoundingClientRect();
                popover.style.top = rect.top - popover.offsetHeight - 10 + window.scrollY + 'px';
                popover.style.left = rect.left + window.scrollX + 'px';
                popover.style.display = popover.style.display === 'none' ? 'block' : 'none';
            });

            document.addEventListener('click', function (e) {
                if (!popover.contains(e.target) && e.target !== btn) {
                    popover.style.display = 'none';
                }
            });
        });

        function submitLog(e) {
            e.preventDefault();
            const stage = document.getElementById('logStage').value;
            const text = document.getElementById('logText').value.trim();

            if (text.length < 10) {
                alert('توضیحات باید حداقل ۱۰ حرف باشد.');
                return;
            }

            // TODO: ارسال به سرور یا اضافه‌کردن به جدول
            alert('لاگ با موفقیت ثبت شد!');
            document.getElementById('addLogPopover').style.display = 'none';
        }




        async function fillProjectTypesAsync() {
            await ajaxGet('/BasicData/ProjectTypes', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#projectTypeSelect').html(options);
                projectTypeSelectChanged();
            });
        }

        function projectTypeSelectChanged() {
            let projectType = $('#projectTypeSelect').val();
            if (projectType) {
                showCheckList();
            }
        }
    </script>


    <%--load--%>
    <script>
        let projectId = '';
        let scheduleId = '';

        $(document).ready(async function () {
            let params = new URLSearchParams(document.location.search);
            projectId = params.get("id");
            if (projectId == undefined || projectId == '0' || projectId == 0 || projectId == 'undefined')
                projectId = '';

            scheduleId = params.get("scheduleId");
            if (scheduleId == undefined || scheduleId == '0' || scheduleId == 0 || scheduleId == 'undefined')
                scheduleId = '';

            showLocations();
            showPhotos();
            showVideos();
            showMaterials();

            await Promise.all([
                fillProjectTypesAsync(),
                fillFamiliesAsync(),
                fillDesignersAsync(),
                fillEditorsAsync(),
                showSchedulesAsync()
            ]);

            if (projectId) {
                await fillInfoAsync();
            }
        });

        function fillInfoAsync() {
            let query = `?id=${projectId}`;
            ajaxGet('/Project/Get' + query, function (res) {
                if (res.success) {
                    let data = res.data;
                    $('#familySelect').val(data.familyId);
                    $('#projectTypeSelect').val(data.projectTypeId);
                    $('#projectTitle').val(data.projectTitle);
                    $('#startDate').val(data.startDate);
                    $('#endDate').val(data.endDate);
                    if (data.isForce) {
                        $('#urgentCheckbox').attr('checked', 'checked');
                    } else {
                        $('#urgentCheckbox').removeAttr('checked');
                    }
                    if (data.designerId)
                        $('#cmb-designer').val(data.designerId);
                    $('#photoBaseDir').val(data.photoBaseDir);

                    if (data.editorId)
                        $('#cmb-editor').val(data.editorId);
                    $('#videoBaseDir').val(data.videoBaseDir);

                }
                else {
                    ShowError(res.message);
                }
            }, function (err) {
                alert("error1");
            });
        }
    </script>

    <%--global--%>
    <script>
        function getCacheKey(key) {
            return `p-${key}-p-${projectId}`;
        }
        function generateGUID() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        let isFormDirty = false;

        window.addEventListener('beforeunload', function (e) {
            if (isFormDirty) {
                const message = 'You have unsaved changes. Do you really want to leave this page?';
                e.preventDefault();
                e.returnValue = message;
                return message;
            }
        });
    </script>

    <%--top page--%>
    <script>
        async function fillFamiliesAsync() {
            await ajaxGet('/Family/GetAllFamilies', function (families) {
                const options = families.map(family =>
                    `<option value="${family.id}">${family.title}</option>`
                ).join('');
                $('#familySelect').html(options);
            });
        }
    </script>

    <%--check-list--%>
    <script>
        var checkList = [];
        function showCheckList() {
            let projectTypeId = $('#projectTypeSelect').val();
            $('#checklist-items').html('');
            checkList = [];
            $('#count-checklist').html('0');
            let query = `?ProjectTypeId=${projectTypeId}`;
            if (projectId != '') {
                query += `&ProjectId=${projectId}`;
            }
            let route = '/Project/GetCheckList';

            ajaxGet(route + query, function (items) {

                for (var i = 0; i < items.length; i++) {
                    checkList.push(items[i]);
                }

                $('#count-checklist').html(items.length);
                let html = items.map(item =>
                    `                                    
                       <tr data-status="done">
                           <td>${item.title}</td>
                           <td class="status-text">${item.done == null ? '-' : item.done == true ? '✅ انجام شد' : '× انجام نشد'}</td>
                           <td>${item.creator ? item.creator : '-'}</td>
                           <td>${item.dateTime ? item.dateTime : '-'}</td>
                       </tr>
                    `
                ).join('');

                $('#checklist-items').html(html);


            }, function (err) {
                ShowError("خطا در دریافت اطلاعات");
            });
        }
    </script>

    <%--videos--%>
    <script>
        let videoEdittingId = '';
        var videos = [];//id,desc,code,videographer
        function btnOpenModalVideoClicked(id) {
            let selectedvideographer = '';
            if (id) {
                videoEdittingId = id;
                $('#modalAddVideo').modal('show');
                const index = videos.findIndex(x => x.id === id);
                const selectedItem = videos[index];
                $('#txt-video-code').val(selectedItem.code);
                $('#txt-video-desc').val(selectedItem.desc);
                selectedvideographer = selectedItem.videographer.id;
            } else {
                videoEdittingId = '';
                $('#txt-video-code').val('');
                $('#txt-video-desc').val('');
            }

            ajaxGet('/User/GetAllVideographers', function (items) {
                let options = items.map(item =>
                    `<option ${(selectedvideographer && selectedvideographer === item.id) ? 'selected' : ''} value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-videographer').html(options);
            });
        }
        function btnSubmitModalVideoClicked() {
            let id = generateGUID();
            let videographerId = $('#cmb-videographer').val();
            let videographerTitle = $('#cmb-videographer option:selected').text();
            let code = $('#txt-video-code').val();
            let desc = $('#txt-video-desc').val();
            let json = getLocalStorage(getCacheKey('video'));
            if (json) {
                let items = JSON.parse(json);
                if (videoEdittingId) {
                    const index = items.findIndex(x => x.id === videoEdittingId);
                    items[index].id = id;
                    items[index].videographer = { id: videographerId, title: videographerTitle };
                    items[index].code = code;
                    items[index].desc = desc;

                } else {
                    items.push({
                        id: id,
                        videographer: { id: videographerId, title: videographerTitle },
                        code: code,
                        desc: desc
                    });
                }

                json = JSON.stringify(items);
            } else {
                let items = [];
                items.push({
                    id: id,
                    videographer: { id: videographerId, title: videographerTitle },
                    code: code,
                    desc: desc
                });
                json = JSON.stringify(items);
            }

            let expire = 90000;
            saveLocalStorage(getCacheKey('video'), json, expire);
            isFormDirty = true;
            $('#modalAddVideo').modal('hide');
            showVideos();
        }
        function showVideos() {
            videos = [];

            let html = '';
            $('#table-videos').html(html);

            let json = getLocalStorage(getCacheKey('video'));
            let countAll = 0;
            if (json) {
                let cachedItems = JSON.parse(json);
                for (var i = 0; i < cachedItems.length; i++) {
                    videos.push(cachedItems[i]);
                }

                countAll += cachedItems.length;
                html = cachedItems.map(item =>
                    `
                            <tr>
                                <td>${item.code}</td>
                                <td>
                                    <button
                                        class="btn btn-link p-0"
                                        type="button"
                                        data-bs-toggle="popover"
                                        data-bs-placement="top"
                                        data-bs-trigger="focus"
                                        title="توضیحات فیلم"
                                        data-bs-content="${item.desc}">
                                        مشاهده
                                    </button>
                                </td>
                                <td>${item.videographer.title}</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td><span class="badge bg-success">تدوین انجام شده</span> <span class="badge bg-danger">در انتظار تدوین</span></td>
                                <td>
                                    <button onclick='btnOpenModalVideoClicked("${item.id}")' class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                    <button onclick='btnDeleteVideoClicked("${item.id}")' class="btn btn-sm btn-outline-danger">حذف</button>
                                </td>
                            </tr>
                    `
                ).join('');

            }

            //videos.push(dbItems);
            $('#table-videos').html(html);
            $('#count-videos').html(countAll);
        }
        function btnDeleteVideoClicked(id) {
            if (confirm('از حذف فیلم اطمینان دارید ؟')) {
                const index = videos.findIndex(x => x.id === id);
                if (index !== -1) {
                    videos.splice(index, 1);
                }

                let expire = 90000;
                saveLocalStorage(getCacheKey('video'), JSON.stringify(videos), expire);
                isFormDirty = true;
                showVideos();
            }
        }
        async function fillEditorsAsync() {
            await ajaxGet('/User/GetAllEditors', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-editor').html(options);
            });
        }
    </script>

    <%--photos--%>
    <script>
        let photoEdittingId = '';
        var photos = [];//id,desc,code,photographer
        function btnOpenModalPhotoClicked(id) {
            let selectedPhotographer = '';
            if (id) {
                photoEdittingId = id;
                $('#modalAddPhoto').modal('show');
                const index = photos.findIndex(x => x.id === id);
                const selectedItem = photos[index];
                $('#txt-photo-code').val(selectedItem.code);
                $('#txt-photo-desc').val(selectedItem.desc);
                selectedPhotographer = selectedItem.photographer.id;
            } else {
                photoEdittingId = '';
                $('#txt-photo-code').val('');
                $('#txt-photo-desc').val('');
            }

            ajaxGet('/User/GetAllPhotographers', function (items) {
                let options = items.map(item =>
                    `<option ${(selectedPhotographer && selectedPhotographer === item.id) ? 'selected' : ''} value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-photographer').html(options);
            });
        }
        function btnSubmitModalPhotoClicked() {
            let id = generateGUID();
            let photographerId = $('#cmb-photographer').val();
            let photographerTitle = $('#cmb-photographer option:selected').text();
            let code = $('#txt-photo-code').val();
            let desc = $('#txt-photo-desc').val();
            let json = getLocalStorage(getCacheKey('photo'));
            if (json) {
                let items = JSON.parse(json);
                if (photoEdittingId) {
                    const index = items.findIndex(x => x.id === photoEdittingId);
                    items[index].id = id;
                    items[index].photographer = { id: photographerId, title: photographerTitle };
                    items[index].code = code;
                    items[index].desc = desc;

                } else {
                    items.push({
                        id: id,
                        photographer: { id: photographerId, title: photographerTitle },
                        code: code,
                        desc: desc
                    });
                }

                json = JSON.stringify(items);
            } else {
                let items = [];
                items.push({
                    id: id,
                    photographer: { id: photographerId, title: photographerTitle },
                    code: code,
                    desc: desc
                });
                json = JSON.stringify(items);
            }

            let expire = 90000;
            saveLocalStorage(getCacheKey('photo'), json, expire);
            isFormDirty = true;
            $('#modalAddPhoto').modal('hide');
            showPhotos();
        }
        function showPhotos() {
            photos = [];

            let html = '';
            $('#table-photos').html(html);

            let json = getLocalStorage(getCacheKey('photo'));
            let countAll = 0;
            if (json) {
                let cachedItems = JSON.parse(json);
                for (var i = 0; i < cachedItems.length; i++) {
                    photos.push(cachedItems[i]);
                }

                countAll += cachedItems.length;
                html = cachedItems.map(item =>
                    `
                            <tr>
                                <td>${item.code}</td>
                                <td>
                                    <button
                                        class="btn btn-link p-0"
                                        type="button"
                                        data-bs-toggle="popover"
                                        data-bs-placement="top"
                                        data-bs-trigger="focus"
                                        title="توضیحات عکس"
                                        data-bs-content="${item.desc}">
                                        مشاهده
                                    </button>
                                </td>
                                <td>${item.photographer.title}</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td><span class="badge bg-success">طراحی انجام شده</span> <span class="badge bg-danger">در انتظار طراحی</span></td>
                                <td>
                                    <button onclick='btnOpenModalPhotoClicked("${item.id}")' class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                    <button onclick='btnDeletePhotoClicked("${item.id}")' class="btn btn-sm btn-outline-danger">حذف</button>
                                </td>
                            </tr>
                    `
                ).join('');

            }

            //photos.push(dbItems);
            $('#table-photos').html(html);
            $('#count-photos').html(countAll);
        }
        function btnDeletePhotoClicked(id) {
            if (confirm('از حذف عکس اطمینان دارید ؟')) {
                const index = photos.findIndex(x => x.id === id);
                if (index !== -1) {
                    photos.splice(index, 1);
                }

                let expire = 90000;
                saveLocalStorage(getCacheKey('photo'), JSON.stringify(photos), expire);
                isFormDirty = true;
                showPhotos();
            }
        }
        async function fillDesignersAsync() {
            await ajaxGet('/User/GetAllDesigners', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-designer').html(options);
            });
        }
    </script>

    <%--locations--%>
    <script>
        let locationEdittingId = '';
        var locations = [];//id,desc,expense,location
        function btnOpenModalLocationClicked(id) {
            let selectedLocation = '';
            if (id) {
                locationEdittingId = id;
                $('#modalAddLocation').modal('show');
                const index = locations.findIndex(x => x.id === id);
                const selectedItem = locations[index];
                $('#txt-location-expense').val(selectedItem.expense);
                $('#txt-location-desc').val(selectedItem.desc);
                selectedLocation = selectedItem.location.id;
            } else {
                locationEdittingId = '';
                $('#txt-location-expense').val('');
                $('#txt-location-desc').val('');
            }

            ajaxGet('/BasicData/Locations', function (items) {
                let options = items.map(item =>
                    `<option ${(selectedLocation && selectedLocation === item.id) ? 'selected' : ''} value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-location').html(options);
            });
        }
        function btnSubmitModalLocationClicked() {
            let id = generateGUID();
            let locationId = $('#cmb-location').val();
            let locationTitle = $('#cmb-location option:selected').text();
            let expense = parseFloat($('#txt-location-expense').val() || '0');
            let desc = $('#txt-location-desc').val();
            let json = getLocalStorage(getCacheKey('location'));
            if (json) {
                let items = JSON.parse(json);
                if (locationEdittingId) {
                    const index = items.findIndex(x => x.id === locationEdittingId);
                    items[index].id = id;
                    items[index].location = { id: locationId, title: locationTitle };
                    items[index].expense = expense;
                    items[index].desc = desc;

                } else {
                    items.push({
                        id: id,
                        location: { id: locationId, title: locationTitle },
                        expense: expense,
                        desc: desc
                    });
                }

                json = JSON.stringify(items);
            } else {
                let items = [];
                items.push({
                    id: id,
                    location: { id: locationId, title: locationTitle },
                    expense: expense,
                    desc: desc
                });
                json = JSON.stringify(items);
            }

            let expire = 90000;
            saveLocalStorage(getCacheKey('location'), json, expire);
            isFormDirty = true;
            $('#modalAddLocation').modal('hide');
            showLocations();
        }
        function showLocations() {
            locations = [];

            let html = '';
            $('#table-locations').html(html);

            let json = getLocalStorage(getCacheKey('location'));
            let countAll = 0;
            if (json) {
                let cachedItems = JSON.parse(json);
                for (var i = 0; i < cachedItems.length; i++) {
                    locations.push(cachedItems[i]);
                }

                countAll += cachedItems.length;
                html = cachedItems.map(item =>
                    `
                                     <tr>
                                        <td>${item.location.title}</td>
                                        <td>${item.expense}</td>
                                        <td>${item.desc}</td>
                                        <td>-</td>
                                        <td>-</td>
                                        <td>
                                            <button onclick='btnOpenModalLocationClicked("${item.id}")' class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button onclick='btnDeleteLocationClicked("${item.id}")' class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
                    `
                ).join('');

            }

            //locations.push(dbItems);
            $('#table-locations').html(html);
            $('#count-locations').html(countAll);
        }
        function btnDeleteLocationClicked(id) {
            if (confirm('از حذف لوکیشن اطمینان دارید ؟')) {
                const index = locations.findIndex(x => x.id === id);
                if (index !== -1) {
                    locations.splice(index, 1);
                }

                let expire = 90000;
                saveLocalStorage(getCacheKey('location'), JSON.stringify(locations), expire);
                isFormDirty = true;
                showLocations();
            }
        }
    </script>

    <%--materials--%>
    <script>
        let materialEdittingId = '';
        var materials = [];//id,desc,expense,material
        function btnOpenModalMaterialClicked(id) {
            let selectedMaterial = '';
            if (id) {
                materialEdittingId = id;
                $('#modalAddMaterial').modal('show');
                const index = materials.findIndex(x => x.id === id);
                const selectedItem = materials[index];
                $('#txt-material-expense').val(selectedItem.expense);
                $('#txt-material-desc').val(selectedItem.desc);
                selectedMaterial = selectedItem.material.id;
            } else {
                materialEdittingId = '';
                $('#txt-material-expense').val('');
                $('#txt-material-desc').val('');
            }

            ajaxGet('/BasicData/ProjectMaterials', function (items) {
                let options = items.map(item =>
                    `<option ${(selectedMaterial && selectedMaterial === item.id) ? 'selected' : ''} value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-material').html(options);
            });
        }
        function btnSubmitModalMaterialClicked() {
            let id = generateGUID();
            let materialId = $('#cmb-material').val();
            let materialTitle = $('#cmb-material option:selected').text();
            let expense = parseFloat($('#txt-material-expense').val() || '0');
            let desc = $('#txt-material-desc').val();
            let json = getLocalStorage(getCacheKey('material'));
            if (json) {
                let items = JSON.parse(json);
                if (materialEdittingId) {
                    const index = items.findIndex(x => x.id === materialEdittingId);
                    items[index].id = id;
                    items[index].material = { id: materialId, title: materialTitle };
                    items[index].expense = expense;
                    items[index].desc = desc;

                } else {
                    items.push({
                        id: id,
                        material: { id: materialId, title: materialTitle },
                        expense: expense,
                        desc: desc
                    });
                }

                json = JSON.stringify(items);
            } else {
                let items = [];
                items.push({
                    id: id,
                    material: { id: materialId, title: materialTitle },
                    expense: expense,
                    desc: desc
                });
                json = JSON.stringify(items);
            }

            let expire = 90000;
            saveLocalStorage(getCacheKey('material'), json, expire);
            isFormDirty = true;
            $('#modalAddMaterial').modal('hide');
            showMaterials();
        }
        function showMaterials() {
            materials = [];

            let html = '';
            $('#table-materials').html(html);

            let json = getLocalStorage(getCacheKey('material'));
            let countAll = 0;
            if (json) {
                let cachedItems = JSON.parse(json);
                for (var i = 0; i < cachedItems.length; i++) {
                    materials.push(cachedItems[i]);
                }

                countAll += cachedItems.length;
                html = cachedItems.map(item =>
                    `
                          <tr>
                              <td>${item.material.title}</td>
                              <td>${item.expense}</td>
                              <td>${item.desc}</td>
                              <td>-</td>
                              <td>-</td>
                              <td>
                                  <button onclick='btnOpenModalMaterialClicked("${item.id}")' class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                  <button onclick='btnDeleteMaterialClicked("${item.id}")' class="btn btn-sm btn-outline-danger">حذف</button>
                              </td>
                          </tr>
                    `
                ).join('');

            }

            //materials.push(dbItems);
            $('#table-materials').html(html);
            $('#count-materials').html(countAll);
        }
        function btnDeleteMaterialClicked(id) {
            if (confirm('از حذف تجهیزات اطمینان دارید ؟')) {
                const index = materials.findIndex(x => x.id === id);
                if (index !== -1) {
                    materials.splice(index, 1);
                }

                let expire = 90000;
                saveLocalStorage(getCacheKey('material'), JSON.stringify(materials), expire);
                isFormDirty = true;
                showMaterials();
            }
        }
    </script>

    <%--schedules--%>
    <script>
        let scheduleCancelingId = '';

        async function showSchedulesAsync() {
            $('#table-schedule').html('');
            const route = '/Schedule/SchedulesOfProject';
            let query = `?a=0`;
            if (projectId) {
                query += `&projectId=${projectId}`;
            }
            if (scheduleId) {
                query += `&scheduleId=${scheduleId}`;
            }
            await ajaxGet(route + query, function (items) {
                let html = items.map(generateScheduleRow).join('');
                $('#table-schedule').html(html);
            });
        }
        function generateScheduleRow(item) {
            const isCancelled = item.isCancel;

            const badge = `<span class="badge ${isCancelled ? 'bg-secondary' : 'bg-success'}">
                  ${isCancelled ? 'کنسل شده' : 'فعال'}
                </span>`;

            const actionButton = isCancelled
                ? `<button class="btn btn-sm btn-outline-success">بازگرداندن</button>`
                : `<button onclick=btnModalCancelScheduleClicked('${item.id}'); class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#modalCancel">کنسل کردن</button>`;

            return `
                  <tr ${isCancelled ? 'class="table-warning"' : ''}>
                    <td>${item.date}</td>
                    <td>${item.shortTime}</td>
                    <td>${item.creator}</td>
                    <td>${item.creationDateTime}</td>
                    <td>${badge}</td>
                    <td>${actionButton}</td>
                  </tr>
                `;
        }

        async function btnModalCancelScheduleClicked(id) {
            scheduleCancelingId = id;
            await ajaxGet('/BasicData/GetCancelScheduleReasons', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#cmb-cancel-reason').html(options);
            });
        }

        async function btnCancelSecheduleClicked() {
            let cancelReasonId = $('#cmb-cancel-reason').val() || null;
            let desc = $('#cancelReasonDesc').val();
            let cancelScheduleCommand =
            {
                id: scheduleCancelingId,
                isCanceled: true,
                desc: desc,
                cancelReasonId
            };
            let route = '/Schedule/Cancel';
            await ajaxAuthCall('PATCH', route, cancelScheduleCommand, function (res) {
                if (!res.success) {
                    ShowError(res.message);
                    return;
                }
                toastr.success('ثبت اطلاعات با موفقیت انجام شد', "موفق");
            }, function (err) {
                console.log(err);
            });

            $('#modalCancel').modal('hide');
            await showSchedulesAsync();
        }

    </script>

    <script>
        function btnSubmitClicked() {
            let familyId = $('#familySelect').val();
            if (!familyId) {
                toastr.warning('لطفاً خانواده را انتخاب کنید', 'خانواده');
                return;
            }
            let projectTypeId = $('#projectTypeSelect').val();
            if (!projectTypeId) {
                toastr.warning('لطفاً نوع پروژه را انتخاب کنید', 'نوع پروژه');
                return;
            }
            let projectTitle = $('#projectTitle').val();
            if (!projectTitle) {
                toastr.warning('لطفاً عنوان پروژه را وارد کنید', 'عنوان پروژه');
                return;
            }
            let startDate = $('#startDate').val();
            if (!startDate) {
                toastr.warning('لطفاً تاریخ شروع را وارد کنید', 'تاریخ شروع');
                return;
            }
            let endDate = $('#endDate').val();
            if (!endDate) {
                toastr.warning('لطفاً تاریخ پایان را وارد کنید', 'تاریخ پایان');
                return;
            }
            let isForce = $('#urgentCheckbox').attr('checked');

            let designerId = $('#cmb-designer').val() || null;
            let photoBaseDir = $('#photoBaseDir').val();

            let editorId = $('#cmb-editor').val() || null;
            let videoBaseDir = $('#videoBaseDir').val();



            //materials = [];//id,desc,expense,material
            //locations = [];//id,desc,expense,location
            //photos = [];//id,desc,code,photographer
            //videos = [];//id,desc,code,videographer



            let createProjectCommand = {
                familyId,
                projectTypeId,
                projectTitle,
                scheduleId: scheduleId || null,
                isForce,
                startDate,
                endDate,
                designerId,
                photoBaseDir,
                editorId,
                videoBaseDir,
                photos,
                videos,
                materials,
                locations,
                checkList
            };
            let method = 'POST';
            let route = '/Project/Create';
            if (projectId != '') {
                method = 'PUT';
                route = '/Project/Update';
            }
            ajaxAuthCall(method, route, createProjectCommand, function (res) {
                btnAddEdit_ChangeDisable('btn-submit-project', false);
                if (res.success) {
                    toastr.success('ثبت اطلاعات با موفقیت انجام شد', "موفق");
                    location.href = document.referrer;
                }
                else {
                    ShowError(res.message);
                }
            }, function (err) {
                btnAddEdit_ChangeDisable('btn-submit-project', false);
            });
        }
    </script>
</asp:Content>

