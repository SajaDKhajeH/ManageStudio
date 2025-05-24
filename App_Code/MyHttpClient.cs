using Newtonsoft.Json;
using System.Net.Http;
using System.Threading.Tasks;

public class MyHttpClient
{
    HttpClient httpClient;
    public MyHttpClient()
    {
        httpClient = new HttpClient()
        {
            BaseAddress = new System.Uri(Constants.BaseApiUrl)
        };
    }
    public static MyHttpClient Instance { get; private set; }
    public static void Init()
    {
        Instance = new MyHttpClient();
    }
    public async Task<OperationResult<T>> GetAsync<T>(string route)
    {
        var response = await httpClient.GetAsync(route);
        if (response.IsSuccessStatusCode)
        {
            string content = await response.Content.ReadAsStringAsync();
            var model = JsonConvert.DeserializeObject<T>(content);
            return new OperationResult<T>
            {
                Success = true,
                Data = model
            };
        }
        return new OperationResult<T>
        {
            Success = false,
            Message = response.StatusCode.ToString()
        };
    }
}