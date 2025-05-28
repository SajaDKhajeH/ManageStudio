<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="AdakStudio.Login" %>

<!DOCTYPE html>

<html lang="en" direction="rtl" dir="rtl" style="direction: rtl">
<head>
    <base href="../../../">
    <title><%Response.Write(EnamadInfo.Title);%></title>
    <meta name="description" content="" />
    <meta name="keywords" content="آتلیه" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <meta property="og:locale" content="en_US" />
    <meta property="og:type" content="article" />
    <meta property="og:title" content="<%Response.Write(EnamadInfo.Title);%>" />
    <%Response.Write(EnamadInfo.MetaTag);%>
    <meta property="og:url" content="https://keenthemes.com/metronic" />
    <meta property="og:site_name" content="Keenthemes | Metronic" />
    <link rel="canonical" href="https://preview.keenthemes.com/metronic8" />
    <link rel="shortcut icon" href="<%Response.Write(SpecialStudio.Logo); %>" />
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
    <div class="d-flex flex-column flex-root">
        <div class="d-flex flex-column flex-column-fluid bgi-position-y-bottom position-x-center bgi-no-repeat bgi-size-contain bgi-attachment-fixed" style="background-image: url(assets/media/illustrations/sketchy-1/14.png)">
            <div class="d-flex flex-center flex-column flex-column-fluid p-10 pb-lg-20">
                <a class="mb-15">
                    <img id="logo" alt="Logo" class="h-150px" />
                </a>
                <div class="w-lg-500px bg-body rounded shadow-sm p-10 p-lg-15 mx-auto">
                    <div class="text-center mb-10">
                        <h1 id="studioName" class="text-dark mb-3"></h1>
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
                            <button id="btn_Login" onclick="LoginToPortal()" class="btn btn-lg btn-primary w-100 mb-5">ورود</button>
                        </div>
                    </div>

                    <!-- فرم ورود مشتری -->
                    <div id="customer-login" class="user-login" style="display: none;">
                        <div class="fv-row mb-12">
                            <label class="form-label fs-6 fw-bolder text-dark">شماره موبایل</label>
                            <input class="form-control form-control-lg form-control-solid" type="text" id="phone" autocomplete="off" />
                        </div>
                        <div class="fv-row mb-12 CaptchaDiv">
                            <div class="col-lg-5 col-md-10 col-sm-5 col-10 p-3 form-group m-0">
                                <input type="number" name="capchaCode" pattern="[0-9]*" inputmode="numeric" class="dir-ltr form-control change-align" id="capchaCode" autocomplete="off" placeholder="کد را وارد کنید">
                            </div>
                            <div class="col-lg-5 col-md-10 col-sm-5 col-10 p-3">
                                <%Response.Write(CaptchaImage());%>
                                <i id="reGenerate" onclick="RegenerateCaptchaImage();" class="fa fa-sync mr-2 align-middle text-dark"></i>
                            </div>
                        </div>
                        <div class="text-center CaptchaDiv">
                            <button id="btn_SendOTP" class="btn btn-lg btn-primary w-100 mb-5">ارسال کد تأیید</button>
                        </div>
                        <div class="fv-row mb-10" id="otp-section" style="display: none;">
                            <%--<label class="form-label fs-6 fw-bolder text-dark">کد تأیید</label>--%>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-label fs-6 fw-bolder text-dark">کد تأیید</label>
                                <a href="javascript:void(0);" onclick="ChangePhoneNumber();" class="text-primary fw-bold small">تغییر شماره موبایل؟</a>
                            </div>
                            <input id="otp_code" class="form-control form-control-lg form-control-solid" type="text" autocomplete="off" />
                            <br />
                            <div class="text-center">
                                <button id="btn_VerifyOTP" onclick="LoginToPortal()" class="btn btn-lg btn-primary w-100 mb-5">ورود</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex flex-center flex-column-auto p-10">
                <div class="d-flex align-items-center fw-bold fs-6">
                </div>
            </div>
        </div>
    </div>

    <script>var hostUrl = "assets/";</script>
    <script src="assets/plugins/global/plugins.bundle.js"></script>
    <script src="assets/js/scripts.bundle.js"></script>
    <script src="assets/js/custom/authentication/sign-in/general.js"></script>
