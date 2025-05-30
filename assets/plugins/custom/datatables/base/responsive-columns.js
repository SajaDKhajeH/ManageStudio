var DatatableResponsiveColumnsDemo = function () {
    var t = function () {
        var t = $(".m_datatable").mDatatable({
            data: { type: "remote", source: { read: { url: "http://keenthemes.com/metronic/preview/inc/api/datatables/demos/default.php" } }, pageSize: 10, saveState: { cookie: !0, webstorage: !0 }, serverPaging: !0, serverFiltering: !0, serverSorting: !0 }, layout: { theme: "default", class: "", scroll: !1, height: 550, footer: !1 }, sortable: !0, filterable: !1, pagination: !0
            , columns: [{
                field: "RecordID", title: "#", sortable: !1, width: 40, textAlign: "center", selector: { class: "m-checkbox--solid m-checkbox--brand" }
            }, {
                field: "OrderID", title: "Order ID", filterable: !1, width: 150
            }, {
                field: "ShipCity", title: "Ship City", responsive: { visible: "lg" }
            }, {
                field: "Website", title: "Website", width: 200, responsive: { visible: "lg" }
            }, {
                field: "Department", title: "Department", responsive: { visible: "lg" }
            }, {
                field: "ShipDate", title: "Ship Date", responsive: { visible: "lg" }
            }, {
                field: "Actions", width: 110, title: "Actions", sortable: !1, overflow: "visible", template: function (t) { return '\t\t\t\t\t\t<div class="dropdown ' + (t.getDatatable().getPageSize() - t.getIndex() <= 4 ? "dropup" : "") + '">\t\t\t\t\t\t\t<a href="#" class="btn m-btn m-btn--hover-accent m-btn--icon m-btn--icon-only m-btn--pill" data-toggle="dropdown"><i class="la la-ellipsis-h"></i></a>\t\t\t\t\t\t  \t<div class="dropdown-menu dropdown-menu-right">\t\t\t\t\t\t    \t<a class="dropdown-item" href="#"><i class="la la-edit"></i> Edit Details</a>\t\t\t\t\t\t    \t<a class="dropdown-item" href="#"><i class="la la-leaf"></i> Update Status</a>\t\t\t\t\t\t    \t<a class="dropdown-item" href="#"><i class="la la-print"></i> Generate Report</a>\t\t\t\t\t\t  \t</div>\t\t\t\t\t\t</div>\t\t\t\t\t\t<a href="#" class="m-portlet__nav-link btn m-btn m-btn--hover-accent m-btn--icon m-btn--icon-only m-btn--pill" title="Edit details">\t\t\t\t\t\t\t<i class="la la-edit"></i>\t\t\t\t\t\t</a>\t\t\t\t\t\t<a href="#" class="m-portlet__nav-link btn m-btn m-btn--hover-danger m-btn--icon m-btn--icon-only m-btn--pill" title="Delete">\t\t\t\t\t\t\t<i class="la la-trash"></i>\t\t\t\t\t\t</a>\t\t\t\t\t' }
            }]
        }), e = t.getDataSourceQuery(); $("#m_form_search").on("keyup", function (e) { var a = t.getDataSourceQuery(); a.generalSearch = $(this).val().toLowerCase(), t.setDataSourceQuery(a), t.load() }).val(e.generalSearch), $("#m_form_status, #m_form_type").selectpicker()
    }; return { init: function () { t() } }
}(); jQuery(document).ready(function () { DatatableResponsiveColumnsDemo.init() });