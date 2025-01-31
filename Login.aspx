<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="AdakStudio.Login" %>

<!DOCTYPE html>

<html lang="en" direction="rtl" dir="rtl" style="direction: rtl">
<head>
    <base href="../../../">
    <title>سامانه محیا</title>
    <meta name="description" content="" />
    <meta name="keywords" content="Metronic, bootstrap, bootstrap 5, Angular, VueJs, React, Laravel, admin themes, web design, figma, web development, free templates, free admin themes, bootstrap theme, bootstrap template, bootstrap dashboard, bootstrap dak mode, bootstrap button, bootstrap datepicker, bootstrap timepicker, fullcalendar, datatables, flaticon" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <meta property="og:locale" content="en_US" />
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Metronic - Bootstrap 5 HTML, VueJS, React, Angular &amp; Laravel Admin Dashboard Theme" />
    <meta property="og:url" content="https://keenthemes.com/metronic" />
    <meta property="og:site_name" content="Keenthemes | Metronic" />
    <link rel="canonical" href="https://preview.keenthemes.com/metronic8" />
    <link rel="shortcut icon" href="assets/logo/logo.jpeg" />
    <!--begin::Fonts-->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" />
    <!--end::Fonts-->
    <!--begin::Global Stylesheets Bundle(used by all pages)-->
    <link href="assets/plugins/global/plugins.bundle.rtl.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/style.bundle.rtl.css" rel="stylesheet" type="text/css" />
    <style>
        @font-face {
            font-family: 'ISW_Login';
            src: url('assets/Fonts/IRANSANSWEB.TTF');
        }

        body {
            font-family: 'ISW_Login', Tahoma, sans-serif;
            background-color: #f5f5f5;
            direction: rtl;
            margin: 50px;
        }
    </style>
    <!--end::Global Stylesheets Bundle-->
</head>
<body id="kt_body" class="bg-body">
    <!--begin::Main-->
    <div class="d-flex flex-column flex-root">
        <!--begin::Authentication - Sign-in -->
        <div class="d-flex flex-column flex-column-fluid bgi-position-y-bottom position-x-center bgi-no-repeat bgi-size-contain bgi-attachment-fixed" style="background-image: url(assets/media/illustrations/sketchy-1/14.png)">
            <!--begin::Content-->
            <div class="d-flex flex-center flex-column flex-column-fluid p-10 pb-lg-20">
                <!--begin::Logo-->
                <a class="mb-15">
                    <img alt="Logo" src="assets/logo/logo.jpeg" class="h-150px" />
                </a>
                <!--end::Logo-->
                <!--begin::Wrapper-->
                <div class="w-lg-500px bg-body rounded shadow-sm p-10 p-lg-15 mx-auto">
                    <div class="text-center mb-10">
                        <!--begin::Title-->
                        <h1 class="text-dark mb-3">ورود به سامانه محیا</h1>
                    </div>

                    <!-- انتخاب نوع کاربر -->
                    <div class="fv-row mb-10">

                        <div class="row g-9 mb-7">
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="ra_staff" class="form-check-input" name="userType" type="radio" checked />
                                        <span class="form-check-label fw-bold text-dark">کادر آتلیه</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 fv-row">
                                <div class="d-flex flex-stack" style="margin: 3px">
                                    <label class="form-check form-switch form-check-custom form-check-solid">
                                        <input id="ra_customer" class="form-check-input" name="userType" type="radio" />
                                        <span class="form-check-label fw-bold text-dark">خانواده</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- فرم ورود پرسنل -->
                    <div id="staff-login" class="user-login">
                        <div class="fv-row mb-10">
                            <label class="form-label fs-6 fw-bolder text-dark">نام کاربری</label>
                            <input class="form-control form-control-lg form-control-solid" type="text" id="username" autocomplete="off" />
                        </div>
                        <div class="fv-row mb-10">
                            <div class="d-flex flex-stack mb-2">
                                <label class="form-label fw-bolder text-dark fs-6 mb-0">رمز عبور</label>
                            </div>
                            <input class="form-control form-control-lg form-control-solid" type="password" id="password" autocomplete="off" />
                        </div>
                        <div class="text-center">
                            <button id="btn_Login" class="btn btn-lg btn-primary w-100 mb-5">ورود</button>
                        </div>
                    </div>

                    <!-- فرم ورود مشتری -->
                    <div id="customer-login" class="user-login" style="display: none;">
                        <div class="fv-row mb-12">
                            <label class="form-label fs-6 fw-bolder text-dark">شماره موبایل</label>
                            <input class="form-control form-control-lg form-control-solid" type="text" id="phone" autocomplete="off" />
                        </div>
                        <div class="fv-row mb-12">
                            <div class="col-lg-5 col-md-10 col-sm-5 col-10 p-3 form-group m-0">
                                <input type="number" name="capchaCode" pattern="[0-9]*" inputmode="numeric" class="dir-ltr form-control change-align" id="capchaCode" autocomplete="off" placeholder="کد را وارد کنید">
                            </div>
                            <div class="col-lg-5 col-md-10 col-sm-5 col-10 p-3">
                                <%Response.Write(CaptchaImage());%>
                                <i id="reGenerate" onclick="RegenerateCaptchaImage();" class="fa fa-sync mr-2 align-middle text-dark"></i>
                            </div>
                        </div>
                        <div class="text-center">
                            <button id="btn_SendOTP" class="btn btn-lg btn-primary w-100 mb-5">ارسال کد تأیید</button>
                        </div>
                        <div class="fv-row mb-10" id="otp-section" style="display: none;">
                            <label class="form-label fs-6 fw-bolder text-dark">کد تأیید</label>
                            <input class="form-control form-control-lg form-control-solid" type="text" id="otp" autocomplete="off" />
                            <div class="text-center">
                                <button id="btn_VerifyOTP" class="btn btn-lg btn-primary w-100 mb-5">ورود</button>
                            </div>
                        </div>
                    </div>
                    <!--end::Actions-->
                </div>
                <!--end::Wrapper-->
            </div>
            <!--end::Content-->
            <!--begin::Footer-->
            <div class="d-flex flex-center flex-column-auto p-10">
                <!--begin::Links-->
                <div class="d-flex align-items-center fw-bold fs-6">
                </div>
                <!--end::Links-->
            </div>
            <!--end::Footer-->
        </div>
        <!--end::Authentication - Sign-in-->
    </div>

    <%--<div class="d-flex flex-column flex-root">
        <!--begin::Authentication - Sign-in -->
        <div class="d-flex flex-column flex-column-fluid bgi-position-y-bottom position-x-center bgi-no-repeat bgi-size-contain bgi-attachment-fixed" style="background-image: url(assets/media/illustrations/sketchy-1/14.png">
            <!--begin::Content-->
            <div class="d-flex flex-center flex-column flex-column-fluid p-10 pb-lg-20">
                <!--begin::Logo-->
                <a class="mb-15">
					<img alt="Logo" src="assets/logo/logo.jpeg" class="h-150px" />
				</a>
                <!--end::Logo-->
                <!--begin::Wrapper-->
                <div class="w-lg-500px bg-body rounded shadow-sm p-10 p-lg-15 mx-auto">
                    <div class="text-center mb-10">
                        <!--begin::Title-->
                        <h1 class="text-dark mb-3">ورود به سامانه محیا</h1>
                    </div>
                    <div class="fv-row mb-10">
                        <label class="form-label fs-6 fw-bolder text-dark">نام کاربری</label>
                        <input class="form-control form-control-lg form-control-solid" type="text" id="username" autocomplete="off" />
                    </div>
                    <div class="fv-row mb-10">
                        <div class="d-flex flex-stack mb-2">
                            <label class="form-label fw-bolder text-dark fs-6 mb-0">رمز عبور</label>
                        </div>
                        <input class="form-control form-control-lg form-control-solid" type="password" id="password" autocomplete="off" />
                    </div>
                    <div class="text-center">
                        <button id="btn_Login" class="btn btn-lg btn-primary w-100 mb-5">
                            ورود
                        </button>
                    </div>
                    <!--end::Actions-->

                    <!--end::Form-->
                </div>
                <!--end::Wrapper-->
            </div>
            <!--end::Content-->
            <!--begin::Footer-->
            <div class="d-flex flex-center flex-column-auto p-10">
                <!--begin::Links-->
                <div class="d-flex align-items-center fw-bold fs-6">
                </div>
                <!--end::Links-->
            </div>
            <!--end::Footer-->
        </div>
        <!--end::Authentication - Sign-in-->
    </div>--%>
    <!--end::Main-->
    <script>var hostUrl = "assets/";</script>
    <!--begin::Javascript-->
    <!--begin::Global Javascript Bundle(used by all pages)-->
    <script src="assets/plugins/global/plugins.bundle.js"></script>
    <script src="assets/js/scripts.bundle.js"></script>
    <!--end::Global Javascript Bundle-->
    <!--begin::Page Custom Javascript(used by this page)-->
    <script src="assets/js/custom/authentication/sign-in/general.js"></script>
    <!--end::Page Custom Javascript-->
    <!--end::Javascript-->
