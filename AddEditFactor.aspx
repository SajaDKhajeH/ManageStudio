<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="AddEditFactor.aspx.cs" Inherits="AddEditFactor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="d-flex-column-auto flex-fill">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="row g-10">
                        <div class="col-lg-3">
                            <br />
                            <label>انتخاب خانواده</label>
                            <select onchange="GetPhotographerByFamily()" id="factor_Family" data-control="select2" class="form-select form-select-solid select2-hidden-accessible" style="margin: 3px" data-placeholder="انتخاب مشتری">
                            </select>
                            <br />
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>تاریخ فاکتور</label>
                                    <input style="margin: 3px" class="form-control datepicker selectedShamsiDate" id="factor_Date">
                                </div>
                                <div class="col-lg-6">
                                    <label>موضوع عکاسی</label>
                                    <select id="factor_TypePhotography">
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>عکاس</label>
                                    <select id="factor_Photographer">
                                    </select>
                                </div>
                                <div class="col-lg-6" style="margin-top: 3px">
                                    <label>وضعیت فاکتور</label>
                                    <select id="factor_status">
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="d-flex flex-stack" style="margin-top: 3px">
                                <label class="form-check form-switch form-check-custom form-check-solid">
                                    <input id="factor_ForceDesign" class="form-check-input" type="checkbox" />
                                    <span class="form-check-label fw-bold text-dark">این فاکتور نیاز به طراحی فوری دارد</span>
                                </label>
                            </div>
                            <br />
                            <div class="d-flex flex-stack" style="margin-top: 3px">
                                <label class="form-check form-switch form-check-custom form-check-solid">
                                    <input id="factor_OnlyEditedDelivered" class="form-check-input" type="checkbox" />
                                    <span class="form-check-label fw-bold text-dark">عکس هارو ادیت شده میخواهند</span>
                                </label>
                            </div>
                            <br />
                            <label>توضیحات برای طراح</label>
                            <textarea style="margin: 3px" placeholder="توضیحات برای طراح" class="form-control" id="factor_desc"></textarea>
                            <br />
                            <label>آدرس فایل ها</label>
                            <input style="margin: 3px; display: none" class="form-control" id="factor_PathFiles">
                        </div>
                        <div class="col-lg-9">
                            <div class="tabs-container">
                                <button class="tab-button active" data-tab="productsTab">اقلام</button>
                                <button class="tab-button" onclick="GetLogs()" data-tab="logTab">تغییرات فاکتور</button>
                                <button class="tab-button" data-tab="picTab">عکس ها</button>
                            </div>
                            <div class="tabs-content">
                                <div class="tab-content active" id="productsTab">
                                    <div class="row g-12">
                                        <div class="col-lg-3">
                                            <div id="divProductGroups" class="item-selection">
                                            </div>
                                        </div>
                                        <div class="col-lg-9">
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
                                                            <th>حذف</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="itemTableBody">
                                                    </tbody>
                                                </table>
                                                <div id="div_Pay_A_Discount">
                                                    <div class="row">
                                                        <div class="col-lg-3">
                                                            <label class="fs-6 fw-bold mb-2">مبلغ تخفیف</label>
                                                            <input type="text" class="form-control" style="margin: 3px" id="factor_discountPercent" onkeyup="TextFormatPrice(this)" onchange="updateTable()" placeholder="مبلغ تخفیف">
                                                        </div>
                                                        <%--<div class="col-lg-3">
                                                            <label class="fs-6 fw-bold mb-2">مبلغ پرداختی</label>
                                                            <input type="text" class="form-control" style="margin: 3px" id="factor_PaidPrice" onkeyup="TextFormatPrice(this)" onchange="updateTable()" placeholder="مبلغ پرداختی">
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label class="fs-6 fw-bold mb-2">طریقه پرداخت</label>
                                                            <select style="margin: 3px" id="factor_PaidType" data-control="select" data-placeholder="نوع پرداخت" class="form-select form-select-solid fw-bolder">
                                                                <%Response.Write(PublicMethod.GetPaidType()); %>
                                                            </select>
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <label class="fs-6 fw-bold mb-2">شماره پیگیری</label>
                                                            <input style="margin: 3px" type="text" id="factor_RefNumber" class="form-control" placeholder="شماره پیگیری">
                                                        </div>--%>
                                                    </div>
                                                </div>
                                                <div class="summary row">
                                                    <div class="col-lg-4">مجموع فاکتور: <span id="totalAmount">0</span> </div>
                                                    <div class="col-lg-4">تخفیف: <span id="discountAmount">0</span> </div>
                                                    <%--<div class="col-lg-3">مبلغ پرداختی: <span id="paidAmount">0</span>  <%Response.Write(Settings.TextAfterPrice); %></div>--%>
                                                    <div class="col-lg-4">قابل پرداخت: <span id="payableAmount">0</span>  </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-content" id="logTab">
                                    <ul class="log-list" id="logList">
                                    </ul>
                                </div>
                                <div class="tab-content" id="picTab">
                                    <label style="color: red" title="">عکس هایی که در این قسمت آپلود می کنید پس از انتخاب مشتری به صورت اتوماتیک حذف خواهد شد</label>
                                    <label style="color: red" title="">روی عکس ها واترمارک</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flex-center">
                        <button onclick="SetFactor()" class="btn btn-primary" id="btn_SetFactor">ثبت فاکتور</button>
                        <button onclick="GoReferer()" class="btn btn-light me-3" id="cancelBtn">لغو</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script src="assets/js/basic-data/forcmb.js"></script>
    <script src="assets/js/users/forcmb.js"></script>
    <script>

        function fillFamiliesAsync() {
            ajaxGet('/Family/GetAllFamilies', function (families) {
                const options = families.map(family =>
                    `<option value="${family.id}">${family.title}</option>`
                ).join('');
                $('#factor_Family').html(options);
            });
        }
        function fillInvoiceStatusesAsync() {
            ajaxGet('/InvoiceStatus/GetAll', function (items) {
                const options = items.map(item =>
                    `<option value="${item.id}">${item.title}</option>`
                ).join('');
                $('#factor_status').html(options);
            });
        }

    </script>
    <script>
        function fillControls() {
            $('#totalAmount').parent().append(getCurrency());
            $('#discountAmount').parent().append(getCurrency());
            $('#payableAmount').parent().append(getCurrency());
        }
        $(document).ready(function () {
            fillControls();
            fillFamiliesAsync();
            fillInvoiceStatusesAsync();
        });
    </script>
    <script type="text/javascript">
        var getLogs = false;
        var btn_SetFactor = "btn_SetFactor";
        var factorId = 0;
        var turnId = 0;
        function GoReferer() {
            if (document.referrer != null && document.referrer != undefined) {
                location.href = document.referrer;
            }
            else {
                location.href = "Dashboard.aspx";
            }
        };
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
        function documentReady() {
            let params = new URLSearchParams(document.location.search);
            FirstLoad();
            factorId = params.get("id");
            if (factorId == undefined || factorId == '0' || factorId == 0)
                factorId = '';

            turnId = parseInt(params.get("turnid"));
            if (isNaN(turnId)) {
                turnId = 0;
            }
            if (factorId) {
                GetInfoForEditFactor(factorId);
            }
            else {
                factorId = '';
                $("#master_PageTitle").text("ثبت فاکتور جدید");
                if (turnId > 0) {
                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/GetInfoBy_TurnId",
                        data: JSON.stringify({
                            TurnId: turnId
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            $("#factor_Family").val(msg.d.FamilyId);
                            $("#factor_Photographer").val(msg.d.PhotographerId);
                            $("#factor_TypePhotography").val(msg.d.TypeId);
                            $("#factor_Family").change();
                        },
                        error: function () {
                            alert("error");
                        }
                    });
                }
            }
            document.getElementById("gotoFactor").style.visibility = "hidden";
            document.getElementById("Btn_AddRequest").style.visibility = "hidden";

            $('#factor_desc').on('input', function () {
                this.style.height = 'auto';

                this.style.height =
                    (this.scrollHeight) + 'px';
            });
        }
        $(document).ready(function () {
            showProgress();
            fillProductGroupsAsync(function () {
                fillPhotoTopicsCMBAsync('factor_TypePhotography', false, function () {
                    fillPhotographersCMBAsync('factor_Photographer', false, function () {
                        documentReady();
                        hideProgress();
                    });
                });
            });
        });
        function FirstLoad() {
            const tbody = document.getElementById("itemTableBody");
            tbody.innerHTML = "";
            factorId = 0;
            Productitems = [];
            document.getElementById("totalAmount").textContent = 0;
            document.getElementById("discountAmount").textContent = 0;
            document.getElementById("payableAmount").textContent = 0;
            //document.getElementById("paidAmount").textContent = 0;
            document.getElementById("factor_discountPercent").value = "0";
            //document.getElementById("factor_PaidPrice").value = "0";
            document.getElementById("factor_desc").value = "";
            document.getElementById("factor_TypePhotography").value = "";
            document.getElementById("factor_status").value = "";
            document.getElementById("factor_Photographer").value = "";
            document.getElementById("div_Pay_A_Discount").style.display = "block";
            $("#factor_ForceDesign").prop("checked", false);
            $("#factor_OnlyEditedDelivered").prop("checked", false);
            //document.getElementById('factor_PaidPrice').style.display = 'block';
            //document.getElementById('factor_PaidType').style.display = 'block';
            //document.getElementById('factor_RefNumber').style.display = 'block';
            document.getElementById('factor_Family').style.display = 'block';
        }
        function GetLogs() {
            if (!factorId)
                document.getElementById('logList').innerHTML = "";

            if (!getLogs) {
                let query = '?invoiceId=' + factorId;
                ajaxGet('/InvoiceChange/GetAll' + query, function (items) {
                    document.getElementById('logList').innerHTML = items.map(item => `
                    <li class='log-item'>
                            <span class='log-text'>${item.title}</span>
                         </li>
                    `).join("");
                    getLogs = true;
                })
            }
        }
        function PrintFactor(id) {
            $.ajax({
                type: "POST",
                url: "ManageInvoice.aspx/PrintFactor",
                async: false,
                data: JSON.stringify({
                    id: id
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    //if (res.Result) {
                    //    setTimeout(function () {
                    //        window.open(res.Url, '_blank').focus();
                    //    }, 110);
                    //}
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                }
            });
        };
        function GetInfoForEditFactor(id) {
            let query = `?id=${id}`;
            ajaxGet('/Invoice/Get' + query, function (res) {
                if (res.success) {
                    let data = res.data;
                    $("#master_PageTitle").text("جزئیات فاکتور " + data.invoiceNumber);
                    $("#factor_Family").val(data.familyId);
                    $("#factor_Date").val(data.date);
                    $("#factor_desc").val(data.desc);
                    $("#factor_discountPercent").val(data.discountPercent);
                    document.getElementById('factor_Family').style.display = 'none';
                    $("#factor_Family").change();
                    Productitems = data.invoiceDetails;
                    document.getElementById("factor_TypePhotography").value = data.typePhotographiId;
                    document.getElementById("factor_status").value = data.statusId;
                    document.getElementById("factor_Photographer").value = data.photographerId;
                    $("#factor_ForceDesign").prop("checked", data.forceDesign);
                    $("#factor_OnlyEditedDelivered").prop("checked", data.onlyEditedDelivered);
                    updateTable();
                }
                else {
                    ShowError(res.message);
                }
            }, function () {
                alert("error");
            });

        };
        function GetPhotographerByFamily() {
            if ((factorId == null || factorId == undefined || factorId == 0) && (turnId == 0 || turnId == undefined || turnId == null)) {
                var familyId = $("#factor_Family").val();
                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/GetPhotographerByFamily",
                    data: JSON.stringify({
                        familyId: familyId
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        if (msg.d.Change) {
                            $("#factor_Photographer").val(msg.d.LastPhotographerId);
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }

        };
    </script>
    <%--اسکریپت مربوط به جدول اقلام--%>
    <script>
        function toggleGroupItems(groupId) {
            // const group = document.getElementById(groupId);
            groupId.style.display = groupId.style.display === "none" ? "block" : "none";
        }

        let Productitems = [];

        function addItem(Id, price, title, gtitle) {
            const existingItem = Productitems.find(item => item.productId == Id);
            if (existingItem) {
                existingItem.count++;
            } else {
                Productitems.push({
                    productTitle: title,
                    price,
                    count: 1,
                    desc: "",
                    productId: Id,
                    FCId: 0,
                    productGroupTitle: gtitle,
                    shotCount: 0,
                    isGift: false
                });
            }
            updateTable();
        }
        function updateTable() {
            const tbody = document.getElementById("itemTableBody");
            tbody.innerHTML = "";

            let total = 0;
            Productitems.forEach((item, index) => {
                if (item.isGift == null || item.isGift == undefined || item.isGift == false) {
                    total += item.price * item.count;
                }
                const row = document.createElement("tr");
                row.innerHTML = `
                <td><input onclick="UpdateIsGift(${index},this.checked)" name="IsGift" class="form-check-input" type="checkbox" ${item.isGift ? "checked" : ""}/></td>
                <td>${item.productGroupTitle}-${item.productTitle}</td>
                <td><input type="number" value="${item.count}" min="1" max="100" onchange="updateCount(${index}, this.value)"></td>
                <td><input type="text" value="${CurrencyFormatted(item.price)}" min="1" max="100000000" disabled></td>
                <td><textarea onchange="updateDesc(${index}, this.value)">${item.desc}</textarea></td>
                <td><input type="number" maxlength="110" value="${item.shotCount}" onchange="updateShotCount(${index}, this.value)"></td>
                <td><button class="btn btn-danger" onclick="removeItem(${index})">حذف</button></td>
            `;
                tbody.appendChild(row);
            });

            var discount = document.getElementById("factor_discountPercent").value;
            //var paidPrice = document.getElementById("factor_PaidPrice").value;
            discount = convertPersianToEnglishNumbers(discount);
            //paidPrice = convertPersianToEnglishNumbers(paidPrice);

            //paidPrice = paidPrice.replaceAll(",", "");
            discount = discount.replaceAll(",", "");
            //const payable = total - parseInt(discount) - parseInt(paidPrice);
            const payable = total - parseInt(discount);

            document.getElementById("totalAmount").textContent = CurrencyFormatted(total);
            document.getElementById("discountAmount").textContent = CurrencyFormatted(discount);
            //document.getElementById("paidAmount").textContent = CurrencyFormatted(paidPrice);
            document.getElementById("payableAmount").textContent = CurrencyFormatted(payable);
        }

        function updateCount(index, count) {
            Productitems[index].count = parseInt(count, 10);
            updateTable();
        }
        function updateShotCount(index, shotCount) {
            Productitems[index].ShotCount = parseInt(shotCount, 10);
        }
        function updateProductPrice(index, price) {
            Productitems[index].price = parseInt(price, 1000);
            updateTable();
        }
        function UpdateIsGift(index, checked) {
            Productitems[index].Gift = checked;
            updateTable();
        }

        function updateDesc(index, desc) {
            Productitems[index].desc = desc;
        }
        function removeItem(index) {
            Productitems.splice(index, 1);
            updateTable();
        }
    </script>
    <!--اسکریپ مربوط به مدال ثبت فاکتور -->
    <script>
        const modalSetFactor = document.getElementById('m_SetFactor');
        function SetFactor() {
            var factor_Family = $("#factor_Family").val();
            var factor_Date = $("#factor_Date").val();
            var factor_desc = $("#factor_desc").val();
            var factor_discountPrice = $("#factor_discountPercent").val();
            factor_discountPrice = convertPersianToEnglishNumbers(factor_discountPrice);
            //var factor_PaidPrice = $("#factor_PaidPrice").val();
            //factor_PaidPrice = convertPersianToEnglishNumbers(factor_PaidPrice);
            //factor_PaidPrice = factor_PaidPrice.replaceAll(",", "");
            factor_discountPrice = factor_discountPrice.replaceAll(",", "");
            //var factor_PaidType = $("#factor_PaidType").val();
            //var factor_RefNumber = $("#factor_RefNumber").val();
            var TypePhotography = document.getElementById("factor_TypePhotography").value;
            var factor_status = document.getElementById("factor_status").value;
            var PhotographerId = document.getElementById("factor_Photographer").value;
            var ForceDesign = $("#factor_ForceDesign").prop("checked");
            var OnlyEditedDelivered = $("#factor_OnlyEditedDelivered").prop("checked");

            if (!factor_Date) {
                toastr.warning('لطفاً تاریخ فاکتور را مشخص کنید', 'تاریخ فاکتور');
                return;
            }
            if (!TypePhotography) {
                toastr.warning('لطفاً موضوع عکاسی را مشخص کنید', 'موضوع عکاسی');
                return;
            }
            if (!factor_status) {
                toastr.warning('لطفاً وضعیت فاکتور را مشخص کنید', 'وضعیت فاکتور');
                return;
            }
            if (!Productitems || Productitems.length == 0) {
                toastr.warning('لطفا اقلام فاکتور را مشخص کنید', 'اقلام فاکتور');
                return;
            }

            btnAddEdit_ChangeDisable(btn_SetFactor, true);
            //data: JSON.stringify({
            //    factorId: factorId, familyId: factor_Family, fDate: factor_Date, discountPrice: factor_discountPrice,
            //    products: Productitems, factor_desc: factor_desc,
            //    TypePhotography: TypePhotography, factor_status: factor_status, PhotographerId: PhotographerId,
            //ForceDesign: ForceDesign, OnlyEditedDelivered: OnlyEditedDelivered
            //}),
            let createInvoiceCommand =
            {
                id: factorId,
                familyId: factor_Family,
                date: factor_Date,
                sumDiscount: factor_discountPrice,
                typePhotographyId: (TypePhotography && TypePhotography != 0) ? TypePhotography : null,
                status: factor_status,
                photographerId: (PhotographerId && PhotographerId != 0) ? PhotographerId : null,
                isForceDesign: ForceDesign,
                desc: factor_desc,
                invoiceDetails: Productitems.map(item => ({
                    productId: item.productId,
                    price: item.price,
                    count: item.count,
                    shotCount: item.shotCount,
                    desc: item.desc
                }))
            };
            let method = 'POST';
            let route = '/Invoice/Create';
            if (factorId != '') {
                method = 'PUT';
                route = '/Invoice/Update';
            }
            ajaxAuthCall(method, route, createInvoiceCommand, function (res) {
                btnAddEdit_ChangeDisable(btn_SetFactor, false);
                if (res.success) {
                    toastr.success('ثبت اطلاعات با موفقیت انجام شد', "موفق");
                    if (factorId == 0) {
                        PrintFactor(res.data);
                    }
                    location.href = document.referrer;
                }
                else {
                    ShowError(res.message);
                }
            }, function (err) {
                btnAddEdit_ChangeDisable(btn_SetFactor, false);
            });
        };
    </script>


    <script>
        function fillProductGroupsAsync(callback) {
            ajaxGet('/ProductGroup/GetGroups', function (items) {
                const options = items.map(item =>
                    `<button class='button' onclick='toggleChildButtons(this,"${item.id}")'>${item.title}</button>
                    <div id='product-group-${item.id}' class='child-buttons'>
                    </div>`
                ).join('');
                $("#divProductGroups").html(options);
                callback();
            });
        }
        let productsOfGroup = new Map();
        function toggleChildButtons(button, groupId) {
            const childButtons = button.nextElementSibling;
            if (childButtons.style.display === "block") {
                childButtons.style.display = "none";
                return;
            }

            if (productsOfGroup.has(groupId)) {
                $('#product-group-' + groupId).html(productsOfGroup.get(groupId));
                childButtons.style.display = "block";
                return;
            }

            let groupHtml = '';
            let query = `?GroupId=${groupId}&PageIndex=0&PageSize=50`;
            ajaxGet('/Product/GetProducts' + query, function (res) {

                hideProgress();
                const items = res.items;
                groupHtml = items.map(item =>
                    `<button class='child-button' onclick='addItem("${item.id}",${item.salePrice},"${item.title}","${item.groupTitle}")'>${item.title}</button>`
                ).join('');
                productsOfGroup.set(groupId, groupHtml);
                $('#product-group-' + groupId).html(groupHtml);
                childButtons.style.display = "block";
            }, function () {
                hideProgress();
            });
        };
    </script>
</asp:Content>

