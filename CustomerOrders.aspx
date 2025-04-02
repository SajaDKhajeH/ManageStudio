<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="CustomerOrders.aspx.cs" Inherits="CustomerOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <style>
        #payOnlineBtn {
            width: fit-content;
            padding: 8px 16px;
            font-size: 14px;
            display: block;
            margin: 10px auto 0; /* وسط‌چین کردن دکمه */
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container mt-10">
        <div class="card p-3 mb-4 shadow-sm">
            <%Response.Write(Summery()); %>
            <%--<div class="row g-3">
                <div class="col-md-3"><strong>مجموع سفارش‌ها:</strong> <span id="totalOrders">0</span> تومان</div>
                <div class="col-md-3"><strong>مجموع تخفیف‌ها:</strong> <span id="totalDiscounts">0</span> تومان</div>
                <div class="col-md-3"><strong>مجموع پرداختی‌ها:</strong> <span id="totalPayments">0</span> تومان</div>
                <div class="col-md-3"><strong>مانده حساب:</strong> <span id="accountBalance" class="fw-bold text-danger">0</span> تومان</div>
            </div>
            <button id="payOnlineBtn" class="btn btn-success d-none">پرداخت آنلاین</button>--%>
        </div>
        <div class="accordion" id="ordersAccordion">
            <%Response.Write(GetOrders()); %>
        </div>
    </div>
    <%--<span class='ms-2 text-success fw-'></span>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">
        function PayOnline() {
            $.ajax({
                type: "POST",
                url: "CustomerOrders.aspx/PayOnline",
                data: JSON.stringify({}),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    sampleAppointments = msg.d;
                },
                error: function () {
                    toastr.error("خطا در دریافت اطلاعات", "خطا");
                    sampleAppointments = [];
                }
            });
        };
        $(document).ready(function () {
            $("#master_PageTitle").text("سفارش های من");
        });
    </script>
</asp:Content>

