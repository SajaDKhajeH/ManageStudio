using Bank;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Family;
using System.IO;
using static Stimulsoft.Report.StiRecentConnections;

public partial class ManageTurn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static OperationResult<ForGrid.DataTableModel> ForGrid(
             int page, int perPage, string fromDate, string toDate, string familyId, string searchText,
             string causer, string typePhoto
             )
    {
        perPage = perPage == 0 ? 10 : perPage;
        searchText = searchText.Trim();
        int? countt = 0;
        familyId = familyId.ToDecodeNumber();
        causer = causer.ToDecodeNumber();
        typePhoto = typePhoto.ToDecodeNumber();

        var data = AdakDB.Db.usp_Turn_Select_For_Grid(searchText, fromDate.ToEnglishNumber(), toDate.ToEnglishNumber(), familyId.ToLong(), page, perPage, ref countt, causer.ToLong(), typePhoto.ToLong()).ToList();
        data = data ?? new List<Bank.usp_Turn_Select_For_GridResult>();
        List<TurnForGrid> list = new List<TurnForGrid>();
        data.ForEach(x => list.Add(new TurnForGrid()
        {
            Row = 1,
            FamilyTitle = PublicMethod.Tag_A_for_Family(x.FamilyTitle, x.R_FamilyId.ToCodeNumber()),
            Date = x.R_TurnDate,
            TypeTitle = x.TypePhotographyTitle,
            Location = x.LocationTitle,
            Time = x.R_TurnTime.ToString(),
            CreationTime = x.R_CreationTime.ToShamsi() + " - " + x.R_CreationTime.TimeOfDay.ToString(),
            Desc=x.R_Desc,
            

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
    public class TurnForGrid
    {
        public int Row { get; set; }
        public string Date { get; set; }
        public string FamilyTitle { get; set; }
        public string Time { get; set; }
        public string TypeTitle { get; set; }
        public string Desc { get; set; }
        public string CreationTime { get; set; }
        public string Location { get; set; }
    }
}