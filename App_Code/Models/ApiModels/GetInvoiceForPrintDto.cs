namespace ApiModels
{
    public class GetInvoiceForPrint
    {
        public decimal ModPrice { get; set; }
        public decimal PaidPrice { get; set; }
        public decimal DiscountPrice { get; set; }
        public string FamilyTitle { get; set; }
        public string Date { get; set; }
        public string Desc { get; set; }
        public string Title { get; set; }
        public ProductModel Product { get; set; }
        public class ProductModel
        {
            public string ProductTitle { get; set; }
            public string Desc { get; set; }
            public decimal Fee { get; set; }
            public int Count { get; set; }
            public decimal Sum { get; set; }
        }
    }
}