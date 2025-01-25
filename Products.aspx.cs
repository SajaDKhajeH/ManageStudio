using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdakStudio
{
    public partial class Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoginedUser.Id <= 0)
            {
                Response.Redirect("Logout.aspx");
            }
            if (LoginedUser.Role != DefaultDataIDs.Role_Admin && LoginedUser.Role != DefaultDataIDs.Role_Secretary)
            {
                Response.Redirect("Logout.aspx");
            }
        }
        [WebMethod]
        public static dynamic ProductDelete(long id)
        {
            if (id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه کالا مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            int? haserror = 0;
            string mes = "";
            db.usp_Product_Delete(id, LoginedUser.Id, ref mes, ref haserror);
            return new
            {
                Result = haserror == 0,
                Message = haserror == 0 ? "حذف با موفقیت انجام شد" : mes
            };
        }
        [WebMethod]
        public static OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage, string searchText, string gproduct)
        {
            perPage = perPage == 0 ? 10 : perPage;
            searchText = searchText.Trim();
            int? countt = 0;
            gproduct = gproduct.ToDecodeNumber();
            var data = AdakDB.Db.usp_Product_Select_For_Grid(searchText, gproduct.ToInt(), ref countt, page, perPage).ToList();
            data = data ?? new List<Bank.usp_Product_Select_For_GridResult>();
            List<ProductForGrid> list = new List<ProductForGrid>();
            string TextAfterPrice = Settings.TextAfterPrice;
            data.ForEach(x => list.Add(new ProductForGrid()
            {
                Title = x.Pro_Title,
                ProductGroup = x.GroupTitle,
                BuyPrice = x.Pro_BuyPrice_InitialInventory.ShowPrice(TextAfterPrice),
                SalePrice = x.Pro_SalePrice.ShowPrice(TextAfterPrice),
                CheckInventory = (x.Pro_CheckInventory ?? false) ? "بله" : "خیر",
                Inventory = x.Pro_InitialInventoryCount ?? 0,
                Status = x.Pro_Active ? "<div class='badge badge-light-success'>فعال</div>" : "<div class='badge badge-light-danger'>غیرفعال</div>",
                Actions = @"

                <div class='action-buttons'>
                        <button class='btnDataTable btnDataTable-edit' data-bs-toggle='modal' data-bs-target='#addEditProducts' onclick='GetInfoForEditProduct(""" + x.Pro_Id + @""")' title='ویرایش'>✎</button>
                        <button class='btnDataTable btnDataTable-delete' onclick='ProductDelete(""" + x.Pro_Id + @""")' title='حذف'>🗑</button>
                </div>
                "
            })); ; ;


            if (list == null)
            {
                return new OperationResult<ForGrid.DataTableModel>
                {
                    Success = false,
                    Message = "اطلاعات برای نمایش وجود ندارد",
                    Data = new ForGrid.DataTableModel() { }
                };
            }
            return new OperationResult<ForGrid.DataTableModel>
            {
                Success = true,
                Message = "",
                Data = new ForGrid.DataTableModel()
                {
                    recordsTotal = countt ?? 0,
                    recordsFiltered = countt ?? 0,
                    data = list
                }
            };
        }

        [WebMethod]
        public static dynamic GetProductInfo(long id)
        {
            if (id <= 0)
            {
                return new
                {
                    Result = false,
                    Message = "شناسه کالا مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            var ProductInfo = db.usp_Product_Select_By_Id(id).SingleOrDefault();
            return new
            {
                Result = true,
                ProductInfo = ProductInfo,
                GroupdProductId = ProductInfo.Pro_GroupId.ToCodeNumber()
            };
        }

        [WebMethod]
        public static dynamic GetLastPariority(string gproduct)
        {
            gproduct = gproduct.ToDecodeNumber();
            int lastPari = 1;
            var db = AdakDB.Db;
            if (!gproduct.IsNullOrEmpty() && gproduct.ToLong() > 0)
            {
                int? outc = 0;
                var Productlist = db.usp_Product_Select_For_Grid(null, gproduct.ToInt(), ref outc, 1, 1001).ToList();
                lastPari = (Productlist.Max(a => a.Pro_Priority) ?? 0) + 1;
            }

            return new
            {
                Result = true,
                lastPari
            };
        }

        [WebMethod]
        public static dynamic ProductAddEdit(long? id, string gproduct, string Title, decimal buyPrice, decimal salePrice, bool checkInventory, bool active, int pariority, string desc, int Inventory)
        {
            gproduct = gproduct.ToDecodeNumber();
            if (gproduct.IsNullOrEmpty() || gproduct == "0")
            {
                return new
                {
                    Result = false,
                    Message = "گروه کالا مشخص نیست"
                };
            }
            if (Title.IsNullOrEmpty())
            {
                return new
                {
                    Result = false,
                    Message = "عنوان کالا مشخص نیست"
                };
            }
            var db = AdakDB.Db;
            string mes = "";
            int? hasError = 0;
            if (id == null || id == 0)
            {
                db.usp_Product_Add(Title, active, salePrice.ToDecimal(), buyPrice, Inventory, gproduct.ToInt(), desc, LoginedUser.Id, ref mes, ref hasError, ref id, checkInventory, pariority);
            }
            else
            {
                db.usp_Product_Edit(id, Title, active, salePrice.ToDecimal(), buyPrice, Inventory, gproduct.ToInt(), desc, LoginedUser.Id, ref mes, ref hasError, checkInventory, pariority);
            }
            if (hasError == 1)
            {
                return new
                {
                    Result = false,
                    Message = mes.IsNullOrEmpty() ? "خطایی در ثبت اطلاعات رخ داده است" : mes
                };
            }
            return new
            {
                Result = true,
                Message = "ثبت اطلاعات با موفقیت انجام شد"
            };
        }

    }
    public class ProductForGrid
    {
        public string ProductGroup { get; set; }
        public string Title { get; set; }
        public string BuyPrice { get; set; }
        public string SalePrice { get; set; }
        public string CheckInventory { get; set; }
        public int Inventory { get; set; }
        public string Status { get; set; }
        public string Actions { get; set; }

    }
}