using System.Threading.Tasks;

public interface IPaymentGateway
{
    Task<OperationResult<PGResponseData>> BeginAsync(dynamic p);
    Task<OperationResult<PGVerifyResponseData>> VerifyAsync(dynamic p);
}