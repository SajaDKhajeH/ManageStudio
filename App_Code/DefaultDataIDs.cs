using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DefaultDataIDs
/// </summary>
public class DefaultDataIDs
{
    public static long DefaultSMS_Wellcome_ToFamily = 15;
    public static long DefaultSMS_Wellcome_ToFamily_FromHospital = 34;
    public static long DefaultSMS_AfterSetFactor = 18;
    public static long DefaultSMS_WaitForAcceptCustomer= 55;
    public static long DefaultSMS_CancelTurn = 65;
    public static long DefaultSMS_ReadyToDeliveredToCustomer = 56;
    public static long SMSTypeId_Wellcome_ToFamily = 16;
    public static long SMSTypeId_Wellcome_ToFamily_FromHospital = 35;
    public static long SMSTypeId_AfterSetFactor = 17;
    public static long Role_Designer = 6;
    public static long Role_Family =-1;
    public static long Role_DesignSupervisor = 3;
    public static long Role_Photographer = 7;
    public static long Role_Admin = 4;
    public static long Role_PhotographerInHospital = 33;
    /// <summary>
    /// منشی
    /// </summary>
    public static long Role_Secretary = 5;

    public static int DataType_FactorStatus = 11;
    public static int DataType_TurnType = 10;
    public static int DataType_SMSType = 8;
    public static int DataType_InviteType = 6;
    public static int DataType_Bank = 14;
    public static int DataType_PaidType = 9;
    public static int DataType_Role = 3;
    public static int DataType_Hospital = 12;
    public static int DataType_CostType = 13;
    public static int DataType_Location = 15;
    public static int DataType_State = 1;
    public static int DataType_DefaultSMS = 7;
    /// <summary>
    /// وضعیت فاکتور آماده برای طراحی
    /// </summary>
    public static int FactorStatus_ReadyForDesign = 26;
    /// <summary>
    /// وضعیت فاکتور ناقص
    /// </summary>
    public static int FactorStatus_IncompleteFactor = 25;
    /// <summary>
    /// بیعانه نداده
    /// </summary>
    public static int FactorStatus_WaitForPaid = 24;
    /// <summary>
    /// ارسال به چاپ خانه
    /// </summary>
    public static int FactorStatus_SendTo_PrintingHouse = 29;
    /// <summary>
    /// ارسال به چاپ خانه
    /// </summary>
    public static int FactorStatus_DeliveredToCustomer = 30;
    /// <summary>
    /// ارسال به چاپ خانه
    /// </summary>
    public static int FactorStatus_UnderDesign = 27;
    /// <summary>
    /// در انتظار تایید مشتری
    /// </summary>
    public static int FactorStatus_WaitForAcceptCustomer = 28;
    /// <summary>
    /// آماده تحویل
    /// </summary>
    public static int FactorStatus_ReadyToDelivered = 51;


    #region SettingKeys
    public static string Setting_ApiKeyKavenegar { get; set; } = "ApiKeyKavenegar";
    public static string Setting_SenderKavenegar { get; set; } = "SenderKavenegar";
    public static string Setting_MinimumPaymentPercentage_for_ReadyToDesign { get; set; } = "MinimumPaymentPercentage_for_ready-to-design";
    public static string Setting_Studio_Name { get; set; } = "Studio_Name";
    #endregion



}