using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CustomerOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected string GetOrders()
    {
        string htmls = "";
        var orders = AdakDB.Db.usp_Factor_Select_By_FamilyId(LoginedUser.Id).ToList();
        orders = orders ?? new List<Bank.usp_Factor_Select_By_FamilyIdResult>();
        string TextAfterPrice = Settings.TextAfterPrice;
        foreach (var o in orders)
        {
            var details = AdakDB.Db.usp_FactorDetail_By_FactorId(o.FactorId).ToList();
            details = details ?? new List<Bank.usp_FactorDetail_By_FactorIdResult>();

            string htmlDetails = "";
            foreach (var item in details)
            {
                htmlDetails += @"<tr>
                  <td>"+item.ProductGroupTitle+ @"</td>
                  <td>" + item.ProductTitle + @"</td>
                  <td>" + item.FD_Count + @"</td>
                  <td>" + item.FD_Fee.ShowPrice(TextAfterPrice) + @"</td>
                  <td>" + item.FD_SumPrice.ShowPrice(TextAfterPrice) + @"</td>
                </tr>
                ";
            }


            htmls += @"<div class='accordion-item mb-4 shadow-sm rounded'>
      <h2 class='accordion-header' id='orderHeading" + o.FactorId + @"'>
        <button class='accordion-button collapsed fs-5 fw-semibold' type='button' data-bs-toggle='collapse' data-bs-target='#orderCollapse" + o.FactorId + @"' aria-expanded='false' aria-controls='orderCollapse" + o.FactorId + @"'>
          سفارش #" + o.FactorId + @" | تاریخ: " + o.FactorDate + @" | <span class='ms-2 text-info fw-bolder'>مرحله: " + o.StatusTitle + @"</span>
        </button>
      </h2>
      <div id='orderCollapse" + o.FactorId + @"' class='accordion-collapse collapse' aria-labelledby='orderHeading" + o.FactorId + @"' data-bs-parent='#ordersAccordion'>
        <div class='accordion-body'>
          <div class='row g-3 mb-3'>
            <div class='col-md-4'><strong>مبلغ کل:</strong> " + o.SumPrice.ShowPrice(TextAfterPrice) + @"</div>
            <div class='col-md-4'><strong>تخفیف:</strong> " + o.SumDiscountPrice.ShowPrice(TextAfterPrice) + @"</div>
            <div class='col-md-4'><strong>مبلغ پرداختی:</strong> " + o.PaidPrice.ShowPrice(TextAfterPrice) + @"</div>
            <div class='col-md-4'><strong>باقی‌مانده:</strong> " + o.FinanStatus + @"</div>
            <div class='col-md-4'><strong>طراح:</strong> " + o.DesignerName + @"</div>
            <div class='col-md-4'><strong>عکاس:</strong> " + o.PhotographerFullName + @"</div>
          </div>

          <h6 class='fw-bold mt-4 mb-3'>جزئیات سفارش:</h6>
          <div class='table-responsive'>
            <table class='table align-middle table-sm'>
              <thead class='table-light'>
                <tr>
                  <th>نام گروه کالا</th>
                  <th>نام کالا</th>
                  <th>تعداد</th>
                  <th>مبلغ فی (تومان)</th>
                  <th>مبلغ کل (تومان)</th>
                </tr>
              </thead>
              <tbody>
                " + htmlDetails + @"
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>";

        }

        return htmls;
    }
}