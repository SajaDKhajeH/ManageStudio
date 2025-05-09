<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Permission.aspx.cs" Inherits="Permission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                                        <ul id="divSecretaries" class="list-group list-group-flush">
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
                                    <div class="card-body" id="pagess">
                                    </div>
                                    <button class="btn btn-primary w-100 mt-4" onclick="SavePermission()" id="saveAccess">💾 ثبت تغییرات</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">
        var personnelId = '';
        function showSecretariesAsync() {
            ajaxGet("/User/GetAllSecretaries", function (users) {
                const usersHtml = users.map(user =>
                    `<li class='list-group-item employee-item' data-id='${user.id}'>${user.title}</li>`
                ).join('');
                $("#divSecretaries").html(usersHtml);

                document.querySelectorAll(".employee-item").forEach((item) => {
                    item.addEventListener("click", function () {
                        document.querySelectorAll(".employee-item").forEach(e => e.classList.remove("active"));
                        this.classList.add("active");
                        var userId = this.getAttribute("data-id");
                        GetPermissions(userId);
                    });
                });
            });
        }
        function SavePermission() {
            var Pages = document.getElementsByName("PagesPermission");

            const pageIds = new Set(
                Array.from(Pages)
                    .filter(page => page.checked)
                    .map(page => page.id)
            );
            console.log(pageIds);
            let createPermissionCommand =
            {
                pageIds: Array.from(pageIds),
                personId: personnelId
            };
            ajaxPost("/Permission/CreatePermission", createPermissionCommand, function (res) {
                if (res.success) {
                    toastr.success("ثبت دسترسی ها با موفقیت انجام شد");
                } else {
                    ShowError(res.message);
                }
            });
        }
        function GetPermissions(id) {
            personnelId = id;
            let query ='?userId=' + personnelId;
            ajaxGet("/Permission/GetPermissions" + query, function (permissions) {
                const permissionsHtml = permissions.map(permission =>
                    `
                     <div class='form-check custom-checkbox'>
                        <input class='form-check-input access-checkbox' name='PagesPermission' type='checkbox' id='${permission.id}' ${(permission.hasPermission ? "checked" : "")}>
                        <label class='form-check-label' for='dashboard'>${permission.title}</label>
                     </div>
                    `
                ).join('');
                $("#pagess").html(permissionsHtml);
            });
        };
        $(document).ready(function () {
            showSecretariesAsync();
        });
    </script>
</asp:Content>

