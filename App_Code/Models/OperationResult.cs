public class OperationResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
    public static OperationResult Ok()
    {
        return new OperationResult()
        {
            Success = true
        };
    }
}
public class OperationResult<T> : OperationResult
{
    public T Data { get; set; }
    public static OperationResult<T> Failed(string message)
    {
        return new OperationResult<T>()
        {
            Success = false,
            Message = message
        };
    }
}