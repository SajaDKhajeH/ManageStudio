using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for BasicDataForGrid
/// </summary>
public class BasicData
{
    public class DataTableModel
    {
        public int draw { get; set; }
        public long recordsTotal { get; set; }
        public long recordsFiltered { get; set; }
        public object data { set; get; }
    }
    public class ForGrid
    {
        public string Title { get; set; }
        public string StatusActive { get; set; }
        public string Desc { get; set; }
        public string Actions { get; set; }

    }
}