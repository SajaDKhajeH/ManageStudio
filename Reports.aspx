<%@ Page Title="" Language="C#" MasterPageFile="~/MasPage.Master" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="post d-flex flex-column-fluid" id="kt_post">
        <div id="kt_content_container" class="container-xxl">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="container">
                        <div class="container mt-5">
                            <div class="row mb-3">
                                <h5 style="color: red">*در گزارش ها فقط فاکتورهایی محاسبه می شوند که آرشیو نشده باشند.</h5>
                                <h5 style="color: red">*اگر وضعیت فاکتور انتخاب شود تمامی فاکتورها با اون وضعیت و بعد از وضعیت انتخابی رو در خروجی نمایش می دهد.</h5>
                                <h5 style="color: red">*کلید آرشیو کردن و عدم آرشیو براساس فیلترها عمل میکنند.</h5>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-2">
                                    <label class="fs-6 fw-bold mb-2">از تاریخ</label>
                                    <input class="form-control datepicker" placeholder="از تاریخ" id="Reports_From_Date">
                                </div>
                                <div class="col-md-2">
                                    <label class="fs-6 fw-bold mb-2">تا تاریخ</label>
                                    <input class="form-control datepicker" placeholder="تا تاریخ" id="Reports_To_Date">
                                </div>
                                <div class="col-md-2">
                                    <label class="fs-6 fw-bold mb-2">وضعیت فاکتور</label>
                                    <select id="Reports_factorStatus">
                                        <%Response.Write(PublicMethod.GetFactorStatusAll(true)); %>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="fs-6 fw-bold mb-2">.</label>
                                    <button onclick="ChangeArchive_Factors(true)" class="btn btn-danger w-100">آرشیو کردن</button>
                                </div>
                                <div class="col-md-2">
                                    <label class="fs-6 fw-bold mb-2">.</label>
                                    <button onclick="ChangeArchive_Factors(false)" class="btn btn-danger w-100">عدم آرشیو</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                    <button id="rpt_factors" onclick="Report_AllFactors()" class="btn btn-primary w-100">گزارش کلی فاکتورها</button>
                                </div>
                                <div class="col-md-3">
                                    <button id="rpt_Soodkalaha" onclick="Report_ProductProfit()" class="btn btn-primary w-100">گزارش سود کالاها</button>
                                </div>
                                <div class="col-md-4">
                                    <button id="rpt_ComputedPersonnelSalary" onclick="Report_PerformancePersonnel()" class="btn btn-primary w-100">گزارش عملکرد  طراح, عکاس و فاکتور زن</button>
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
        const fromdate = document.getElementById('Reports_From_Date');
        const todate = document.getElementById('Reports_To_Date');
        const factorStatus = document.getElementById('Reports_factorStatus');
        function Report_AllFactors() {
            $.ajax({
                type: "POST",
                url: "Reports.aspx/Report_AllFactors",
                data: JSON.stringify({
                    fromdate: fromdate.value, todate: todate.value, factorStatus: factorStatus.value
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (res.Result) {
                        setTimeout(function () {
                            window.open(res.Url, '_blank').focus();
                        }, 110);
                    }
                    else {
                        alert(res.Message);
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function Report_ProductProfit() {
            $.ajax({
                type: "POST",
                url: "Reports.aspx/Report_ProductProfit",
                data: JSON.stringify({
                    fromdate: fromdate.value, todate: todate.value, factorStatus: factorStatus.value
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (res.Result) {
                        setTimeout(function () {
                            window.open(res.Url, '_blank').focus();
                        }, 110);
                    }
                    else {
                        alert(res.Message);
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function Report_PerformancePersonnel() {
            $.ajax({
                type: "POST",
                url: "Reports.aspx/Report_PerformancePersonnel",
                data: JSON.stringify({
                    fromdate: fromdate.value, todate: todate.value, factorStatus: factorStatus.value
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    if (res.Result) {
                        setTimeout(function () {
                            window.open(res.Url, '_blank').focus();
                        }, 110);
                    }
                    else {
                        alert(res.Message);
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        }
        function ChangeArchive_Factors(archive) {
            $.ajax({
                type: "POST",
                url: "Reports.aspx/ChangeArchive_Factors",
                data: JSON.stringify({
                    fromdate: fromdate.value, todate: todate.value, factorStatus: factorStatus.value, archive: archive
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = msg.d;
                    toastr.success(msg.d.Message, "موفق");
                },
                error: function () {
                    alert("error");
                }
            });
        }
        $(document).ready(function () {
            $("#master_PageTitle").text("گزارش ها");
            $('#Reports_From_Date').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: false,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
            $('#Reports_To_Date').persianDatepicker({
                format: 'YYYY/MM/DD',
                initialValue: false,
                autoClose: true,
                calendar: {
                    persian: {
                        locale: 'fa'
                    }
                }
            });
        });
    </script>
</asp:Content>

