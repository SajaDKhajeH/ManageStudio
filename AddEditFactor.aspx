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
                            <select id="factor_Family" data-control="select2" class="form-select form-select-solid select2-hidden-accessible" style="margin: 3px" data-placeholder="انتخاب مشتری">
                               <%Response.Write(PublicMethod.GetActiveCustomer()); %>
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
                                        <%Response.Write(PublicMethod.GetTypePhotographi()); %>
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>عکاس</label>
                                    <select id="factor_Photographer">
                                        <%Response.Write(PublicMethod.GetPhotographer(true)); %>
                                    </select>
                                </div>
                                <div class="col-lg-6" style="margin-top: 3px">
                                    <label>وضعیت فاکتور</label>
                                    <select id="factor_status">
                                        <%Response.Write(PublicMethod.GetFactorStatus()); %>
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
                            <input style="margin: 3px" class="form-control" id="factor_PathFiles">
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
                                            <div class="item-selection">
                                                <%Response.Write(PublicMethod.GetProducts()); %>
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
                                                        <div class="col-lg-3">
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
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="summary row">
                                                    <div class="col-lg-3">مجموع فاکتور: <span id="totalAmount">0</span> <%Response.Write(Settings.TextAfterPrice); %></div>
                                                    <div class="col-lg-3">تخفیف: <span id="discountAmount">0</span>  <%Response.Write(Settings.TextAfterPrice); %></div>
                                                    <div class="col-lg-3">مبلغ پرداختی: <span id="paidAmount">0</span>  <%Response.Write(Settings.TextAfterPrice); %></div>
                                                    <div class="col-lg-3">قابل پرداخت: <span id="payableAmount">0</span>  <%Response.Write(Settings.TextAfterPrice); %></div>
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
                                    <label style="color:red" title="">عکس هایی که در این قسمت آپلود می کنید پس از انتخاب مشتری به صورت اتوماتیک حذف خواهد شد</label>
                                    <label style="color:red" title="">روی عکس ها واترمارک</label>
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
    <script type="text/javascript">
        var getLogs = false;
        var btn_SetFactor = "btn_SetFactor";
        var factorId = 0;
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
        $(document).ready(function () {
            let params = new URLSearchParams(document.location.search);
            FirstLoad();
            factorId = parseInt(params.get("id")); // is the string "Jonathan"
            if (factorId>0) {
                $("#master_PageTitle").text("جزئیات فاکتور " + factorId);
                GetInfoForEditFactor(factorId);
            }
            else {
                factorId = 0;
                $("#master_PageTitle").text("ثبت فاکتور جدید");
            }
            document.getElementById("gotoFactor").style.visibility = "hidden";
            document.getElementById("Btn_AddRequest").style.visibility = "hidden";

            $('#factor_desc').on('input', function () {
                this.style.height = 'auto';

                this.style.height =
                    (this.scrollHeight) + 'px';
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
            document.getElementById("paidAmount").textContent = 0;
            document.getElementById("factor_discountPercent").value = "0";
            document.getElementById("factor_PaidPrice").value = "0";
            document.getElementById("factor_desc").value = "";
            document.getElementById("factor_TypePhotography").value = "";
            document.getElementById("factor_status").value = "";
            document.getElementById("factor_Photographer").value = "";
            document.getElementById("div_Pay_A_Discount").style.display = "block";
            $("#factor_ForceDesign").prop("checked", false);
            $("#factor_OnlyEditedDelivered").prop("checked", false);
            document.getElementById('factor_PaidPrice').style.display = 'block';
            document.getElementById('factor_PaidType').style.display = 'block';
            document.getElementById('factor_RefNumber').style.display = 'block';
            document.getElementById('factor_Family').style.display = 'block';
        }
        function GetLogs() {
            if (!getLogs) {
                $.ajax({
                    type: "POST",
                    url: "RequestStatus.aspx/FactorLogs",
                    data: JSON.stringify({
                        FactorId: factorId
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        getLogs = true;
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
            $.ajax({
                type: "POST",
                url: "ManageInvoice.aspx/GetFactorInfo",
                data: JSON.stringify({
                    id: id
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        $("#factor_Family").val(res.FamilyCodeId);
                        $("#factor_Date").val(res.FactorInfo.F_Date);
                        $("#factor_desc").val(res.FactorInfo.F_Desc);
                        $("#factor_discountPercent").val(res.FactorInfo.F_DiscountPercent);
                        document.getElementById('factor_PaidPrice').style.display = 'none';
                        document.getElementById('factor_PaidType').style.display = 'none';
                        document.getElementById('factor_RefNumber').style.display = 'none';
                        document.getElementById('factor_Family').style.display = 'none';
                        $("#factor_Family").change();
                        Productitems = res.FactorDetails;
                        document.getElementById("factor_TypePhotography").value = res.TypePhotographiId;
                        document.getElementById("factor_status").value = res.FactorStatusId;
                        document.getElementById("factor_Photographer").value = res.PhotographerId;
                        $("#factor_ForceDesign").prop("checked", res.FactorInfo.F_ForceDesign);
                        $("#factor_OnlyEditedDelivered").prop("checked", res.FactorInfo.F_OnlyEditedDelivered);
                        updateTable();
                    }
                },
                error: function () {
                    alert("error");
                }
            });
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
            const existingItem = Productitems.find(item => item.ProductId == Id);
            if (existingItem) {
                existingItem.quantity++;
            } else {
                Productitems.push({ title, price, quantity: 1, notes: "", ProductId: Id, FCId: 0, GTitle: gtitle, ShotCount: 0, Gift: false });
            }
            updateTable();
        }
        function updateTable() {
            const tbody = document.getElementById("itemTableBody");
            tbody.innerHTML = "";

            let total = 0;
            Productitems.forEach((item, index) => {
                if (item.Gift == null || item.Gift == undefined || item.Gift == false) {
                    total += item.price * item.quantity;
                }
                const row = document.createElement("tr");
                row.innerHTML = `
                <td><input onclick="UpdateIsGift(${index},this.checked)" name="IsGift" class="form-check-input" type="checkbox" ${item.Gift ? "checked" : ""}/></td>
                <td>${item.GTitle}-${item.title}</td>
                <td><input type="number" value="${item.quantity}" min="1" max="100" onchange="updateQuantity(${index}, this.value)"></td>
                <td><input type="text" value="${CurrencyFormatted(item.price)}" min="1" max="100000000" disabled></td>
                <td><textarea onchange="updateNotes(${index}, this.value)">${item.notes}</textarea></td>
                <td><input type="number" maxlength="110" value="${item.ShotCount}" onchange="updateShotCount(${index}, this.value)"></td>
                <td><button class="btn btn-danger" onclick="removeItem(${index})">حذف</button></td>
            `;
                tbody.appendChild(row);
            });

            var discount = document.getElementById("factor_discountPercent").value;
            var paidPrice = document.getElementById("factor_PaidPrice").value;
            discount = convertPersianToEnglishNumbers(discount);
            paidPrice = convertPersianToEnglishNumbers(paidPrice);

            paidPrice = paidPrice.replaceAll(",", "");
            discount = discount.replaceAll(",", "");
            const payable = total - parseInt(discount) - parseInt(paidPrice);

            document.getElementById("totalAmount").textContent = CurrencyFormatted(total);
            document.getElementById("discountAmount").textContent = CurrencyFormatted(discount);
            document.getElementById("paidAmount").textContent = CurrencyFormatted(paidPrice);
            document.getElementById("payableAmount").textContent = CurrencyFormatted(payable);
        }

        function updateQuantity(index, quantity) {
            Productitems[index].quantity = parseInt(quantity, 10);
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

        function updateNotes(index, notes) {
            Productitems[index].notes = notes;
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
            var factor_PaidPrice = $("#factor_PaidPrice").val();
            factor_PaidPrice = convertPersianToEnglishNumbers(factor_PaidPrice);
            factor_PaidPrice = factor_PaidPrice.replaceAll(",", "");
            factor_discountPrice = factor_discountPrice.replaceAll(",", "");
            var factor_PaidType = $("#factor_PaidType").val();
            var factor_RefNumber = $("#factor_RefNumber").val();
            var TypePhotography = document.getElementById("factor_TypePhotography").value;
            var factor_status = document.getElementById("factor_status").value;
            var PhotographerId = document.getElementById("factor_Photographer").value;
            var ForceDesign = $("#factor_ForceDesign").prop("checked");
            var OnlyEditedDelivered = $("#factor_OnlyEditedDelivered").prop("checked");
            btnAddEdit_ChangeDisable(btn_SetFactor, true);
            $.ajax({
                type: "POST",
                url: "ManageInvoice.aspx/SetFactor",
                data: JSON.stringify({
                    factorId: factorId, familyId: factor_Family, fDate: factor_Date, discountPrice: factor_discountPrice,
                    paidPrice: factor_PaidPrice, paidType: factor_PaidType, refNumber: factor_RefNumber, products: Productitems, factor_desc: factor_desc,
                    TypePhotography: TypePhotography, factor_status: factor_status, PhotographerId: PhotographerId, ForceDesign: ForceDesign, OnlyEditedDelivered: OnlyEditedDelivered
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    btnAddEdit_ChangeDisable(btn_SetFactor, false);
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        toastr.success(msg.d.Message, "موفق");
                        if (factorId==0) {
                            PrintFactor(msg.d.FactorId);
                        }
                        location.href = document.referrer;
                    }
                },
                error: function () {
                    btnAddEdit_ChangeDisable(btn_SetFactor, false);
                    alert("error");
                }
            });
        };
    </script>
</asp:Content>

