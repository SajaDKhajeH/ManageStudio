<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pay.aspx.cs" Inherits="AdakStudio.Pay" %>

<!DOCTYPE html>

<html lang="en" direction="rtl" dir="rtl" style="direction: rtl">
<head>
   <base href="../../../">
    <title>پرداخت آنلاین</title>
    <meta name="description" content="" />
    <meta name="keywords" content="آتلیه" />
    <meta charset="utf-8" />
    <meta property="og:locale" content="en_US" />
    <meta property="og:type" content="article" />
    <meta property="og:title" content="سامانه مدیریت آتلیه" />
    <meta property="og:url" content="https://keenthemes.com/metronic" />
    <meta property="og:site_name" content="Keenthemes | Metronic" />
    <link rel="canonical" href="https://preview.keenthemes.com/metronic8" />
    <link rel="shortcut icon" href="Files/Logo/logo.jpeg" />
    <!--begin::Fonts-->

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" />
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
        <img src="Files/Logo/logo.jpeg" alt="لوگوی آتلیه" class="payment-logo">
        <h3 class="fw-bold"><%Response.Write(Settings.StudioName); %></h3>
        <hr>
        <h5 class="text-primary">نام خانواده: <span class="fw-bold" id="familyTitle"></span></h5>
        <h5 class="text-danger">مبلغ قابل پرداخت: <span class="fw-bold" id="payPrice"></span></h5>
         <hr>
        <button onclick="GoToPayment()" class="btn btn-primary payment-btn">پرداخت</button>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>  
</html>
<script type="text/javascript">
    var k = "";
    function GoToPayment() {
        $.ajax({
            type: "POST",
            url: "Pay.aspx/GoToPayment",
            data: JSON.stringify({ key: k }), // مقدار را درست ارسال کنید
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var res = msg.d;
                if (!res.Result) {
                    $("#familyTitle").text(""); // مقدار را درست ست کنید
                    $("#payPrice").text("");
                    alert(res.Message);
                } else {
                    $("#familyTitle").text(res.FamilyTitle); // مقدار را درست ست کنید
                    $("#payPrice").text(res.Price);
                }
            },
            error: function () {
                alert("خطا در دریافت اطلاعات پرداخت");
            }
        });
    }
    $(document).ready(function () {
        
        let params = new URLSearchParams(document.location.search);
        k = params.get("p");

        $.ajax({
            type: "POST",
            url: "Pay.aspx/SendSMS_PayLink",
            data: JSON.stringify({ key: k }), // مقدار را درست ارسال کنید
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var res = msg.d;
                if (!res.Result) {
                    $("#familyTitle").text(""); // مقدار را درست ست کنید
                    $("#payPrice").text("");
                    alert(res.Message);
                } else {
                    $("#familyTitle").text(res.FamilyTitle); // مقدار را درست ست کنید
                    $("#payPrice").text(res.Price);
                }
            },
            error: function () {
                alert("خطا در دریافت اطلاعات پرداخت");
            }
        });
        
    });
    
</script> 
