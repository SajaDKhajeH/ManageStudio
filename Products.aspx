<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="AdakStudio.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">

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
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="text" id="filterInput" class="form-control" placeholder="جستجو...">
                                </div>
                                <div class="col-md-2">
                                    <select id="filter_productgroup">
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button id="filterBtn" class="btn btn-bg-warning w-100">اعمال فیلتر</button>
                                </div>
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-primary me-2 open-modal-btn" onclick="openModalProduct()" data-bs-toggle="modal" data-bs-target="#addEditProducts" id="openModalBtn">افزودن کالا</button>
                                </div>
                            </div>

                            <table class="table table-striped table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th data-priority="1">گروه کالا</th>
                                        <th class="min-w-150px">عنوان</th>
                                        <th id="buyPriceLabel" class="min-w-150px">قیمت خرید</th>
                                        <th id="sellPriceLabel" class="min-w-150px">قیمت فروش</th>
                                        <th class="min-w-100px">موجودی چک شود؟</th>
                                        <th class="min-w-100px">موجودی</th>
                                        <th class="min-w-70px">وضعیت</th>
                                        <th class="min-w-110px">عملیات</th>
                                    </tr>
                                </thead>
                                <tbody id="dt_Products">
                                    <!-- داده‌ها به صورت داینامیک اضافه می‌شوند -->
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center">
                                <button id="prevPageBtn" class="btn btn-secondary">صفحه قبل</button>
                                <span>صفحه فعلی: <span id="pageIndex" class="fw-bold">1</span></span>
                                <span>تعداد کل رکوردها: <span id="countAllTable" class="fw-bold">0</span></span>
                                <span>
                                    <select data-control="select" class="form-select" id="s_pageSize" onchange="loadTableDataProduct()">
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
    <div class="modal fade" id="addEditProducts">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bolder" id="header_modalSetProduct">ثبت کالا</h2>
                    <div id="closeModalBtnRequestModals" onclick="closeModalProduct()" class="btn btn-icon btn-sm btn-active-icon-primary">
                        <span class="svg-icon svg-icon-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect opacity="0.5" x="6" y="17.3137" width="16" height="2" rx="1" transform="rotate(-45 6 17.3137)" fill="black" />
                                <rect x="7.41422" y="6" width="16" height="2" rx="1" transform="rotate(45 7.41422 6)" fill="black" />
                            </svg>
                        </span>
                    </div>
                </div>
                <div class="modal-body py-10 px-lg-20">
                    <div class="scroll-y me-n7 pe-7" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-offset="300px">
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>گروه کالا</label>
                                <select id="p_productgroup" onchange="GetLastPariority()">
                                </select>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>عنوان</label>
                                <input id="p_Title" maxlength="59" class="form-control form-control-solid" placeholder="عنوان کالا" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>قیمت خرید</label>
                                <input id="p_buyPrice" type="text" maxlength="59" onkeyup="TextFormatPrice(this)" class="form-control form-control-solid" placeholder="قیمت خرید" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>قیمت فروش</label>
                                <input id="p_salePrice" type="text" maxlength="59" onkeyup="TextFormatPrice(this)" class="form-control form-control-solid" placeholder="قیمت فروش" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="p_checkInventory" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">موجودی کالا چک شود؟</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <label>موجودی کالا</label>
                                <input id="p_Inventory" type="number" maxlength="59" class="form-control form-control-solid" placeholder="موجودی" />
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <label>ترییب نمایش براساس گروه کالا</label>
                                <input id="p_pariority" type="number" maxlength="59" class="form-control form-control-solid" placeholder="ترتیب نمایش" />
                            </div>
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="p_active" class="form-check-input" type="checkbox" />
                                        <span class="form-check-label fw-bold text-dark">فعال</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row g-9 mb-7">
                            <div class="col-md-12 fv-row">
                                <label>توضیحات</label>
                                <textarea style="margin: 3px" placeholder="توضیحات" class="form-control" id="p_desc"></textarea>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- دکمه‌های پایین مدال -->
                <div class="modal-footer flex-center">
                    <button id="btn_AddEditProduct" onclick="AddEditProduct()">ذخیره</button>
                    <button class="btn btn-light me-3" onclick="closeModalProduct()">بستن</button>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="server">
    <script type="text/javascript">
        var productId = '';
        // باز کردن مدال
        function openModalProduct() {
            productId = '';
            $("#header_modalSetProduct").text("ثبت کالا ");
            btnAddEdit_ChangeDisable("btn_AddEditProduct", false);
            document.getElementById("addEditProducts").style.display = "flex";
            document.getElementById("p_Title").value = "";
            document.getElementById("p_buyPrice").value = "0";
            document.getElementById("p_salePrice").value = "0";
            document.getElementById("p_pariority").value = "1";
            document.getElementById("p_desc").value = "";
            document.getElementById("p_Inventory").value = "0";
            GetLastPariority();
            $("#p_checkInventory").prop("checked", false);
            $("#p_active").prop("checked", true);

        };
        function closeModalProduct() {
            $('#addEditProducts').modal('hide');
            productId = '';
        };
        function GetInfoForEditProduct(id) {
            productId = id;
            let query = `?id=${productId}`;
            ajaxGet('/Product/GetProduct' + query, function (res) {
                if (res.success) {
                    let data = res.data;
                    $("#p_productgroup").val(data.groupId);
                    $("#p_Title").val(data.title);
                    $("#p_buyPrice").val(CurrencyFormatted(data.buyPrice));
                    $("#p_salePrice").val(CurrencyFormatted(data.salePrice));
                    $("#p_pariority").val(data.priority);
                    $("#p_Inventory").val(data.inventory);
                    $("#p_checkInventory").prop("checked", data.checkInventory);
                    $("#p_active").prop("checked", data.active);
                    $("#p_desc").val(data.desc);
                    $("#header_modalSetProduct").text("ویرایش " + data.title);
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
                toastr.error("خطا در دریافت اطلاعات", "خطا");
            });
        };

        function GetLastPariority() {
            var gproduct = document.getElementById("p_productgroup").value;
            //$.ajax({
            //    type: "POST",
            //    url: "Products.aspx/GetLastPariority",
            //    data: JSON.stringify({
            //        gproduct: gproduct
            //    }),
            //    contentType: "application/json; charset=utf-8",
            //    dataType: "json",
            //    success: function (msg) {
            //        document.getElementById("p_pariority").value = msgُ.d.lastPari;
            //    },
            //    error: function () {
            //        toastr.error("خطا در دریافت اولویت ", "خطا");
            //    }
            //});
        };
        $(document).ready(function () {
            $("#buyPriceLabel").text(`قیمت خرید(${currency})`);
            $("#sellPriceLabel").text(`قیمت فروش(${currency})`);
            $("#master_PageTitle").text("کالاها");
            $("#s_pageSize").val("5");
            fillProductGroupsAsync();
            loadTableDataProduct();
            // صفحه بعد
            $("#nextPageBtn").click(function () {
                pageIndex++;
                loadTableDataProduct();
            });

            // صفحه قبل
            $("#prevPageBtn").click(function () {
                pageIndex--;
                loadTableDataProduct();
            });

            // اعمال فیلتر
            $("#filterBtn").click(function () {
                pageIndex = 0;
                loadTableDataProduct();
            });
        });
    </script>
    <script>
        let pageIndex = 0;
        let pageSize = 5;

        function loadTableDataProduct() {
            var filter = $("#filterInput").val();
            var groupId = $("#filter_productgroup").val();
            if (groupId == null || groupId == undefined) {
                groupId = 0;
            }
            pageSize = parseInt($("#s_pageSize").val());
            const tbody = $("#dt_Products");
            tbody.empty();
            let query = `?pageIndex=${pageIndex}&pageSize=${pageSize}&searchText=${filter}&groupId=${groupId}`;
            ajaxGet('/Product/GetProducts' + query, function (res) {
                const data = res.items;
                const totalRecords = res.totalCount;

                data.forEach(row => {
                    let actions =
                        `
                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#addEditProducts' onclick='GetInfoForEditProduct("${row.id}")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='ProductDelete("${row.id}")' title='حذف'>🗑</button>
                </div>
                        `;
                    let status = '';
                    if (row.active) {
                        status = `<div class='badge badge-light-success'>فعال</div>`;
                    } else {
                        status = `<div class='badge badge-light-danger'>غیرفعال</div>`;
                    }
                    tbody.append(`
                <tr>
                    <td>${row.groupTitle}</td>
                    <td>${row.title}</td>
                    <td>${CurrencyFormatted(row.buyPrice)}</td>
                    <td>${CurrencyFormatted(row.salePrice)}</td>
                    <td>${(row.checkInventory ? "بله" : "خیر")}</td>
                    <td>${row.inventory}</td>
                    <td>${status}</td>
                    <td>${actions}</td>
                </tr>
            `);
                });

                $("#pageIndex").text(pageIndex + 1);
                $("#countAllTable").text(totalRecords);
                $("#prevPageBtn").prop("disabled", !res.hasPreviousPage);
                $("#nextPageBtn").prop("disabled", !res.hasNextPage);
            },
                function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                });
        }
    </script>
    <script>
        function AddEditProduct() {
            var gproduct = document.getElementById("p_productgroup").value;
            var Title = document.getElementById("p_Title").value;
            var buyPrice = document.getElementById("p_buyPrice").value;
            var salePrice = document.getElementById("p_salePrice").value;
            buyPrice = buyPrice.replaceAll(",", "");
            salePrice = salePrice.replaceAll(",", "");
            if (parseFloat(buyPrice) == undefined) {
                alert("لطفا مبلغ خرید را بدرستی وارد کنید");
                return;
            }
            if (parseFloat(salePrice) == undefined) {
                alert("لطفا مبلغ فروش را بدرستی وارد کنید");
                return;
            }
            var checkInventory = $("#p_checkInventory").prop("checked");
            var active = $("#p_active").prop("checked");
            var pariority = document.getElementById("p_pariority").value;
            var Inventory = document.getElementById("p_Inventory").value;
            if (Inventory === "") {
                Inventory = "0";
            }
            if (pariority === "") {
                pariority = "0";
            }
            if (parseInt(Inventory) == undefined) {
                toastr.warning("لطفا موجودی را بدرستی وارد کنید","موجودی");
                return;
            }
            if (parseInt(pariority) == undefined) {
                toastr.warning("لطفا ترتیب نمایش را بدرستی وارد کنید","ترتیب نمایش");
                return;
            }
            if (!Title) {
                toastr.warning("لطفا عنوان کالا را وارد کنید", "عنوان کالا");
                return;
            }
            var desc = document.getElementById("p_desc").value;

            let createProductCommand =
            {
                id: productId,
                groupId: gproduct,
                title: Title,
                buyPrice: parseFloat(buyPrice),
                salePrice: parseFloat(salePrice),
                checkInventory: checkInventory,
                active: active,
                priority: parseInt(pariority),
                desc: desc,
                inventoryCount: parseInt(Inventory)
            };
            let method = 'POST';
            let route = '/Product/Create';
            if (productId != '') {
                method = 'PUT';
                route = '/Product/Update';
            }
            ajaxAuthCall(method, route, createProductCommand, function (res) {
                if (res.success) {
                    toastr.success('اطلاعات ذخیره شد', "موفق");
                    closeModalProduct();
                    loadTableDataProduct();
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
                toastr.error("خطا در ذخیره اطلاعات", "خطا");
            });
        };

    </script>
    <script>
        function fillProductGroupsAsync() {
            let defaultOption = '<option value="0">انتخاب گروه کالا</option>';
            ajaxGet('/ProductGroup/GetGroups', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');
                $("#filter_productgroup").html(defaultOption + options);
                $("#p_productgroup").html(options);
            });
        }
    </script>
    <script>
        function ProductDelete(id) {
            const userResponse = confirm("آیا از حذف مطمئن هستین؟");
            if (userResponse) {
                let query = `?id=${id}`;
                ajaxDelete('/Product/Delete' + query, function (res) {
                    if (res.success) {
                        toastr.success('محصول حذف شد', "موفق");
                        loadTableDataProduct();
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
</asp:Content>
