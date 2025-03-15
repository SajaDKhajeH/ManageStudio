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
                                        <ul class="list-group list-group-flush">
                                            <%Response.Write(GetPersonnels()); %>
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
        var personnelId = 0;
        function SavePermission() {

            var Pages = document.getElementsByName("PagesPermission");
            var pageIds = "";

            for (var i = 0; i < Pages.length; i++) {
                if (Pages[i].checked) {
                    pageIds += Pages[i].id + ",";
                }
            }
            $.ajax({
                type: "POST",
                url: "Permission.aspx/SavePermission",
                data: JSON.stringify({
                    personnelId: personnelId,
                    pageIds
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (msg.d.Result == false) {//خطا داریم
                        ShowError(msg.d.Message);
                    }
                    else {
                        toastr.success("ثبت دسترسی ها با موفقیت انجام شد");
                    }
                },
                error: function () {
                    toastr.error("خطا", "خطا");
                }
            });
        }
        function GetPermissions(id) {
            personnelId = id;
            $.ajax({
                type: "POST",
                url: "Permission.aspx/GetPermissions",
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
                        document.getElementById("pagess").innerHTML = msg.d.Pages;
                    }
                },
                error: function () {
                    toastr.error("خطا", "خطا");
                }
            });
        };
        document.querySelectorAll(".employee-item").forEach((item) => {
            item.addEventListener("click", function () {
                document.querySelectorAll(".employee-item").forEach(e => e.classList.remove("active"));
                this.classList.add("active");
                var userId = this.getAttribute("data-id");
                GetPermissions(userId);
            });
        });
    </script>
</asp:Content>

