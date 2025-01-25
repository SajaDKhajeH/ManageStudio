using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using static System.Net.WebRequestMethods;

public class LoginedUser
{
   public static string Name
    {
        get
        {
            var identity = HttpContext.Current.User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            return claims.First(p => p.Type == AdakClaimTypes.Name).Value;
        }
    }
    public static long Role
    {
        get
        {
            var identity = HttpContext.Current.User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            var claim = claims.FirstOrDefault(p => p.Type == AdakClaimTypes.Role);
            if (claim == null)
                return 0;
            return long.Parse(claim.Value);
        }
    }
    public static long Id
    {
        get
        {
            
            var identity = HttpContext.Current.User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            var claim = claims.FirstOrDefault(p => p.Type == AdakClaimTypes.Id);
            if (claim == null)
                return 0;
            return long.Parse(claim.Value);
        }
    }
}