</body>
</html>
<script type="text/javascript">
    //====دریافت مجدد کپچا====\\
    function RegenerateCaptchaImage() {
        $.ajax({
            type: "POST",
            url: "Login.aspx/RegenerateCaptchaImage",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var model = msg.d;
                $("#captcha59").attr("ak_ID", model.ak_ID);
                $("#captcha59").attr("src", model.src);
            },
            error: function (xhr) {
                checkError(xhr.responseText);
            }
        });
    }
    // بررسی CAPTCHA کاربر
    document.getElementById('btn_SendOTP').addEventListener('click', function () {
        var phoneNumber = $("#phone").val();
        var captchaId = $("#captcha59").attr("ak_ID");
        let capcha = $("#capchaCode").val();

        let btn = $(this).find("button[type='submit']");
        btnLoader(btn, true, true);
        $.ajax({
            type: "POST",
            url: "Login.aspx/MobileValidation",
            data: "{captchaID:'" + captchaId + "',mobile:'" + phoneNumber + "',captchaCode:'" + capcha + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                btnLoader(btn, false, true);
                var res = msg.d;

                if (res.Success) {
                    document.getElementById('otp-section').style.display = 'block';
                }
                else {
                    toastr.error(res.ErrorMessage)

                }
            },
            error: function (xhr) {
                ShowError(xhr.responseText);
                btnLoader(btn, false, true);

            }
        });
    });
    document.querySelectorAll('input[name="userType"]').forEach((input) => {
        input.addEventListener('change', function () {
            var staffSelect = $("#ra_staff").prop("checked");
            var customerSelect = $("#ra_customer").prop("checked");
            document.getElementById('staff-login').style.display = staffSelect ? 'block' : 'none';
            document.getElementById('customer-login').style.display = customerSelect ? 'block' : 'none';
        });
    });
    $("#btn_Login").click(function () {
        var username = $("#username").val();
        var password = $("#password").val();
        $.ajax({
            type: "POST",
            url: "Api/Login/Login",
            data: "{UserName:'" + username + "',Password:'" + password + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                if (res.Success) {
                    location.href = res.Message;
                } else {
                    alert(res.Message);
                }
            },
            error: function () {
                alert("error");
            }
        });
    });
    $(document).ready(function () {
        $("#ra_staff").prop("checked", true);
        $("#username").val("");
        $("#password").val("");
    });
</script>
