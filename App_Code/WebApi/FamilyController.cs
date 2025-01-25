using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

public class FamilyController : ApiController
{
    [HttpPost, Route("Api/Family/ForGrid")]
    public OperationResult<ForGrid.DataTableModel> ForGrid(int page, int perPage)
    {
        HttpRequest staticContext = HttpContext.Current.Request;
        //int perPage = (staticContext["length"] ?? "0").ToInt();
        int star = staticContext["start"].ToInt();
        int draw = (staticContext["draw"] ?? "0").ToInt();
        perPage = perPage == 0 ? 10 : perPage;
        page = star > 0 && perPage > 0 && star >= perPage ? (star / perPage) + 1 : 1;
        string searchText = (staticContext["search[value]"] ?? "");
        searchText = searchText.Trim();
        int? countt = 0;

        var data = AdakDB.Db.usp_Family_Select_For_Grid(searchText, page, perPage, ref countt, 1).ToList();
        data = data ?? new List<Bank.usp_Family_Select_For_GridResult>();
        List<Family.FamilyForGrid> list = new List<Family.FamilyForGrid>();
        data.ForEach(x => list.Add(new Family.FamilyForGrid()
        {
            Title = x.F_Title,
            Row=1,
            FatherFullName = x.FatherFullName,
            MotherFullName = x.MotherFullName,
            MotherMobile = x.F_MotherMobile,
            FatherMobile = x.F_FatherMobile,
            Status = !x.F_Archive ? "<div class='badge badge - light - success'>فعال</div>" : "<div class='badge badge - light - success'>غیرفعال</div>",
            Actions = ""
            //Actions = new StringBuilder(@"<button onclick='show_weekly(""").Append(x.ClassId.ToCodeEscape()).Append(@""");' class='lims_btn59 btn m-btn--pill m-btn--air btn-sm m-btn m-btn--custom btn-outline-primary' title='برنامه هفتگی'  data-toggle='modal' data-target='#m_modal_2'> برنامه هفتگی </button>").ToString(),
        })); ;
        //< div class="menu-item px-3">
        //                                <a class="menu-link px-3">ویرایش</a>
        //                            </div>
        //                            <div class="menu-item px-3">
        //                                <a class="menu-link px-3">حذف</a>
        //                            </div>

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
                draw = draw,
                recordsFiltered = countt ?? 0,
                data = list
            }
        };
    }
}
