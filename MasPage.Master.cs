using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class MasPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            string pageName = System.IO.Path.GetFileNameWithoutExtension(Page.AppRelativeVirtualPath);
            if (LoginedUser.Role == DefaultDataIDs.Role_Secretary)
            {
                if (!(AdakDB.Db.ufn_CheckPermission(pageName + ".aspx", LoginedUser.Id) ?? false))
                {
                    Response.Redirect("Logout.aspx");
                }
            }
            else if (LoginedUser.Role == DefaultDataIDs.Role_Family && pageName != "CustomerOrders")
            {
                Response.Redirect("Logout.aspx");
            }
            else if (
                        (
                        LoginedUser.Role == DefaultDataIDs.Role_Designer ||
                        LoginedUser.Role == DefaultDataIDs.Role_DesignSupervisor ||
                        LoginedUser.Role == DefaultDataIDs.Role_Photographer
                        ) && pageName != "RequestStatus"
                    )
            {
                Response.Redirect("Logout.aspx");
            }
            //else if (LoginedUser.Role != DefaultDataIDs.Role_Admin)
            //{
            //    Response.Redirect("Logout.aspx");
            //}
        }
        protected string GetProducts()
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
        protected string GetCustomer()
        {
            string htmls = "";
            int? outcount = 0;
            var family = AdakDB.Db.usp_Family_Select_For_Grid(null, 1, 1001, ref outcount, 1).ToList();
            family = family ?? new List<Bank.usp_Family_Select_For_GridResult>();
            var orderlist = family.OrderByDescending(a => a.F_Id).ToList();
            foreach (var item in orderlist)
            {
                htmls += "<option value='" + item.F_Id.ToCodeNumber() + "'>" + item.F_Title + "</option>";
            }
            return htmls;
        }
        public static bool IsActiveSMSText_CancelTurn()
        {
            var dataInfo = AdakDB.Db.usp_Data_Select_By_Id(DefaultDataIDs.DefaultSMS_CancelTurn).SingleOrDefault();
            return dataInfo.D_Active;
        }
        protected string Menus()
        {
            string htmls = "";
            if (LoginedUser.Role == DefaultDataIDs.Role_Secretary || LoginedUser.Role == DefaultDataIDs.Role_Admin)
            {
                var menus = AdakDB.Db.usp_Page_Select(LoginedUser.Id).ToList();
                //فقط اونهایی که باید در سایت نمایش داده شوند
                menus = menus.Where(a => a.P_ShowOnMenu ?? false).ToList();
                if (LoginedUser.Role == DefaultDataIDs.Role_Secretary)
                {
                    menus = menus.Where(a => a.HasPermission == 1).ToList();
                }
                menus = menus.OrderBy(b => b.P_Sort).ToList();
                foreach (var item in menus)
                {
                    htmls += @"<div class='menu-item'>
                                <a class='menu-link' href='" + item.P_Url + @"'>
                                    <span class='menu-icon'>
                                        <span class='svg-icon svg-icon-2'>
                                            <svg width='24' height='24' viewBox='0 0 24 24' fill='none'>
                                                <rect x='2' y='2' width='9' height='9' rx='2' fill='black' />
                                                <rect opacity='0.3' x='13' y='2' width='9' height='9' rx='2' fill='black' />
                                                <rect opacity='0.3' x='13' y='13' width='9' height='9' rx='2' fill='black' />
                                                <rect opacity='0.3' x='2' y='13' width='9' height='9' rx='2' fill='black' />
                                            </svg>
                                        </span>
                                        <!--end::Svg Icon-->
                                    </span>
                                    <span class='menu-title' id='title_MasterPage'>" + item.P_Title + @"</span></a></div>";
                }
            }
            return htmls;
        }
    }
}