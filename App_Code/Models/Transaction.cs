using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
public class Transaction
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }
    public Guid Guid { get; set; }
    public int CustomerId { get; set; }
    public long LoginId { get; set; }
    public DateTime CreationTime { get; set; }
    public decimal Price { get; set; }
    public string Type { get; set; } 
    public string Description { get; set; }
    public string Mobile { get; set; }
    public int? Code { get; set; }
    public string Authority { get; set; }
    public decimal? Fee { get; set; }
    public string Message { get; set; }
    public DateTime? VerifyTime { get; set; }
    public bool VerifySuccess { get; set; }
    public string VerifiedRefId { get; set; }
    public DateTime? VerifiedTime { get; set; }
    public bool VerifiedSuccess { get; set; }
    public string VerifiedMessage { get; set; }
    public string ResponseContent { get; set; }
    public long? InvoiceId { get; set; }
    public bool IsFromWebsite { get; set; }
    public string UserAgent { get; set; }
}