<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Process_of_Preparing_Photos.aspx.cs" Inherits="Process_of_Preparing_Photos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <style>
        .kanban-board {
            display: flex;
            overflow-x: auto;
            gap: 1rem;
            padding: 1rem;
        }

        .kanban-column {
            background: #fff;
            border-radius: 12px;
            min-width: 320px;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .kanban-header {
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            font-weight: bold;
            color: white;
        }

        .project-card {
            background: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 1rem;
            margin: 0.5rem;
            position: relative;
            cursor: grab;
        }

            .project-card.debtor::before {
                content: 'بدهکار';
                position: absolute;
                top: 0;
                right: 0;
                background-color: #dc3545;
                color: white;
                padding: 0.2rem 0.5rem;
                border-bottom-left-radius: 8px;
                font-size: 0.75rem;
            }

        .urgent-label {
            position: absolute;
            top: 8px;
            left: 8px;
            background-color: #f8a521;
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 5px;
            font-size: 0.75rem;
        }

        .project-days {
            font-size: 2rem;
            font-weight: bold;
            color: #0d6efd;
            margin-bottom: 0.5rem;
        }

        .project-footer {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 1rem;
            border-top: 1px solid #dee2e6;
            padding-top: 0.5rem;
        }

            .project-footer .badge {
                margin-top: 0.3rem;
                display: inline-block;
                cursor: pointer;
            }

        .month-group {
            margin-top: 1rem;
        }

        .month-header {
            background-color: #e9ecef;
            padding: 0.5rem 1rem;
            cursor: pointer;
            font-weight: bold;
            border-radius: 8px;
        }

        .project-list.collapsed {
            display: none;
        }

        .empty-dropzone {
            min-height: 100px;
            border: 2px dashed #bbb;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding: 10px;
        }

            .empty-dropzone:hover {
                background-color: #e2e6ea;
            }

        #checklistForm .form-check-input {
            transform: scale(0.9); /* یا 0.8 برای کوچکتر */
            margin-top: 0.2rem;
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
                                <select id="filter_Family" data-dropdown-parent="#kt_post" data-control="select2" class="form-select form-select-solid select2-hidden-accessible" data-placeholder="انتخاب مشتری">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Causer">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <select id="filter_Designer">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="filter_DayPastFromLastStep" class="form-control" placeholder="روز گذشته از آخرین مرحله">
                            </div>
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_ProjectForce" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">انجام فوری</span>
                                    </label>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="kanban-board">
                            <script>
                                const statuses = [
                                    { key: 'readyForDesign', label: 'آماده طراحی', color: '#6c757d', showCheckList: false, sort: 1 },
                                    { key: 'in_Design', label: 'در دست طراحی', color: '#0d6efd', showCheckList: false, sort: 2 },
                                    { key: 'AcceptCustomer', label: 'در انتظار تایید مشتری', color: '#ffc107', showCheckList: true, sort: 3 },
                                    { key: 'ready_for_Print', label: 'آماده چاپ', color: '#20c997', showCheckList: true, sort: 4 },
                                    { key: 'ready_for_Delivery', label: 'اماده تحویل', color: '#198754', showCheckList: true, sort: 5 },
                                    { key: 'Deliverd', label: 'تحویل داده شد', color: '#dc3545', showCheckList: false, sort: 6 }
                                ];
                            </script>

                            <div id="kanban-container" class="d-flex gap-3 w-100"></div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="smsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ارسال پیامک به خانواده‌ها</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">
                    <textarea class="form-control" rows="4" placeholder="متن پیامک را وارد کنید..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">بستن</button>
                    <button type="button" class="btn btn-primary">ارسال</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="photoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">مدیریت عکس‌های پروژه</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered align-middle">
                        <thead>
                            <tr>
                                <th>کد عکس</th>
                                <th>توضیحات</th>
                                <th>آپلود</th>
                                <th>پیش‌نمایش</th>
                                <th>عملیات</th>
                            </tr>
                        </thead>
                        <tbody id="photoTableBody">
                            <!-- Rows go here dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="logsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">توضیحات پروژه</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ثبت‌کننده</th>
                                <th>تاریخ/ساعت</th>
                                <th>توضیحات</th>
                            </tr>
                        </thead>
                        <tbody id="logsTableBody">
                            <!-- لاگ‌ها اینجا اضافه میشن -->
                        </tbody>
                    </table>

                    <div class="mt-4">
                        <label for="newLogText" class="form-label">افزودن توضیح جدید:</label>
                        <textarea id="newLogText" rows="3" class="form-control" placeholder="توضیح جدید را وارد کنید..."></textarea>
                        <button onclick="addLogEntry()" class="btn btn-primary mt-2">افزودن</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="checklistModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">تکمیل چک‌لیست انتقال کارت</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">
                    <form id="checklistForm">
                        <div class="d-flex align-items-center mb-2" style="font-size: 14px;">
                            <input type="checkbox" id="item1" class="form-check-input me-2" style="width: 16px; height: 16px;">
                            <label for="item1" class="form-check-label">بررسی صحت اطلاعات</label>
                        </div>
                        <%-- <div class="d-flex align-items-center mb-2" style="font-size: 14px;">
                            <input type="checkbox" id="item2" class="form-check-input me-2" style="width: 16px; height: 16px;">
                            <label for="item2" class="form-check-label">تایید نهایی توسط سرپرست</label>
                        </div>

                        <div class="d-flex align-items-center mb-2" style="font-size: 14px;">
                            <input type="checkbox" id="item3" class="form-check-input me-2" style="width: 16px; height: 16px;">
                            <label for="item3" class="form-check-label">بارگذاری مدارک مرتبط</label>
                        </div>--%>
                    </form>


                </div>
                <div class="modal-footer">
                    <button type="button" id="checklistCancel" class="btn btn-secondary" data-bs-dismiss="modal">لغو</button>
                    <button type="button" id="checklistSubmit" class="btn btn-primary" data-bs-dismiss="modal" disabled>ثبت</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="reasonModal" tabindex="-1" aria-labelledby="reasonModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reasonModalLabel">علت بازگشت پروژه</h5>
                </div>
                <div class="modal-body">
                    <textarea id="reasonInput" class="form-control" rows="4" placeholder="لطفاً علت بازگشت پروژه را وارد کنید..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">انصراف</button>
                    <button type="button" class="btn btn-primary" id="submitReasonBtn">ثبت</button>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>

        $(document).ready(function () {
            $("#master_PageTitle").text("آماده سازی عکس ها");
        });
        const kanbanData = {
            readyForDesign: [
                { id: 1, title: 'پروژه پهلوان', family: 'پهلوان', date: '1402/04/01', urgent: false, debt: true },
                { id: 2, title: 'پروژه نوزادی', family: 'احمدی', date: '1403/04/01', urgent: false, debt: false },
                { id: 3, title: 'پروژه نوزادی2', family: 'مرادی', date: '1403/03/01', urgent: false, debt: true },

            ],
            in_Design: [
                { id: 4, title: 'پروژه عروسی', family: 'کریمی', date: '1403/04/10', urgent: true, debt: false },
                { id: 5, title: 'پروژه تولد', family: 'احمدی', date: '1403/05/10', urgent: true, debt: false },
                { id: 6, title: 'فرمالیته', family: 'نعمتی', date: '1403/05/10', urgent: true, debt: true },
                { id: 7, title: 'دندونی', family: 'کواکبیان', date: '1403/05/10', urgent: true, debt: false }
            ],
            AcceptCustomer: [
                { id: 8, title: 'پروژه فارغ‌التحصیلی', family: 'جعفری', date: '1403/03/29', urgent: false, debt: true }
            ],
            ready_for_Print: [
                { id: 9, title: 'پروژه تبلیغاتی', family: 'قاسمی', date: '1403/04/02', urgent: false, debt: true }
            ],
            ready_for_Delivery: [
                { id: 10, title: 'پروژه خانوادگی', family: 'نصیری', date: '1403/02/22', urgent: false, debt: true }
            ],
            Deliverd: [

            ]
        };

        function openSMSModal() {
            const modal = new bootstrap.Modal(document.getElementById('smsModal'));
            modal.show();
        }

        function toggleMonth(header) {
            const list = header.nextElementSibling;
            list.classList.toggle('collapsed');
        }

        function createCard(item) {
            const card = document.createElement('div');
            card.className = 'project-card';

            if (item.debt) card.classList.add('debtor');
            card.draggable = true;
            //card.setAttribute('data-id', item.id || Math.random());
            card.setAttribute('data-id', item.id);
            card.innerHTML = `
        <div class="project-days">+15</div>
        <h6>${item.title}</h6>
        <p>خانواده ${item.family}</p>
        <p>تاریخ شروع: ${item.date}</p>
        ${item.urgent ? '<span class="urgent-label">فوری</span>' : ''}
        <div class="project-footer d-flex flex-column gap-2">
            <div>ثبت توسط: مدیر سیستم - ۱۴۰۳/۰۳/۱۰ ساعت ۱۰:۳۰</div>
            <div class="d-flex flex-wrap gap-2">
                <button class="btn btn-sm btn-light-primary" onclick="showPhotos('${item.title}')">
                    <i class="bi bi-images"></i> مشاهده عکس‌ها
                </button>
                <button class="btn btn-sm btn-light-info" onclick="openLogsModal('${item.title}')">
                    <i class="bi bi-info-circle"></i> توضیحات
                </button>
            </div>
        </div>
    `;
            return card;
        }
        function groupByMonth(items) {
            return items.reduce((acc, item) => {
                const [year, month] = item.date.split('/');
                const key = `${year}/${month}`;
                if (!acc[key]) acc[key] = [];
                acc[key].push(item);
                return acc;
            }, {});
        }

        function monthName(number) {
            const names = ['فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'];
            return names[parseInt(number) - 1] || number;
        }


        function createColumn(statusKey, label, items) {
            const col = document.createElement('div');
            col.className = 'kanban-column';
            col.dataset.status = statusKey;

            const status = statuses.find(s => s.key === statusKey);

            col.innerHTML = `
        <div class="kanban-header" style="background-color: ${status.color};">
            <h5>${label} (${items.length})</h5>
            <button class="btn btn-sm btn-light w-100 mt-2" onclick="openSMSModal()">ارسال پیامک</button>
            <select class="form-select form-select-sm mt-2 sort-select">
                <option value="">مرتب‌سازی</option>
                <option value="asc">قدیمی‌ترین</option>
                <option value="desc">جدیدترین</option>
            </select>
        </div>
        <div class="kanban-content p-2 overflow-auto" style="background-color: #f0f0f0; min-height: 150px;"></div>
    `;

            const container = col.querySelector('.kanban-content');
            const select = col.querySelector('.sort-select');

            function renderSortedProjects(order = '') {

                container.innerHTML = '';

                let sortedItems = [...items];
                if (order === 'asc') {
                    sortedItems.sort((a, b) => a.date.localeCompare(b.date));
                } else if (order === 'desc') {
                    sortedItems.sort((a, b) => b.date.localeCompare(a.date));
                }

                const monthGroups = groupByMonth(sortedItems);

                // اگر پروژه‌ای نداریم:
                if (sortedItems.length === 0) {
                    const emptyList = document.createElement('div');
                    emptyList.className = 'project-list empty-dropzone';
                    emptyList.dataset.status = statusKey;
                    container.appendChild(emptyList);

                    attachSortable(emptyList);
                    return;
                }

                // در غیر اینصورت برای هر ماه:
                for (const [key, monthItems] of Object.entries(monthGroups)) {
                    const [year, month] = key.split('/');
                    const monthDiv = document.createElement('div');
                    monthDiv.className = 'month-group';

                    const monthHeader = document.createElement('div');
                    monthHeader.className = 'month-header';
                    monthHeader.textContent = `${monthName(month)} ${year} (${monthItems.length})`;
                    monthHeader.onclick = () => toggleMonth(monthHeader);

                    const projectList = document.createElement('div');
                    projectList.className = 'project-list';
                    projectList.dataset.status = statusKey;

                    monthItems.forEach(item => {
                        const card = createCard(item); // فرض بر اینه که این تابع موجوده
                        projectList.appendChild(card);
                    });

                    monthDiv.appendChild(monthHeader);
                    monthDiv.appendChild(projectList);
                    container.appendChild(monthDiv);

                    attachSortable(projectList);
                }

            }

            // تابع مشترک برای اتصال Sortable
            function attachSortable(listElement) {
                new Sortable(listElement, {
                    group: 'shared',
                    animation: 150,
                    onAdd: function (evt) {
                        const card = evt.item;
                        const source = evt.from.closest('.kanban-column');
                        const target = evt.to.closest('.kanban-column');

                        updateEmptyDropzoneState(source);
                        updateEmptyDropzoneState(target);

                        alert("✅ کارت منتقل شد به ستون جدید");
                        onCardDrop(card, source, target);
                    },
                    onRemove: function (evt) {
                        const column = evt.from.closest('.kanban-column');
                        updateEmptyDropzoneState(column);
                    }
                });
            }

            select.addEventListener('change', e => {
                renderSortedProjects(e.target.value);
            });

            renderSortedProjects();

            return col;
        }
        function onCardDrop(cardElement, sourceColumnElement, targetColumnElement) {
            const sourceStatus = sourceColumnElement.dataset.status;
            const targetStatus = targetColumnElement.dataset.status;

            const cardId = cardElement.dataset.id;
            // پیدا کردن کارت و حذف از ستون مبدا
            let movedItem = null;
            kanbanData[sourceStatus] = kanbanData[sourceStatus].filter(item => {
                if ((item.id) == cardId) {
                    movedItem = item;
                    return false;
                }
                return true;
            });
            // افزودن به ستون مقصد
            if (movedItem) {
                kanbanData[targetStatus].push(movedItem);
            }
        }
        function updateEmptyDropzoneState(columnElement) {
            const allProjectLists = columnElement.querySelectorAll('.project-list');

            allProjectLists.forEach(projectList => {
                if (projectList.children.length > 0) {
                    projectList.classList.remove('empty-dropzone');
                } else {
                    projectList.classList.add('empty-dropzone');
                }
            });
        }
        function rerenderColumn(statusKey) {
            const container = document.getElementById('kanban-container');
            const oldCol = container.querySelector(`.kanban-column[data-status="${statusKey}"]`);
            if (oldCol) {
                container.removeChild(oldCol);
            }

            const statusObj = statuses.find(s => s.key === statusKey);
            const label = statusObj?.label || statusKey;

            const newCol = createColumn(statusKey, label, kanbanData[statusKey]);
            container.appendChild(newCol);
        }

        window.addEventListener('DOMContentLoaded', () => {
            const container = document.getElementById('kanban-container');

            for (const [statusKey, items] of Object.entries(kanbanData)) {
                const statusObj = statuses.find(s => s.key === statusKey);
                const label = statusObj?.label || statusKey;
                container.appendChild(createColumn(statusKey, label, items));

            }
        });
    </script>
    <script>
        function showPhotos(projectTitle) {
            const samplePhotos = [
                { code: 'IMG001', description: 'عکس اول' },
                { code: 'IMG002', description: 'عکس دسته‌جمعی' },
                { code: 'IMG003', description: 'پشت‌صحنه' }
            ];

            const tbody = document.getElementById('photoTableBody');
            tbody.innerHTML = '';

            samplePhotos.forEach((photo, index) => {
                const tr = document.createElement('tr');

                tr.innerHTML = `
            <td>${photo.code}</td>
            <td>${photo.description}</td>
            <td>
                <input type="file" class="form-control form-control-sm" accept="image/*" 
                    onchange="handleImageUpload(this, ${index})">
            </td>
            <td id="preview-${index}">—</td>
            <td>
                <button class="btn btn-danger btn-sm d-none" id="deleteBtn-${index}" onclick="deletePreview(${index})">
                    <i class="bi bi-trash"></i> حذف
                </button>
            </td>
        `;

                tbody.appendChild(tr);
            });

            new bootstrap.Modal(document.getElementById('photoModal')).show();
        }

        function escapeHtml(text) {
            return text
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }
        function showFullDescription(desc) {
            const modalHtml = `
        <div class="modal fade" id="descModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">توضیح کامل</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div class="modal-body">
                <p class="text-muted">${desc}</p>
              </div>
            </div>
          </div>
        </div>
    `;

            // حذف قبلی و اضافه کردن جدید
            const oldModal = document.getElementById('descModal');
            if (oldModal) oldModal.remove();

            document.body.insertAdjacentHTML('beforeend', modalHtml);
            new bootstrap.Modal(document.getElementById('descModal')).show();
        }
        function handleImageUpload(input, index) {
            const file = input.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function (e) {
                const previewCell = document.getElementById(`preview-${index}`);
                previewCell.innerHTML = `
            <img src="${e.target.result}" alt="Preview" class="img-thumbnail" style="max-width: 100px;">
        `;
                document.getElementById(`deleteBtn-${index}`).classList.remove('d-none');
            };
            reader.readAsDataURL(file);
        }

        function deletePreview(index) {
            document.getElementById(`preview-${index}`).innerHTML = '—';
            document.getElementById(`deleteBtn-${index}`).classList.add('d-none');

            // پاک کردن فایل انتخاب‌شده (اختیاری)
            const input = document.querySelectorAll(`input[type="file"]`)[index];
            if (input) input.value = '';
        }
    </script>
    <%--اسکریپت لاگ ها--%>
    <script>
        const projectLogs = []; // این‌جا لاگ‌ها رو نگه می‌داریم

        function openLogsModal() {
            renderLogs();
            new bootstrap.Modal(document.getElementById('logsModal')).show();
        }

        function renderLogs() {
            const tbody = document.getElementById('logsTableBody');
            tbody.innerHTML = '';
            projectLogs.forEach(log => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
            <td>${log.user}</td>
            <td>${log.datetime}</td>
            <td>
              <div style="max-height: 2.8em; overflow: hidden; text-overflow: ellipsis;">
                ${escapeHtml(log.text)}
              </div>
              ${log.text.length > 50 ? `<button class="btn btn-link p-0" onclick="showFullDescription('${escapeHtml(log.text)}')">مشاهده کامل</button>` : ''}
            </td>
        `;
                tbody.appendChild(tr);
            });
        }

        function addLogEntry() {
            const text = document.getElementById('newLogText').value.trim();
            if (!text) return alert("لطفاً توضیح را وارد کنید");

            const now = new Date();
            const date = now.toLocaleDateString('fa-IR');
            const time = now.toLocaleTimeString('fa-IR');

            projectLogs.unshift({
                user: 'کاربر فعلی', // یا مقدار واقعی مثل: currentUser.name
                datetime: `${date} ${time}`,
                text: text
            });

            document.getElementById('newLogText').value = '';
            renderLogs();
        }

    </script>

    <%--اسکریپت چک لیست--%>
    <script>
        let draggedCard = null;
        let fromColumn = null;
        let toColumn = null;
        let sortableInstance = null;

        function setupChecklistModal() {
            const checklistModal = new bootstrap.Modal(document.getElementById('checklistModal'));
            const checklistSubmit = document.getElementById('checklistSubmit');
            const checklistCancel = document.getElementById('checklistCancel');
            const checklistForm = document.getElementById('checklistForm');

            // بررسی وضعیت چک‌باکس‌ها برای فعال/غیرفعال کردن دکمه ثبت
            checklistForm.addEventListener('change', () => {
                const allChecked = [...checklistForm.querySelectorAll('input[type="checkbox"]')].every(chk => chk.checked);
                checklistSubmit.disabled = !allChecked;
            });

            checklistSubmit.addEventListener('click', () => {
                if (draggedCard && toColumn) {
                    toColumn.appendChild(draggedCard); // کارت اصلی رو اضافه کن
                }
                onCardDrop(draggedCard, fromColumn, toColumn);
                cleanupChecklistState();
            });
            checklistCancel.addEventListener('click', () => {
                if (clonedCard && fromColumn) {
                    fromColumn.appendChild(clonedCard); // کپی کارت رو برگردون
                }
                onCardDrop(draggedCard, fromColumn, toColumn);
                cleanupChecklistState();
            });

            // اگه مودال بسته بشه بدون ثبت هم کارت برگرده
            document.getElementById('checklistModal').addEventListener('hidden.bs.modal', () => {
                if (clonedCard && fromColumn) {
                    fromColumn.appendChild(clonedCard);
                }
                cleanupChecklistState();
            });
        }
        function cleanupChecklistState() {
            draggedCard = null;
            fromColumn = null;
            toColumn = null;
            clonedCard = null;
        }
        window.addEventListener('DOMContentLoaded', () => {
            setupChecklistModal();

            // فرض بر اینه که sortable ها توی تابع createColumn ساخته شدن و گروه shared دارند.
            // اینجا به همه sortable ها اضافه می‌کنیم که هنگام انتقال کارت، مودال باز بشه.

            const allProjectLists = document.querySelectorAll('.project-list');

            allProjectLists.forEach(list => {
                new Sortable(list, {
                    group: 'shared',
                    animation: 150,
                    onStart: evt => {

                        draggedCard = evt.item;
                        fromColumn = evt.from;
                    },
                    onAdd: evt => {
                        draggedCard = evt.item;
                        toColumn = evt.to;
                        fromColumn = evt.from;


                        const targetCoolumn = evt.item.closest('.kanban-column');
                        const sourceColumn = fromColumn.closest('.kanban-column');

                        const sourceInfo = statuses.find(s => s.key === sourceColumn.dataset.status);

                        const targetInfo = statuses.find(s => s.key === targetCoolumn.dataset.status);

                        // حذف کارت از ستون جدید (تا وقتی چک لیست تایید نشده)
                        toColumn.removeChild(draggedCard);

                        // ذخیره نسخه کپی کارت (در صورت نیاز به برگردوندن)
                        clonedCard = draggedCard.cloneNode(true); // نسخه کپی برای برگردوندن
                        //اگر ستون چک لیست داشت نمایش بده در غیر اینصوررت جابجا بشه
                        if (targetInfo.sort > sourceInfo.sort && targetInfo.showCheckList) {
                            // ریست چک‌لیست
                            const checklistForm = document.getElementById('checklistForm');
                            checklistForm.reset();
                            document.getElementById('checklistSubmit').disabled = true;

                            const checklistModal = new bootstrap.Modal(document.getElementById('checklistModal'));
                            checklistModal.show();
                        }
                        else {
                            toColumn.appendChild(draggedCard); // کارت اصلی رو اضافه کن
                            onCardDrop(draggedCard, fromColumn, toColumn);
                        }
                    }
                });
            });
        });

    </script>
</asp:Content>

