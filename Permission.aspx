<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Permission.aspx.cs" Inherits="Permission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
    <style>
.employee-item {
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 18px;
    padding: 12px;
    border-radius: 6px;
    text-align: center;
    font-weight: 500;
}

.employee-item:hover {
    background: #f0f0f0;
    font-weight: bold;
}

.employee-item.active {
    background: #007BFF;
    color: white;
    font-weight: bold;
}

.card {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
}

.custom-checkbox .form-check-input {
    width: 22px;
    height: 22px;
    cursor: pointer;
}

.custom-checkbox .form-check-label {
    font-size: 18px;
    font-weight: 500;
    cursor: pointer;
    margin-left: 10px;
}

.btn-primary {
    font-size: 20px;
    font-weight: bold;
    padding: 14px;
    border-radius: 8px;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="d-flex-column-auto flex-fill" id="kt_post">
        <div id="kt_content_container">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container mt-5">
  <div class="row">
    <!-- لیست پرسنل -->
    <div class="col-md-4">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header bg-primary text-white text-center py-3">
                <h5 class="mb-0">👤 لیست پرسنل</h5>
            </div>
            <div class="card-body p-3">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item employee-item" data-id="1">🔹 علی رضایی</li>
                    <li class="list-group-item employee-item" data-id="2">🔹 مریم محمدی</li>
                    <li class="list-group-item employee-item" data-id="3">🔹 سعید نوری</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- لیست صفحات -->
    <div class="col-md-8">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header bg-success text-white text-center py-3">
                <h5 class="mb-0">🛠️ مدیریت دسترسی صفحات</h5>
            </div>
            <div class="card-body">
                <div class="form-check custom-checkbox">
                    <input class="form-check-input access-checkbox" type="checkbox" id="dashboard">
                    <label class="form-check-label" for="dashboard">📊 داشبورد</label>
                </div>
                <div class="form-check custom-checkbox">
                    <input class="form-check-input access-checkbox" type="checkbox" id="customers">
                    <label class="form-check-label" for="customers">👥 مدیریت مشتریان</label>
                </div>
                <div class="form-check custom-checkbox">
                    <input class="form-check-input access-checkbox" type="checkbox" id="gallery">
                    <label class="form-check-label" for="gallery">🖼️ گالری تصاویر</label>
                </div>
                <div class="form-check custom-checkbox">
                    <input class="form-check-input access-checkbox" type="checkbox" id="reports">
                    <label class="form-check-label" for="reports">📑 گزارشات</label>
                </div>
                <button class="btn btn-primary w-100 mt-4" id="saveAccess">💾 ثبت تغییرات</button>
            </div>
        </div>
    </div>
</div>
                              </div>
        </div>
    </div>
</div>
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" Runat="Server">
    <script type="text/javascript">
        const accessData = {
            1: ["dashboard", "customers"], // دسترسی‌های علی رضایی
            2: ["gallery"], // دسترسی‌های مریم محمدی
            3: ["reports", "dashboard"], // دسترسی‌های سعید نوری
        };

        document.querySelectorAll(".employee-item").forEach((item) => {
            item.addEventListener("click", function () {
                document.querySelectorAll(".employee-item").forEach(e => e.classList.remove("active"));
                this.classList.add("active");

                const userId = this.getAttribute("data-id");

                document.querySelectorAll(".access-checkbox").forEach(checkbox => {
                    checkbox.checked = accessData[userId]?.includes(checkbox.id) || false;
                });
            });
        });
    </script>
</asp:Content>

