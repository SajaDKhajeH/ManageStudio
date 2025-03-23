<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="CustomerOrders.aspx.cs" Inherits="CustomerOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container mt-10">
        <div class="accordion" id="ordersAccordion">
            <%Response.Write(GetOrders()); %>
        </div>
    </div>
    <%--<span class='ms-2 text-success fw-'></span>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="End" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#master_PageTitle").text("سفارش های من");
        });
    </script>
</asp:Content>

