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
            border: 2px dashed #ced4da;
            background-color: #f8f9fa;
            border-radius: 10px;
            min-height: 100px;
            padding: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 0.9rem;
            text-align: center;
            transition: background-color 0.3s ease;
        }

            .empty-dropzone:hover {
                background-color: #e2e6ea;
            }

        .project-card .card-actions button {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
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

         .labels-wrapper {
            position: absolute;
            top: 0;
            right: 22px;
            display: flex;
            flex-wrap: wrap;

            gap: 4px; /* فاصله بین لیبل‌ها */
            z-index: 10;
        }

        .urgent-label {
            position: absolute;
            top: 0;
            right: 22px;
            padding: 0.2rem 0.3rem;
            background-color: #f8a521;
            color: white;
            border-bottom-left-radius: 8px;
            font-size: 0.85rem;
        }

        .card-actions {
            position: absolute;
            top: 8px;
            gap: 4px;
            display: flex;
            left: 8px;
            z-index: 20;
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
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="filter_From_Date" placeholder="از تاریخ" required />
                            </div>
                            <div class="col-md-2">
                                <input class="form-control datepicker selectedDateWithoutInitialValue" id="filter_To_Date" placeholder="تا تاریخ" required />
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
                                <button onclick="reloadPage();" id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
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
                            <div id="kanban-container" class="d-flex gap-3 w-100"></div>
                        </div>
                        <button class="btn btn-sm btn-light w-100 mt-2" onclick="openSMSModal()" style="display: none">ارسال پیامک</button>
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
    <div class="modal fade" id="checklistModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">تکمیل چک‌ لیست انتقال پروژه</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                </div>
                <div class="modal-body">
                    <form id="checklistForm">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" id="checklistCancel" class="btn btn-secondary" data-bs-dismiss="modal">لغو</button>
                    <button type="button" onclick="checklistSubmitClicked(this);" class="btn btn-primary">ثبت</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal برای دلیل عدم موفقیت -->
    <div class="modal fade" id="failedReasonModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">علت عدم موفقیت پروژه</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="failedReasonForm">
                        <div class="mb-3">
                            <label for="failedReasonSelect" class="form-label">علت:</label>
                            <select class="form-select" id="failedReasonSelect" required>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="reasonText" class="form-label">توضیحات تکمیلی:</label>
                            <textarea class="form-control" id="reasonText" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" id="cancelFailedMove" class="btn btn-secondary" data-bs-dismiss="modal">لغو</button>
                    <button type="button" id="confirmFailedMove" class="btn btn-danger">تایید</button>
                </div>
            </div>
        </div>
    </div>
    <%--<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>--%>
    <script src="assets/js/cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    <%--<script src="https://cdn.jsdelivr.net/npm/jalaali-js/dist/jalaali.min.js"></script>--%>
    <script src="assets/js/cdn.jsdelivr.net/npm/jalaali-js/dist/jalaali.min.js"></script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script>
        let statuses = [];
        //const statuses =
        //[
        //    { key: 'not_started', label: 'شروع نشده', color: '#6c757d' },
        //    { key: 'in_progress', label: 'در حال انجام', color: '#0d6efd' },
        //    { key: 'pending_payment', label: 'در انتظار تسویه', color: '#ffc107' },
        //    { key: 'ready_for_design', label: 'آماده طراحی و تدوین', color: '#20c997' },
        //    { key: 'successful', label: 'موفق', color: '#198754' },
        //    { key: 'failed', label: 'ناموفق', color: '#dc3545' }
        //];
        $(document).ready(function () {
            $("#master_PageTitle").text("مدیریت پروژه");
        });

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
            card.setAttribute('data-id', item.id);
            card.innerHTML = `

        ${item.urgent ? '<div class="labels-wrapper"><span class="badge-label urgent-label">فوری</span></div>' : ''}
            
          <div class="card-actions">
                <button onclick="btnEditProjectClicked('${item.id}');" class="btn btn-light-primary btn-sm btn-icon" title="ویرایش">
                    <i class="bi bi-pencil"></i>
                </button>
                <button onclick="btnDeleteProjectClicked('${item.id}');" class="btn btn-light-danger btn-sm btn-icon" title="حذف">
                    <i class="bi bi-trash"></i>
                </button>
            </div>
        <div class="project-days">${(item.remindDays > 0 ? '+' : item.remindDays < 0 ? '-' : '')}${item.remindDays}</div>
        <h6>${item.title}</h6>
        <p>خانواده ${item.family} - شروع: ${item.date}</p>
        <p>آماده‌سازی عکس: ${item.designerStep}</p>
        <p>آماده‌سازی فیلم: ${item.editorStep}</p>
        <p>طراح: ${item.designer}</p>
        <p>تدوینگر: ${item.editor}</p>
       
        <div class="project-footer">
          ثبت توسط: ${item.creator} - ${item.creationDate} ساعت ${item.creationTime}
         ${item.debt ? `<span class="badge bg-danger" data-amount="${item.debtAmount}">${`بدهی: ${Number(item.debtAmount).toLocaleString()} تومان`}</span>` : ''}
            <div class="d-flex align-items-center gap-2 flex-nowrap">
                <button onclick="btnChecklistClicked('${item.id}');" class="btn btn-sm btn-light-info" data-bs-toggle="modal" data-bs-target="#checklistModal">
                    <i class="bi bi-check2"></i> چک لیست
                </button>
                <button class="btn btn-sm btn-light-primary" onclick="modalBeianeClicked('${item.id}');">
                    <i class="bi bi-currency-dollar"></i> بیعانه
                </button>
                <button class="btn btn-sm btn-light-primary" onclick="window.open('AddEditFactor.aspx?projectId=${item.id}', '_blank');">
                    <i class="bi bi-list"></i> ثبت فاکتور
                </button>
                
            </div>
        </div>`;
            return card;
        }
        let selectedProjectIdForCheckList = '';
        function btnChecklistClicked(projectId) {
            selectedProjectIdForCheckList = projectId;
            let query = `?ProjectId=${projectId}`;
            let route = '/Project/GetCheckList';

            ajaxGet(route + query, function (items) {

                let html = items.map(item =>
                    `
                        <div class="d-flex align-items-center mb-2" style="font-size: 14px;">
                            <input type="checkbox" id="${item.itemId}" ${(item.isDone ? "checked" : "")} class="form-check-input me-2" style="width: 16px; height: 16px;">
                            <label for="${item.itemId}" class="form-check-label">${item.title}</label>
                        </div>
                    `
                ).join('');

                $('#checklistForm').html(html);
            }, function (err) {
                ShowError("خطا در دریافت اطلاعات");
            });
        }

        function modalBeianeClicked(projectId) {
            showModalBeiane('', projectId);
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

        function createColumn(statusKey, label, items, isFailed) {
            const col = document.createElement('div');
            col.className = 'kanban-column';
            col.dataset.status = statusKey;
            col.dataset.failed = isFailed;
            const status = statuses.find(s => s.key === statusKey);
            col.innerHTML = `
        <div class="kanban-header" style="background-color: ${status.color};">
            <h5>${label} (${items.length})</h5>
            <button class="btn btn-sm btn-light w-100 mt-2" onclick="openSMSModal()">ارسال پیامک</button>
            <button class="refreshColumn"  style="display: none">رفرش ستون</button>
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
            const refreshcolumn = col.querySelector('.refreshColumn');

            function renderSortedProjects(order = '') {
                container.innerHTML = '';
                let sortedItems = [...items];

                if (order === 'asc') {
                    sortedItems.sort((a, b) => a.date.localeCompare(b.date));
                } else if (order === 'desc') {
                    sortedItems.sort((a, b) => b.date.localeCompare(a.date));
                }

                const monthGroups = groupByMonth(sortedItems);

                if (sortedItems.length === 0) {
                    // ساختن دراپ‌زون خالی
                    const emptyList = document.createElement('div');
                    emptyList.className = 'project-list empty-dropzone';
                    emptyList.dataset.status = statusKey;
                    emptyList.dataset.failed = isFailed;

                    container.appendChild(emptyList);

                    new Sortable(emptyList, {
                        group: 'shared',
                        animation: 150,
                        onAdd: function (evt) {
                            const card = evt.item;
                            const source = evt.from.closest('.kanban-column');
                            const target = evt.to.closest('.kanban-column');
                            updateEmptyDropzoneState(source);
                            updateEmptyDropzoneState(target);
                            onCardDrop(card, source, target);
                        },
                        onRemove: function (evt) {
                            const column = evt.from.closest('.kanban-column');
                            updateEmptyDropzoneState(column);
                        }
                    });

                    return;
                }

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
                    projectList.dataset.failed = isFailed;

                    monthItems.forEach(item => projectList.appendChild(createCard(item)));

                    monthDiv.appendChild(monthHeader);
                    monthDiv.appendChild(projectList);
                    container.appendChild(monthDiv);

                    new Sortable(projectList, {
                        group: 'shared',
                        animation: 150,
                        onAdd: function (evt) {
                            const card = evt.item;

                            const source = evt.from.closest('.kanban-column');
                            const target = evt.to.closest('.kanban-column');
                            updateEmptyDropzoneState(source);
                            updateEmptyDropzoneState(target);
                            onCardDrop(card, source, target);
                        },
                        onRemove: function (evt) {
                            const column = evt.from.closest('.kanban-column');
                            updateEmptyDropzoneState(column);
                        }
                    });
                }
            }

            select.addEventListener('change', e => {
                renderSortedProjects(e.target.value);
            });
            refreshcolumn.addEventListener('click', e => {
                renderSortedProjects('');
            });


            renderSortedProjects();

            return col;
        }

        //function onCardDrop(cardElement, sourceColumnElement, targetColumnElement) {
        //    // انتقال کارت به ستون جدید
        //    const targetList = targetColumnElement.querySelector(".project-list");
        //    targetList.appendChild(cardElement);

        //    // آپدیت وضعیت ستون مبدا و مقصد
        //    updateEmptyDropzoneState(sourceColumnElement);
        //    updateEmptyDropzoneState(targetColumnElement);
        //}
        function onCardDrop(cardElement, sourceColumnElement, targetColumnElement) {
            const targetStatus = targetColumnElement.dataset.status;
            const targetStatusFailed = targetColumnElement.dataset.failed;
            let projectId = $(cardElement).attr('data-id');

            //Tips
            //این کدها واسه ستون ناموفق هست که پاپ اپ علت رو نمایش میده
            if (targetStatusFailed === true || targetStatusFailed === "true") {
                // نمایش مودال و ذخیره اطلاعات موقت
                const failedModal = new bootstrap.Modal(document.getElementById('failedReasonModal'));
                showFailedModalData(projectId);
                failedModal.show();

                // ذخیره مبدأ و کارت برای استفاده بعد
                window._dragContext = {
                    cardElement,
                    sourceColumnElement,
                    targetColumnElement,
                    failedModal
                };
            }
            else {

                let failedAction = function () {
                    setTimeout(function () {
                        window.location.reload();
                    }, 1001);
                };

                let changeProjectStatusCommand =
                {
                    id: projectId,
                    statusId: targetStatus
                };

                let route = '/Project/ChangeStatus';
                ajaxAuthCall('PATCH', route, changeProjectStatusCommand, function (res) {
                    if (!res.success) {
                        ShowError(res.message);
                        failedAction();
                        return;
                    }

                    // انتقال معمولی
                    const targetList = targetColumnElement.querySelector(".project-list");
                    targetList.appendChild(cardElement);
                    updateEmptyDropzoneState(sourceColumnElement);
                    updateEmptyDropzoneState(targetColumnElement);
                    //قبل از اینکه اینجا بخواد ستون هارو رفرش کنه باید در لیست kanbanData جابجایی بین ستون ها انجام بشه
                    //چون داره از ستون های میخونه و در ستون ها نمایش میده
                    //Tips
                    const refreshColumn_source = sourceColumnElement.querySelector('.refreshColumn');
                    const refreshColumn_target = targetColumnElement.querySelector('.refreshColumn');
                    //refreshColumn_source.click();
                    //refreshColumn_target.click();

                }, function (err) {
                    console.log(err);
                    failedAction();
                });



                window._dragContext = {
                    cardElement,
                    sourceColumnElement,
                    targetColumnElement,
                    failedModal: true
                };
            }
        }

        function showFailedModalData(projectId) {
            projectFailedingId = projectId;
            const defaultOption = '<option value="">انتخاب علت عدم موفقیت</option>';
            ajaxGet('/BasicData/FailedProjectReasons', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#failedReasonSelect').html(defaultOption + options);
            });
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

        async function getStatusesAsync() {
            let route = '/ProjectStatus/GetAllProjectStatuses';
            await ajaxGet(route, function (items) {
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    statuses.push({
                        key: item.id,
                        label: item.title,
                        color: item.color,
                        isFailed: item.failed
                    });
                }

            });
        }

        window.addEventListener('DOMContentLoaded', async () => {

            showProgress();

            await fillAllFiltersAsync();
            await getStatusesAsync();

            const kanbanData = {};
            statuses.forEach((status) => {
                if (!kanbanData[status.key]) {
                    kanbanData[status.key] = [];
                }
            });

            setPageQuery();

            let query = getPageQuery();
            let route = '/Project/GetAllProjectsWithDetail';
            await ajaxGet(route + query, function (res) {

                if (!res.success) {
                    ShowError(res.message);
                    return;
                }
                const data = res.data;


                data.forEach((item) => {
                    kanbanData[item.statusId].push(item);
                });


                const container = document.getElementById('kanban-container');
                for (const [statusKey, items] of Object.entries(kanbanData)) {
                    const statusObj = statuses.find(s => s.key === statusKey);
                    const label = statusObj?.label || statusKey;
                    container.appendChild(createColumn(statusKey, label, items, statusObj.isFailed));
                }
            });

            hideProgress();
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
    <script>
        let projectFailedingId = '';
        document.getElementById('confirmFailedMove').addEventListener('click', () => {
            const failedReasonId = document.getElementById('failedReasonSelect').value;
            const desc = document.getElementById('reasonText').value;

            if (!failedReasonId) {
                toastr.warning('لطفاً علت علت عدم موفقیت پروژه را انتخاب کنید', 'علت عدم موفقیت');
                return;
            }

            let failedProjectCommand =
            {
                id: projectFailedingId,
                isFailed: true,
                desc: desc,
                failedReasonId
            };
            let route = '/Project/Failed';
            ajaxAuthCall('PATCH', route, failedProjectCommand, function (res) {
                if (!res.success) {
                    ShowError(res.message);
                    return;
                }
                //toastr.success('نوبت از حالت لغو خارج شد', "موفق");


                const { cardElement, sourceColumnElement, targetColumnElement, failedModal } = window._dragContext;
                // انتقال کارت
                const targetList = targetColumnElement.querySelector(".project-list");
                targetList.appendChild(cardElement);
                updateEmptyDropzoneState(sourceColumnElement);
                updateEmptyDropzoneState(targetColumnElement);

                failedModal.hide();
                window._dragContext = null;


            }, function (err) {
                console.log(err);
            });
        });

        document.getElementById('cancelFailedMove').addEventListener('click', () => {
            const { cardElement, sourceColumnElement, targetColumnElement } = window._dragContext;

            // بازگرداندن کارت به ستون مبدأ
            const sourceList = sourceColumnElement.querySelector(".project-list");
            sourceList.appendChild(cardElement);
            updateEmptyDropzoneState(sourceColumnElement);
            updateEmptyDropzoneState(targetColumnElement);

            window._dragContext = null;
        });

    </script>

    <script>
        function btnEditProjectClicked(projectId) {
            window.open("AddEditProject.aspx?id=" + projectId, '_blank');
        }

        function btnDeleteProjectClicked(projectId) {
            const userResponse = confirm("آیا از حذف پروژه مطمئن هستید؟");
            if (userResponse) {
                let query = `?id=${projectId}`;
                ajaxDelete('/Project/Delete' + query, function (res) {
                    if (res.success) {
                        reloadPage();
                    }
                    else {
                        ShowError(res.message);
                    }
                },
                    function () {
                        toastr.error("خطا در حذف اطلاعات", "خطا");
                    });
            }
        }
    </script>
    <script>
        function reloadPage() {
            window.location = window.location.pathname + getPageQuery();
        }
        function getPageQuery() {
            let query = '?a=1';

            let familyId = $('#filter_Family').val();
            if (familyId && familyId != '0') {
                query += `&familyId=${familyId}`;
            }

            let projectTypeId = $('#filter_ProjectType').val();
            if (projectTypeId) {
                query += `&projectTypeId=${projectTypeId}`;
            }

            let designerId = $('#filter_Designer').val();
            if (designerId) {
                query += `&designerId=${designerId}`;
            }

            let photographerId = $('#filter_Photographer').val();
            if (photographerId) {
                query += `&photographerId=${photographerId}`;
            }

            let videographerId = $('#filter_VideoGrapher').val();
            if (videographerId) {
                query += `&videographerId=${videographerId}`;
            }

            let editorId = $('#filter_Editor').val();
            if (editorId) {
                query += `&editorId=${editorId}`;
            }

            let designerStep = $('#filter_Step_Photographi').val();
            if (designerStep) {
                query += `&designerStep=${designerStep}`;
            }

            let editorStep = $('#filter_Step_Videographi').val();
            if (editorStep) {
                query += `&editorStep=${editorStep}`;
            }

            let fromDate = $('#filter_From_Date').val();
            if (fromDate) {
                query += `&fromDate=${encodeURIComponent(fromDate)}`;
            }

            let toDate = $('#filter_To_Date').val();
            if (toDate) {
                query += `&toDate=${encodeURIComponent(toDate)}`;
            }

            return query;
        }
        function setPageQuery() {
            let params = new URLSearchParams(document.location.search);

            let familyId = params.get("familyId");
            if (familyId) {
                $('#filter_Family').val(familyId);
            }

            let projectTypeId = params.get("projectTypeId");
            if (projectTypeId) {
                $('#filter_ProjectType').val(projectTypeId);
            }

            let designerId = params.get("designerId");
            if (designerId) {
                $('#filter_Designer').val(designerId);
            }

            let photographerId = params.get("photographerId");
            if (photographerId) {
                $('#filter_Photographer').val(photographerId);
            }

            let videographerId = params.get("videographerId");
            if (videographerId) {
                $('#filter_VideoGrapher').val(videographerId);
            }

            let editorId = params.get("editorId");
            if (editorId) {
                $('#filter_Editor').val(editorId);
            }

            let designerStep = params.get("designerStep");
            if (designerStep) {
                $('#filter_Step_Photographi').val(designerStep);
            }

            let editorStep = params.get("editorStep");
            if (editorStep) {
                $('#filter_Step_Videographi').val(editorStep);
            }

            let fromDate = params.get("fromDate");
            if (fromDate) {
                $('#filter_From_Date').val(fromDate);
            }

            let toDate = params.get("toDate");
            if (toDate) {
                $('#filter_To_Date').val(toDate);
            }
        }
    </script>

    <script>
        async function fillAllFiltersAsync() {
            let today = getToday();
            let fromDate = today.substr(0, 4) + "/01/01";
            let toDate = today.substr(0, 4) + "/12/29";
            $('#filter_From_Date').val(convertEnglishToPersianNumbers(fromDate));
            $('#filter_To_Date').val(convertEnglishToPersianNumbers(toDate));

            await Promise.all([
                fillProjectTypesAsync(),
                fillFamiliesAsync(),
                fillDesignersAsync(),
                fillEditorsAsync(),
                fillPhotographersAsync(),
                fillVideographersAsync(),
                fillDesignerStepsAsync(),
                fillEditorStepsAsync()
            ]);
        }
        async function fillVideographersAsync() {
            const defaultOption = '<option value="">انتخاب فیلم بردار</option>';
            await ajaxGet('/User/GetAllVideographers', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#filter_VideoGrapher').html(defaultOption + options);
            });
        }
        async function fillPhotographersAsync() {
            const defaultOption = '<option value="">انتخاب عکاس</option>';
            await ajaxGet('/User/GetAllPhotographers', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#filter_Photographer').html(defaultOption + options);
            });
        }
        async function fillProjectTypesAsync() {
            const defaultOption = '<option value="">انتخاب نوع پروژه</option>';
            await ajaxGet('/BasicData/ProjectTypes', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#filter_ProjectType').html(defaultOption + options);
            });
        }
        async function fillDesignersAsync() {
            const defaultOption = '<option value="">انتخاب طراح</option>';
            await ajaxGet('/User/GetAllDesigners', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#filter_Designer').html(defaultOption + options);
            });
        }
        async function fillEditorsAsync() {
            const defaultOption = '<option value="">انتخاب تدوینگر</option>';
            await ajaxGet('/User/GetAllEditors', function (items) {
                let options = items.map(item =>
                    `<option value='${item.id}'>${item.title}</option>`
                ).join('');
                $('#filter_Editor').html(defaultOption + options);
            });
        }
        async function fillFamiliesAsync() {
            const defaultOption = '<option value="0">انتخاب مشتری</option>';
            await ajaxGet('/Family/GetAllFamilies', function (families) {
                const options = families.map(family =>
                    `<option value="${family.id}">${family.title}</option>`
                ).join('');
                $('#filter_Family').html(defaultOption + options);
            });
        }
        async function fillDesignerStepsAsync() {
            const defaultOption = '<option value="">مرحله طراحی</option>';
            await ajaxGet('/BasicData/GetDesignerSteps', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');
                $('#filter_Step_Photographi').html(defaultOption + options);
            });
        }
        async function fillEditorStepsAsync() {
            const defaultOption = '<option value="">مرحله فیلم برداری</option>';
            await ajaxGet('/BasicData/GetEditorSteps', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');
                $('#filter_Step_Videographi').html(defaultOption + options);
            });
        }
    </script>

    <script>
        function checklistSubmitClicked(button) {
            let projectId = selectedProjectIdForCheckList;
            if (!projectId) {
                toastr.error('شناسه پروژه سمت کلاینت یافت نشد!');
                return;
            }
            let data = [];
            $('#checklistForm input').each(function () {

                data.push({
                    id: this.id,
                    isDone: $(this).is(':checked')
                });
            });

            let checkListDoneCommand =
            {
                items: data,
                projectId: projectId
            };

            let btn = $(button);
            let defaultText = btn.html();
            function setDisable() {
                btn.attr('disabled', 'disabed');
                btn.html('لطفاً منتظر بمانید ...');
            }
            function setEnable() {
                btn.removeAttr('disabled');
                btn.html(defaultText);
            }
            setDisable();

            let method = 'PUT';
            let route = '/Project/SetCheckListDone';

            ajaxAuthCall(method, route, checkListDoneCommand, function (res) {
                if (res.success) {
                    setEnable();
                    $('#checklistModal').modal('hide');
                    toastr.success("ذخیره چک لیست با موفقیت انجام شد");
                } else {
                    ShowError(res.message);
                    setEnable();
                }
            }, function (err) {
                console.log(err);
                setEnable();
            });
        }
    </script>

</asp:Content>

