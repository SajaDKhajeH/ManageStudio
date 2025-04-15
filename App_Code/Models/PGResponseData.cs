using Newtonsoft.Json;

public class PGResponseModel
{
    [JsonProperty("data")]
    public PGResponseData Data { get; set; }

}
public class PGResponseData
{
    [JsonProperty("code")]
    public int Code { get; set; }
    [JsonProperty("authority")]
    public string Authority { get; set; }
    [JsonProperty("fee")]
    public int Fee { get; set; }
    public string ResponseContent { get; set; }
    public string Url
    {
        get
        {
            return "https://www.zarinpal.com/pg/StartPay/" + Authority;
        }
    }
}
