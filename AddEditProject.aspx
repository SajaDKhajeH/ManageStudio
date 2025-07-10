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
                                <select id="projectTypeSelect" class="form-select" required>
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
                                <input id="projectTitle" type="text" class="form-control" required readonly />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label required">تاریخ شروع</label>
                                <input id="startDate" type="date" class="form-control" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label required">تاریخ پایان</label>
                                <input id="endDate" type="date" class="form-control" required />
                            </div>
                        </div>
                        <div id="failureReasonSection" class="mb-4" style="display: none">
                            <label class="form-label required">دلیل عدم موفقیت</label>
                            <textarea id="failureReason" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">ثبت پروژه</button>
                        </div>
                    </form>
                    <ul class="nav nav-tabs mt-4" id="projectTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-bs-toggle="tab" href="#tab-checklist">📋 چک‌لیست <span class="badge bg-secondary ms-1" id="count-checklist">0</span>
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
                            <a class="nav-link" data-bs-toggle="tab" href="#tab-equipment">🔌 تجهیزات <span class="badge bg-secondary ms-1" id="count-equipment">0</span>
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
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddPhoto">➕ افزودن عکس</button>
                            </div>

                            <!-- 🔽 فیلترها و آدرس عکس‌ها -->
                            <div class="row mb-3">
                                <!-- انتخاب طراح -->
                                <div class="col-md-4">
                                    <label for="designerFilter" class="form-label">انتخاب طراح:</label>
                                    <select id="designerFilter" class="form-select">
                                        <option value="">انتخاب طراح</option>
                                        <option value="علی رضایی">علی رضایی</option>
                                        <option value="سارا احمدی">سارا احمدی</option>
                                        <option value="محمد کرمی">محمد کرمی</option>
                                    </select>
                                </div>

                                <!-- ورودی آدرس عکس -->
                                <div class="col-md-8">
                                    <label for="photoBasePath" class="form-label">آدرس اصلی عکس‌ها:</label>
                                    <input type="text" id="photoBasePath" class="form-control" placeholder="مثلاً: /uploads/photos/">
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
                                <tbody id="photoTableBody">
                                    <tr>
                                        <td>AX-001</td>
                                        <td>
                                            <button
                                                class="btn btn-link p-0"
                                                type="button"
                                                data-bs-toggle="popover"
                                                data-bs-placement="top"
                                                data-bs-trigger="focus"
                                                title="توضیحات عکس"
                                                data-bs-content="این عکس مربوط به نمای جنوبی پروژه است. گرفته شده در نور روز با دوربین اصلی.">
                                                مشاهده
                                            </button>
                                        </td>
                                        <td>جواد پهلوان</td>
                                        <td>علی رضایی</td>
                                        <td>مدیر</td>
                                        <td>1403/03/21 - 15:32</td>
                                        <td><span class="badge bg-success">طراحی انجام شده</span> <span class="badge bg-danger">در انتظار طراحی</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب فیلم‌ها -->
                        <div class="tab-pane fade" id="tab-videos">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لیست فیلم ‌ها</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddVideo">➕ افزودن فیلم</button>
                            </div>

                            <div class="row mb-3">
                                <!-- انتخاب تدوینگر -->
                                <div class="col-md-4">
                                    <label for="EditorFilter" class="form-label">انتخاب تدوینگر:</label>
                                    <select id="EditorFilter" class="form-select">
                                        <option value="">انتخاب تدوینگر</option>
                                        <option value="علی رضایی">علی رضایی</option>
                                        <option value="سارا احمدی">سارا احمدی</option>
                                        <option value="محمد کرمی">محمد کرمی</option>
                                    </select>
                                </div>

                                <!-- ورودی آدرس عکس -->
                                <div class="col-md-8">
                                    <label for="photoBasePath" class="form-label">آدرس اصلی فیلم‌ها:</label>
                                    <input type="text" id="videoBasePath" class="form-control" placeholder="مثلاً: /uploads/videos/">
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
                                <tbody id="videoTableBody">
                                    <tr>
                                        <td>AX-001</td>
                                        <td>
                                            <button
                                                class="btn btn-link p-0"
                                                type="button"
                                                data-bs-toggle="popover"
                                                data-bs-placement="top"
                                                data-bs-trigger="focus"
                                                title="توضیحات فیلم"
                                                data-bs-content="این فیلم مربوط به نمای جنوبی پروژه است. گرفته شده در نور روز با دوربین اصلی.">
                                                مشاهده
                                            </button>
                                        </td>
                                        <td>جواد پهلوان</td>
                                        <td>علی رضایی</td>
                                        <td>مدیر</td>
                                        <td>1403/03/21 - 15:32</td>
                                        <td><span class="badge bg-success">تدوین انجام شده</span> <span class="badge bg-danger">در انتظار تدوین</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
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
                                        <th>تاریخ</th>
                                        <th>عملیات</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr data-status="done">
                                        <td>دوربین بررسی شد</td>
                                        <td class="status-text">✅ انجام شد</td>
                                        <td>1403/01/10</td>
                                        <td>
                                            <button class="btn btn-success btn-sm do-btn">انجام شد</button>
                                            <button class="btn btn-danger btn-sm undo-btn">عدم انجام</button>
                                            <div class="mt-2 d-none reason-box">
                                                <input type="text" class="form-control form-control-sm reason-input" placeholder="توضیحات...">
                                                <small class="text-danger d-none reason-error">توضیحات باید حداقل ۵ کلمه باشد</small>
                                                <button class="btn btn-primary btn-sm mt-1 submit-reason-btn">ثبت توضیح</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب لوکیشن‌ها -->
                        <div class="tab-pane fade" id="tab-locations">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">لوکیشن‌ها</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddLocation">➕ افزودن لوکیشن</button>
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
                                <tbody>
                                    <tr>
                                        <td>عمارت تاریخی</td>
                                        <td>1,000,000 تومان</td>
                                        <td>لوکیشن اصلی</td>
                                        <td>کاربر</td>
                                        <td>1403/03/21 - 15:32</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
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
                                <tbody>
                                    <!-- نوبت فعال -->
                                    <tr>
                                        <td>1403/04/10</td>
                                        <td>جلسه ساعت 3</td>
                                        <td>ادمین</td>
                                        <td>1403/04/09 - 14:30</td>
                                        <td><span class="badge bg-success">فعال</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#modalCancel">کنسل کردن</button>
                                        </td>
                                    </tr>

                                    <!-- نوبت کنسل‌شده -->
                                    <tr class="table-warning">
                                        <td>1403/04/08</td>
                                        <td>جلسه ساعت 11</td>
                                        <td>کاربر</td>
                                        <td>1403/04/07 - 13:00</td>
                                        <td><span class="badge bg-secondary">کنسل شده</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-success">بازگرداندن</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- تب تجهیزات -->
                        <div class="tab-pane fade" id="tab-equipment">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">تجهیزات</h5>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddEquipment">➕ افزودن تجهیزات</button>
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
                                <tbody>
                                    <tr>
                                        <td>دوربین</td>
                                        <td>1,000,000 تومان</td>
                                        <td>لنز فلان مارک</td>
                                        <td>کاربر</td>
                                        <td>1403/03/21 - 15:32</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">ویرایش</button>
                                            <button class="btn btn-sm btn-outline-danger">حذف</button>
                                        </td>
                                    </tr>
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
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات</label>
                            <textarea class="form-control"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">عکاس *</label>
                            <select id="photographerFilter" class="form-select">
                                <option value="علی رضایی">علی رضایی</option>
                                <option value="سارا احمدی">سارا احمدی</option>
                                <option value="محمد کرمی">محمد کرمی</option>
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-success">ذخیره</button>
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
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات</label>
                            <textarea class="form-control"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">فیلم بردار *</label>
                            <select id="videographerFilter" class="form-select">
                                <option value="علی رضایی">علی رضایی</option>
                                <option value="سارا احمدی">سارا احمدی</option>
                                <option value="محمد کرمی">محمد کرمی</option>
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-success">ذخیره</button>
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
                            <select name="status" class="form-select">
                                <option value="فعال">باغ اکبر</option>
                                <option value="غیرفعال">تالار اصغر</option>
                                <option value="در تعمیر">باغ تالار سجاد</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">هزینه</label>
                            <input type="number" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات تکمیلی</label>
                            <textarea class="form-control"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-success">ذخیره</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAddEquipment" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ثبت / ویرایش تجهیزات</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="equipmentForm">
                        <div class="mb-3">
                            <label class="form-label">تجهیزات *</label>
                            <select name="status" class="form-select">
                                <option value="فعال">دوربین سه لنزه</option>
                                <option value="غیرفعال">پایه عکاسی</option>
                                <option value="در تعمیر">نور هفت بعدی</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">هزینه</label>
                            <input type="number" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیحات تکمیلی</label>
                            <textarea class="form-control"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-success">ذخیره</button>
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
                            <label for="cancelReason" class="form-label">علت کنسلی</label>
                            <select id="cancelReason" class="form-select">
                                <option value="علی رضایی">توسط مشتری</option>
                                <option value="سارا احمدی">آلودگی هوا</option>
                                <option value="محمد کرمی">جنگ</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">توضیحات (حداقل ۵ کلمه)</label>
                            <textarea class="form-control" id="cancelReasonDesc" rows="3" required></textarea>
                            <div class="text-danger mt-2 d-none" id="cancelError">لطفاً حداقل ۵ کلمه وارد کنید.</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-danger">تأیید کنسلی</button>
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

    <%--اسکریپت چک لیست--%>
    <script>
        document.querySelectorAll(".do-btn").forEach(btn => {
            btn.addEventListener("click", function () {
                const row = this.closest("tr");
                row.dataset.status = "done";
                row.querySelector(".status-text").textContent = "✅ انجام شد";
                row.querySelector(".reason-box").classList.add("d-none");
            });
        });

        document.querySelectorAll(".undo-btn").forEach(btn => {
            btn.addEventListener("click", function () {
                const row = this.closest("tr");
                const prevStatus = row.dataset.status;
                const reasonBox = row.querySelector(".reason-box");

                if (prevStatus === "done") {
                    reasonBox.classList.remove("d-none");
                } else {
                    row.dataset.status = "undone";
                    row.querySelector(".status-text").textContent = "❌ انجام نشد";
                    reasonBox.classList.add("d-none");
                }
            });
        });

        document.querySelectorAll(".submit-reason-btn").forEach(btn => {
            btn.addEventListener("click", function () {
                const row = this.closest("tr");
                const input = row.querySelector(".reason-input");
                const error = row.querySelector(".reason-error");
                const words = input.value.trim().split(/\s+/);

                if (words.length < 5) {
                    error.classList.remove("d-none");
                } else {
                    error.classList.add("d-none");
                    row.dataset.status = "undone";
                    row.querySelector(".status-text").textContent = "❌ انجام نشد";
                    row.querySelector(".reason-box").classList.add("d-none");
                    input.value = "";
                    // می‌تونی اینجا توضیح رو بفرستی به سرور با AJAX
                    console.log("توضیح ثبت‌شده:", words.join(" "));
                }
            });
        });
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
    </script>
</asp:Content>

