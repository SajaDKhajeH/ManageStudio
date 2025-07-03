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
                                    <label class="form-check-label">انجام فوری</label>
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
                                <label class="form-label required">وضعیت پروژه</label>
                                <select id="projectStatus" class="form-select" required>
                                    <option value="ثبت">ثبت</option>
                                    <option value="در حال انجام">در حال انجام</option>
                                    <option value="در انتظار تسویه">در انتظار تسویه</option>
                                    <option value="آماده برای طراحی و تدوین">آماده برای طراحی و تدوین</option>
                                    <option value="موفق">موفق</option>
                                    <option value="ناموفق">ناموفق</option>
                                </select>
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
                         <ul class="nav nav-tabs overflow-auto flex-nowrap border-bottom" style="white-space: nowrap; max-width: 100%;">
  <li class="nav-item">
    <a class="nav-link active" data-bs-toggle="tab" href="#tab-checklist">
      <i class="bi bi-list-check"></i> چک‌لیست
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-photos">
      <i class="bi bi-image"></i> عکس‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-videos">
      <i class="bi bi-camera-reels"></i> فیلم‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-locations">
      <i class="bi bi-geo-alt"></i> لوکیشن‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-schedules">
      <i class="bi bi-calendar-event"></i> نوبت‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-equipments">
      <i class="bi bi-hammer"></i> تجهیزات
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-invoices">
      <i class="bi bi-file-earmark-text"></i> فاکتورها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-payments">
      <i class="bi bi-credit-card"></i> پرداختی‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-messages">
      <i class="bi bi-chat-dots"></i> پیامک‌ها
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-bs-toggle="tab" href="#tab-logs">
      <i class="bi bi-clock-history"></i> لاگ‌ها
    </a>
  </li>
</ul>
             <div class="tab-content">
        <div id="checklistTab" class="tab-pane fade show active">…</div>
        <div id="photosTab" class="tab-pane fade">…</div>
        <div id="videosTab" class="tab-pane fade">…</div>
        <div id="locationsTab" class="tab-pane fade">…</div>
        <div id="sessionsTab" class="tab-pane fade">…</div>
        <div id="equipmentTab" class="tab-pane fade">…</div>
        <div id="invoicesTab" class="tab-pane fade">…</div>
        <div id="paymentsTab" class="tab-pane fade">…</div>
        <div id="smsTab" class="tab-pane fade">…</div>
        <div id="logsTab" class="tab-pane fade">…</div>
    </div>
                </div>
            </div>

       
        </div>
    </div>


   
    <div class="modal fade" id="photoModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="photoForm">
                    <div class="modal-header">
                        <h5 class="modal-title">افزودن/ویرایش عکس</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">کد</label>
                                <input type="text" name="code" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">عنوان</label>
                                <input type="text" name="title" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">طراح</label>
                                <select name="designer" class="form-select">
                                    <!-- لیست کاربران -->
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">توضیح</label>
                            <textarea name="description" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">پوشه</label>
                                <input type="text" name="folder" class="form-control">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">تاریخ</label>
                                <input type="date" name="date" class="form-control">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">وضعیت</label>
                                <select name="status" class="form-select">
                                    <option>در حال طراحی</option>
                                    <option>آماده چاپ</option>
                                    <option>تحویل شده</option>
                                </select>
                            </div>
                        </div>
                        <input type="hidden" name="id">
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">ذخیره</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">بستن</button>
                    </div>
                </form>
            </div>
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
</asp:Content>

