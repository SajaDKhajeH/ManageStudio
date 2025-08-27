<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PayResult.aspx.cs" Inherits="AdakStudio.PayResult" %>

<!DOCTYPE html>

<html lang="en" direction="rtl" dir="rtl" style="direction: rtl">
<head>
    <base href="../../../">
    <title>نتیجه پرداخت</title>
    <meta name="description" content="" />
    <meta name="keywords" content="آتلیه" />
    <meta charset="utf-8" />
    <meta property="og:locale" content="en_US" />
    <meta property="og:type" content="article" />
    <meta property="og:title" content="سامانه مدیریت آتلیه" />
    <meta property="og:url" content="https://keenthemes.com/metronic" />
    <meta property="og:site_name" content="Keenthemes | Metronic" />
    <link rel="canonical" href="https://preview.keenthemes.com/metronic8" />
    <link rel="shortcut icon" href="<%Response.Write(SpecialStudio.Logo); %>" />
    <!--begin::Fonts-->

    <%--<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" />--%>
    <!--end::Fonts-->
    <!--begin::Global Stylesheets Bundle(used by all pages)-->
    <link href="assets/plugins/global/plugins.bundle.rtl.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/style.bundle.rtl.css" rel="stylesheet" type="text/css" />
    <style>
        @font-face {
            font-family: 'ISW';
            src: url('assets/Fonts/IRANSANSWEB.TTF');
        }

        body {
            font-family: 'ISW', Tahoma, sans-serif;
            direction: rtl;
            background-color: #f8f9fa;
        }

        .payment-container {
            max-width: 450px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .payment-logo {
            max-width: 100px;
            margin-bottom: 20px;
        }

        .payment-btn {
            width: 100%;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <img src="<%Response.Write(SpecialStudio.Logo); %>" alt="لوگوی آتلیه" class="payment-logo">
        <h3 class="fw-bold"><%Response.Write(Settings.StudioName); %></h3>
        <hr>
        <div id="divMain">

        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html>
<script type="text/javascript">

    $(document).ready(function () {

        let params = new URLSearchParams(document.location.search);
        let t = params.get("tran");
        let a = params.get("Authority");
        let s = params.get("Status");

        $.ajax({
            type: "POST",
            url: "Api/Payment/SetResult",
            data: JSON.stringify({ tran: t, authority: a, status: s }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                if (!res.Success) {
                    let html = '';
                    html +=
                        `
                        <h5 class="text-danger"><span class="fw-bold">❌${res.Message} </span></h5>
                    `;
                    html +=
                        `
                        <h5 class="text-danger"><span class="fw-bold">شماره پیگیری:</span></h5>
                        <h5 class="text-danger"><span class="fw-bold">${t}</span></h5>
                        <hr>
                    `;
                    html +=
                        `
                        <h5 class="text-danger"><span class="fw-bold">شناسه تراکنش:</span></h5>
                        <h5 class="text-danger"><span class="fw-bold">${a}</span></h5>
                        <hr>
                    `;
                    $('#divMain').html(html);
                } else {
                    let d = res.Data;
                    let html = '';
                    html +=
                        `
                        <h5 class="text-success"><span class="fw-bold">✅${d.Description} </span></h5>
                    `;
                    html +=
                        `
                        <h5 class="text-success"><span class="fw-bold">زمان تراکنش:</span></h5>
                        <h5 class="text-success"><span class="fw-bold">${d.DateTime}</span></h5>
                        <hr>
                    `;
                    html +=
                        `
                        <h5 class="text-success"><span class="fw-bold">مبلغ:</span></h5>
                        <h5 class="text-success"><span class="fw-bold">${d.Price}</span></h5>
                        <hr>
                    `;
                    html +=
                        `
                        <h5 class="text-success"><span class="fw-bold">شماره پیگیری:</span></h5>
                        <h5 class="text-success"><span class="fw-bold">${d.RefId}</span></h5>
                        <hr>
                    `;

                    $('#divMain').html(html);
                }
            },
            error: function () {
                alert("خطا در دریافت اطلاعات پرداخت");
            }
        });

    });

</script>
