<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="ManageProject.aspx.cs" Inherits="ManageProject" %>

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
                                <select id="filter_ProjectType">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Step_Photographi">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Step_Videographi">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Designer">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Photographer">
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-2">
                                <select id="filter_VideoGrapher">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="filter_Editor">
                                </select>
                            </div>
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_Bedehkar" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">خانواده های بدهکار</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="filter_ProjectForce" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">انجام فورس</span>
                                    </label>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="row mt-3">
                       <div class="kanban-board">
    <script>
        const statuses = [
            { key: 'not_started', label: 'شروع نشده', color: '#6c757d' },
            { key: 'in_progress', label: 'در حال انجام', color: '#0d6efd' },
            { key: 'pending_payment', label: 'در انتظار تسویه', color: '#ffc107' },
            { key: 'ready_for_design', label: 'آماده طراحی و تدوین', color: '#20c997' },
            { key: 'successful', label: 'موفق', color: '#198754' },
            { key: 'failed', label: 'ناموفق', color: '#dc3545' }
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
    <div class="modal fade" id="failureReasonModal" tabindex="-1" aria-labelledby="failureReasonLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="failureReasonLabel">علت عدم موفقیت پروژه</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
      </div>
      <div class="modal-body">
        <textarea id="failureReasonInput" class="form-control" rows="4" placeholder="لطفاً علت عدم موفقیت پروژه را وارد کنید..."></textarea>
        <input type="hidden" id="failureProjectInfo">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">انصراف</button>
        <button type="button" class="btn btn-danger" id="confirmFailureReason">ثبت علت و انتقال</button>
      </div>
    </div>
  </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
   

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>
        const kanbanData = {
            not_started: [
                { title: 'پروژه پهلوان', family: 'پهلوان', date: '1402/04/01', urgent: false, debt: true, debtAmount: 6500000 },
                { title: 'پروژه نوزادی', family: 'احمدی', date: '1403/04/01', urgent: false, debt: false },
                { title: 'پروژه نوزادی2', family: 'مرادی', date: '1403/03/01', urgent: false, debt: true, debtAmount: 2300000},

            ],
            in_progress: [
                { title: 'پروژه عروسی', family: 'کریمی', date: '1403/04/10', urgent: true, debt: false},
                { title: 'پروژه تولد', family: 'احمدی', date: '1403/05/10', urgent: true, debt: false },
                { title: 'فرمالیته', family: 'نعمتی', date: '1403/05/10', urgent: true, debt: true, debtAmount: 3500000},
                { title: 'دندونی', family: 'کواکبیان', date: '1403/05/10', urgent: true, debt: false }
            ],
            pending_payment: [
                { title: 'پروژه فارغ‌التحصیلی', family: 'جعفری', date: '1403/03/29', urgent: false, debt: true, debtAmount: 2560000}
            ],
            ready_for_design: [
                { title: 'پروژه تبلیغاتی', family: 'قاسمی', date: '1403/04/02', urgent: false, debt: true, debtAmount: 7500000}
            ],
            successful: [
                { title: 'پروژه خانوادگی', family: 'نصیری', date: '1403/02/22', urgent: false, debt: true, debtAmount: 2800000 }
            ],
            failed: [
                { title: 'پروژه صنعتی', family: 'ملکی', date: '1403/03/15', urgent: false, debt: true, debtAmount: 7500000 }
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
            card.setAttribute('data-id', item.id || Math.random());
            card.innerHTML = `
        <div class="project-days">+15</div>
        <h6>${item.title}</h6>
        <p>خانواده ${item.family} - شروع: ${item.date}</p>
        <p>آماده‌سازی عکس: مرحله 1</p>
        <p>آماده‌سازی فیلم: ندارد</p>
        <p>طراح: ---</p>
        <p>تدوینگر: ---</p>
        ${item.urgent ? '<span class="urgent-label">فوری</span>' : ''}
        <div class="project-footer">
          ثبت توسط: مدیر سیستم - ۱۴۰۳/۰۳/۱۰ ساعت ۱۰:۳۰
          ${item.debt ? `<span class="badge bg-danger" data-amount="${item.debtAmount}">${`مبلغ بدهی: ${Number(item.debtAmount).toLocaleString()} تومان`}</span>` : ''}
        </div>`;
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
        <div id="${statusKey}" class="kanban-content p-2 overflow-auto"></div>
      `;

            const container = col.querySelector(`#${statusKey}`);
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

                    monthItems.forEach(item => projectList.appendChild(createCard(item)));
                    monthDiv.appendChild(monthHeader);
                    monthDiv.appendChild(projectList);
                    container.appendChild(monthDiv);

                    setTimeout(() => {
                        new Sortable(projectList, {
                            group: 'shared',
                            animation: 150,
                            onEnd: evt => console.log(`Moved from ${evt.from.id} to ${evt.to.id}`),
                            onAdd: function (evt) {
                                const toColumnKey = evt.to.closest('[data-status]').dataset.status;
                                const fromColumnKey = evt.from.closest('[data-status]').dataset.status;
                                const draggedEl = evt.item;

                                if (toColumnKey === 'failed') {
                                    const projectId = draggedEl.dataset.id || Math.random(); // باید در کارت پروژه data-id تعریف شده باشه

                                    document.getElementById('failureProjectInfo').value = JSON.stringify({
                                        elementHTML: draggedEl.outerHTML,
                                        from: fromColumnKey,
                                        to: toColumnKey,
                                        originalIndex: evt.oldIndex
                                    });

                                    // حذف موقت کارت از ستون مقصد
                                    draggedEl.remove();

                                    // باز کردن مودال علت
                                    new bootstrap.Modal(document.getElementById('failureReasonModal')).show();
                                }
                            }
                        });
                    }, 0);
                }
            }

            select.addEventListener('change', e => {
                renderSortedProjects(e.target.value);
            });

            renderSortedProjects();
            return col;
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
        document.getElementById('confirmFailureReason').addEventListener('click', function () {
            const reason = document.getElementById('failureReasonInput').value.trim();
            const info = JSON.parse(document.getElementById('failureProjectInfo').value);

            if (!reason) {
                alert('لطفاً علت را وارد کنید');
                return;
            }

            // افزودن کارت به ستون مقصد
            const targetColumn = document.querySelector(`[data-status="${info.to}"] .project-list`) || document.querySelector(`[data-status="${info.to}"]`);
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = info.elementHTML;
            const restoredCard = tempDiv.firstElementChild;

            // می‌تونی لاگ یا اتریبیوت علت را هم اضافه کنی
            restoredCard.setAttribute('data-failure-reason', reason);

            targetColumn.appendChild(restoredCard);

            document.getElementById('failureReasonInput').value = '';
            bootstrap.Modal.getInstance(document.getElementById('failureReasonModal')).hide();
        });
    </script>
</asp:Content>