</body>
</html>
<script type="text/javascript">
    let baseUrl = '<%=Constants.BaseApiUrl%>';

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
    function ChangePhoneNumber() {
        document.getElementById("otp-section").style.display = "none";
        var elements = document.getElementsByClassName("CaptchaDiv");
        for (var i = 0; i < elements.length; i++) {
            elements[i].style.display = 'block';
        }
        RegenerateCaptchaImage();
        $("#capchaCode").val("");
        $("#phone").focus();
    }
    // بررسی CAPTCHA کاربر
    document.getElementById('btn_SendOTP').addEventListener('click', function () {
        var phoneNumber = $("#phone").val();
        var captchaId = $("#captcha59").attr("ak_ID");
        let capcha = $("#capchaCode").val();

        $.ajax({
            type: "POST",
            url: "Login.aspx/MobileValidation",
            data: "{captchaID:'" + captchaId + "',mobile:'" + phoneNumber + "',captchaCode:'" + capcha + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var res = msg.d;
                if (res.Success) {
                    document.getElementById('otp-section').style.display = 'block';
                    toastr.success("کد تایید ارسال شد");
                    //$("#otp_code").val(res.acceptCode);
                    var elements = document.getElementsByClassName("CaptchaDiv");
                    for (var i = 0; i < elements.length; i++) {
                        elements[i].style.display = 'none';
                    }
                }
                else {
                    toastr.error(res.ErrorMessage);

                }
            },
            error: function (xhr) {
                ShowError(xhr.responseText);

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
    function LoginToPortal() {
        var staffSelect = $("#ra_staff").prop("checked");
        if (staffSelect) {
            var username = $("#username").val();
            var password = $("#password").val();
            loginStaffAsync(username, password);
        } else {
            var phoneNumber = $("#phone").val();
            loginFamilyAsync(phoneNumber);
        }
    };
    function loginFamilyAsync(phoneNumber) {
        alert(phoneNumber);
        //CustomerOrders.aspx
    }
    function loginStaffAsync(username, password) {
        let data =
        {
            username: username,
            password: password
        };
        $.ajax({
            type: "POST",
            url: baseUrl + "/Authentication/Login",
            data: JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                if (res.success) {
                    let role = res.data.roles[0];
                    saveLocalStorage('login', JSON.stringify({
                        token: res.data.token,
                        role: role
                    }), 90000);
                    let redirectPage = '';
                    if (role == 'Admin') {
                        redirectPage = 'Dashboard.aspx';
                    } else if (role == 'Secretary') {
                        //GoToPage = AdakDB.Db.usp_Page_Select(LoginId).ToList().Where(x => (x.P_ShowOnMenu ?? false) && x.HasPermission == 1).ToList().OrderBy(b => b.P_Sort).FirstOrDefault().P_Url;
                    } else if (role == 'Photographer') {
                        redirectPage = 'AddFamilyFromHospital.aspx';
                    } else if (role == 'DesignSupervisor' || role == 'Designer') {
                        redirectPage = 'RequestStatus.aspx';
                    }
                    location.href = redirectPage;
                } else {
                    alert(res.message);
                }
            },
            error: function () {
                alert("error");
            }
        });
    }
    let cachePreKey = '';
    function saveLocalStorage(key, data, expireAfterSec) {
    <%--    if (cachePreKey == '') {
            cachePreKey = '<%Response.Write(DefaultId.Causer);%>';
         }--%>
         const expireDate = new Date();
         if (!expireAfterSec)
             expireAfterSec = 90
         expireDate.setSeconds(expireDate.getSeconds() + expireAfterSec);
         var lsData = {
             data: data,
             expire: expireDate.toUTCString()
        };
        if (cachePreKey != '') {
            key = cachePreKey + '_' + key;
        }
         localStorage.setItem(key, JSON.stringify(lsData));
    }
    function getLocalStorage(key) {
        let cache = localStorage.getItem(key);
        if (cache == null)
            return null;
        let data = JSON.parse(cache);
        return data.data;
        //const now = new Date();
        //if (data.expire < now.toUTCString()) {
        //    return null;
        //}
        //else {
        //    return data.data;
        //}
    }
    function getStudioName() {
        $('#logo').attr('src', `Files/${window.location.hostname}/Logo/logo.png`);
        let name = getLocalStorage('studioName');
        if (!name) {
            ajaxGet('/Setting/StudioName', function (res) {
                name = res;
                saveLocalStorage('studioName', name, 600);
                $('#studioName').html(name);
            });
            return;
        }
        $('#studioName').html(name);
        
    }
    function ajaxGet(route, success, error) {
        $.ajax({
            type: 'GET',
            url: baseUrl + route,
            success: success,
            error: function (err) {
                console.log(err);
                alert('err');
            }
        });
    }
    $(document).ready(function () {
        getStudioName();
        $("#ra_staff").prop("checked", true);
        $("#username").val("");
        $("#password").val("");
        var elements = document.getElementsByClassName("CaptchaDiv");
        for (var i = 0; i < elements.length; i++) {
            elements[i].style.display = 'block';
        }
    });
</script>
