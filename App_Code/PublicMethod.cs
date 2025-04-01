using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PublicMethod
/// </summary>
public class PublicMethod
{

    public static string Pagination()
    {
        string html = "";
        html = @"<option value='5' selected>5 تا</option>
                 <option value='10'>10 تا</option>
                <option value='20'>20 تا</option>
                <option value='50'>50 تا</option>
                <option value='100'>100 تا</option>
                <option value='500'>500 تا</option>
                <option value='1000000'>همه موارد</option>";
        return html;
    }
    public static string GetProducts()
    {
        string htmls = "";
        var groups = AdakDB.Db.usp_ProductGroup_Select_Active().ToList();
        groups = groups ?? new List<Bank.usp_ProductGroup_Select_ActiveResult>();
        var products = AdakDB.Db.usp_Product_Select_for_Set_Factor().ToList();
        products = products ?? new List<Bank.usp_Product_Select_for_Set_FactorResult>();
        foreach (var g in groups)
        {
            htmls += @"<button class='button' onclick='toggleChildButtons(this)'>" + g.PG_Title + @"</button>";
            var pro = products.Where(a => a.Pro_GroupId == g.PG_ID).OrderBy(a => a.Pro_Priority).ToList();
            pro = pro ?? new List<Bank.usp_Product_Select_for_Set_FactorResult>();
            htmls += @"<div class='child-buttons'>";
            for (int i = 0; i < pro.Count; i++)
            {
                htmls += @"<button class='child-button' onclick='addItem(" + pro[i].Pro_ID + @"," + pro[i].SalePrice + @",""" + pro[i].Pro_Title + @""",""" + g.PG_Title + @""")'>" + pro[i].Pro_Title + @"</button>";
            }
            htmls += "</div>";
        }
        return htmls;
    }
    public static string GetState()
    {
        string htmls = "<option>انتخاب استان</option>";
        var dataType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_State).ToList();

        dataType = dataType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in dataType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetDataType()
    {
        string htmls = "<option>انتخاب نوع</option>";
        var dataType = AdakDB.Db.usp_DataType_Select().ToList();
        dataType = dataType ?? new List<Bank.usp_DataType_SelectResult>();
        foreach (var item in dataType)
        {
            htmls += "<option value='" + item.DT_ID.ToCodeNumber() + "'>" + item.DT_Title + "</option>";
        }
        return htmls;
    }
    public static string GetDataType_For_Add()
    {
        string htmls = "";
        var dataType = AdakDB.Db.usp_DataType_Select_For_Add().ToList();
        dataType = dataType ?? new List<Bank.usp_DataType_Select_For_AddResult>();
        foreach (var item in dataType)
        {
            htmls += "<option value='" + item.DT_ID.ToCodeNumber() + "'>" + item.DT_Title + "</option>";
        }
        return htmls;
    }
    public static string GetSMSType(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب نوع پیام</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_SMSType).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetAllPersonnels(bool allowNull = false, string NullTitle = "انتخاب پرسنل")
    {
        string htmls = allowNull ? "<option>" + NullTitle + "</option>" : "";
        int? outCount = 0;
        var personnels = AdakDB.Db.usp_Personnel_Select_For_Grid(null, ref outCount, 1, 1001).ToList();
        personnels = personnels ?? new List<Bank.usp_Personnel_Select_For_GridResult>();
        foreach (var item in personnels)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        return htmls;
    }
    public static string GetTypePhotographi(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب موضوع</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_TurnType).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetLocation(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب لوکیشن</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_Location).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetInviteType(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب نحوه آشنایی</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_InviteType).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetBank(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب بانک</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_Bank).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetCostType(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب هزینه</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_CostType).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetDesigner(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب طراح</option>" : "";
        var personnel = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Designer).ToList();
        personnel = personnel ?? new List<Bank.usp_Personnel_By_RoleResult>();
        foreach (var item in personnel)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        return htmls;
    }
    public static string GetAdmin_A_Monshi(bool allowNull = true, string NullOptionText = "انتخاب ثبت کننده")
    {
        string htmls = allowNull ? "<option>" + NullOptionText + "</option>" : "";
        var admins = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Admin).ToList();
        var secretary = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Secretary).ToList();
        admins = admins ?? new List<Bank.usp_Personnel_By_RoleResult>();
        secretary = secretary ?? new List<Bank.usp_Personnel_By_RoleResult>();
        foreach (var item in secretary)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        foreach (var item in admins)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        return htmls;
    }
    public static string GetAdmin_A_Monshi_PhotographerHospital(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب ثبت کننده</option>" : "";
        var admins = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Admin).ToList();
        var secretary = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Secretary).ToList();
        var hospital = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_PhotographerInHospital).ToList();
        admins = admins ?? new List<Bank.usp_Personnel_By_RoleResult>();
        secretary = secretary ?? new List<Bank.usp_Personnel_By_RoleResult>();
        hospital = hospital ?? new List<Bank.usp_Personnel_By_RoleResult>();
        foreach (var item in secretary)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        foreach (var item in admins)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        foreach (var item in hospital)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        return htmls;
    }
    public static string GetFactorStatus(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>وضعیت فاکتور</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_FactorStatus).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        var fs = paidType.Where(a => a.D_ID <= DefaultDataIDs.FactorStatus_ReadyForDesign).ToList();//فقط وضعیت های بیعانه نداده فاکتور ناقص  و در دست طراحی رو اینجا نشون بده
                                                                                                    //چون بقیه مراحلش رو باید طراح انجام بده
        foreach (var item in fs)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetFactorStatusAll(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>وضعیت فاکتور</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_FactorStatus).ToList().OrderBy(a => a.D_Priority).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }
    public static string GetPhotographer(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب عکاس</option>" : "";
        var personnel = AdakDB.Db.usp_Personnel_By_Role(DefaultDataIDs.Role_Photographer).ToList();
        personnel = personnel ?? new List<Bank.usp_Personnel_By_RoleResult>();
        foreach (var item in personnel)
        {
            htmls += "<option value='" + item.P_Id.ToCodeNumber() + "'>" + item.FullName + "</option>";
        }
        return htmls;
    }
    public static string GetPaidType(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب نوع پرداخت</option>" : "";
        var paidType = AdakDB.Db.usp_Data_Select_By_TypeId(9).ToList();
        paidType = paidType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in paidType)
        {
            if (item.D_ID != 986 && item.D_ID != 985)
            {
                htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
            }
        }
        return htmls;
    }
    public static string GetCustomer(bool allowNull = true)
    {
        string htmls = allowNull ? "<option>انتخاب خانواده</option>" : "";
        int? outcount = 0;
        var family = AdakDB.Db.usp_Family_Select_All().ToList();
        family = family ?? new List<Bank.usp_Family_Select_AllResult>();
        foreach (var item in family)
        {
            htmls += "<option value='" + item.F_Id.ToCodeNumber() + "'>" + item.F_Title + "</option>";
        }
        return htmls;
    }
    public static string GetProductGroup(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب گروه کالا</option>" : "";
        var family = AdakDB.Db.usp_ProductGroup_Select_Active().ToList();
        family = family ?? new List<Bank.usp_ProductGroup_Select_ActiveResult>();
        foreach (var item in family)
        {
            htmls += "<option value='" + item.PG_ID.ToCodeNumber() + "'>" + item.PG_Title + "</option>";
        }
        return htmls;
    }
    public static string GetRols()
    {
        string htmls = "";
        var dataType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_Role).ToList();

        dataType = dataType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in dataType)
        {
            htmls += "<option value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }

    public static string GetHospitals(long selectedId = 0)
    {
        string htmls = "<option>انتخاب بیمارستان</option>";
        var dataType = AdakDB.Db.usp_Data_Select_By_TypeId(DefaultDataIDs.DataType_Hospital).ToList();

        dataType = dataType ?? new List<Bank.usp_Data_Select_By_TypeIdResult>();
        foreach (var item in dataType)
        {
            htmls += "<option " + (item.D_ID == selectedId ? "selected='selected'" : "") + @" value='" + item.D_ID.ToCodeNumber() + "'>" + item.D_Title + "</option>";
        }
        return htmls;
    }

    public static string Tag_A_for_Family(string Title, string Id)
    {
        return @"<a style='color: blue;text-decoration: underline;cursor: pointer' onclick='HideBtnAdd_Family(""" + Id + @""")' data-bs-toggle='modal' data-bs-target='#modal_addedit_family'>" + Title + @"</a>";
    }
    public static string GetActiveCustomer(bool allowNull = false)
    {
        string htmls = allowNull ? "<option>انتخاب خانواده</option>" : "";
        var family = AdakDB.Db.usp_Family_Select_ForCombo().ToList();
        family = family ?? new List<Bank.usp_Family_Select_ForComboResult>();
        foreach (var item in family)
        {
            htmls += "<option value='" + item.F_ID.ToCodeNumber() + "'>" + item.FamilyTitle + "</option>";
        }
        return htmls;
    }
}