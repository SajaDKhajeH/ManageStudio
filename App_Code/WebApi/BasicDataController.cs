using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

/// <summary>
/// Summary description for BasicDataController
/// </summary>
public class BasicDataController : ApiController
{
    [HttpPost, Route("Api/BasicData/ForGrid")]
    public OperationResult<BasicData.DataTableModel> ForGrid()
    {
        HttpRequest staticContext = HttpContext.Current.Request;
        int perPage = (staticContext["length"] ?? "0").ToInt();
        int star = staticContext["start"].ToInt();
        int draw = (staticContext["draw"] ?? "0").ToInt();
        perPage = perPage == 0 ? 10 : perPage;
        int page = 0;
        page = star > 0 && perPage > 0 && star >= perPage ? (star / perPage) + 1 : 1;
        string searchText = (staticContext["search[value]"] ?? "");
        searchText = searchText.Trim();
        string typeId = staticContext["typeId"];
        int? countt = 0;

        typeId = typeId.ToDecodeNumber();

        var data = AdakDB.Db.usp_Data_Select_For_Grid(searchText, typeId.ToInt(), ref countt, page, perPage).ToList();
        data = data ?? new List<Bank.usp_Data_Select_For_GridResult>();
        List<BasicData.ForGrid> list = new List<BasicData.ForGrid>();
        data.ForEach(x => list.Add(new BasicData.ForGrid()
        {
            Title = x.D_Title,
            StatusActive = x.D_Active ? "<div class='badge badge - light - success'>فعال</div>" : "<div class='badge badge - light - success'>غیرفعال</div>",
            Desc = x.D_Desc,
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
            return new OperationResult<BasicData.DataTableModel>
            {

                Success = false,
                Message = "اطلاعات برای نمایش وجود ندارد",
                Data = new BasicData.DataTableModel() { }
            };
        }
        return new OperationResult<BasicData.DataTableModel>
        {
            Success = true,
            Message = "",
            Data = new BasicData.DataTableModel()
            {
                recordsTotal = countt ?? 0,
                draw = draw,
                recordsFiltered = countt ?? 0,
                data = list
            }
        };
    }
}