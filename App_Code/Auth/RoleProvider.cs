using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;

/// <summary>
/// while applications use old system login
/// </summary>
public class RoleProvider : System.Web.Security.RoleProvider
{
    private string _applicationName = "LimsNet";
    public override string ApplicationName
    {
        get
        {
            return _applicationName;
        }
        set
        {
            _applicationName = value;
        }
    }

    public override void AddUsersToRoles(string[] usernames, string[] roleNames)
    {
        throw new NotImplementedException();
    }

    public override void CreateRole(string roleName)
    {
        throw new NotImplementedException();
    }
    public override bool DeleteRole(string roleName, bool throwOnPopulatedRole)
    {
        throw new NotImplementedException();
    }
    public override string[] FindUsersInRole(string roleName, string usernameToMatch)
    {
        throw new NotImplementedException();
    }
    public override string[] GetAllRoles()
    {
        return new string[] { "Teacher", "Student", "Admin", "Azmoon", "Parent", "Marketer", "Supervisor" };
    }

    public override string[] GetRolesForUser(string username)
    {
        string[] strResult = null;
        if (string.IsNullOrEmpty(username))
        {
            var identity = HttpContext.Current.User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            int type = int.Parse(claims.FirstOrDefault(p => p.Type == "SigType")?.Value);
            if (type == 2)
            {
                strResult = new string[1] { "Teacher" };
            }
            else if (type == 3)
            {
                strResult = new string[1] { "Student" };
            }
            else if (type == 4)
            {
                strResult = new string[1] { "Admin" };
            }
            else if (type == 5)
            {
                strResult = new string[1] { "Azmoon" };
            }
            else if (type == 16)
            {
                strResult = new string[1] { "Parent" };
            }
            else if (type == 110)
            {
                strResult = new string[1] { "Supervisor" };
            }
            return strResult;
        }
        string val = username;
        if (val.Contains('#'))
        {
            int type = val.Split('#')[1].ToInt();
            if (type == 2)
            {
                strResult = new string[1] { "Teacher" };
            }
            else if (type == 3)
            {
                strResult = new string[1] { "Student" };
            }
            else if (type == 4)
            {
                strResult = new string[1] { "Admin" };
            }
            else if (type == 5)
            {
                strResult = new string[1] { "Azmoon" };
            }
            else if (type == 16)
            {
                strResult = new string[1] { "Parent" };
            }
            else if (type == 110)
            {
                strResult = new string[1] { "Supervisor" };
            }
            return strResult;
        }
        return strResult;
    }
    public override string[] GetUsersInRole(string roleName)
    {
        throw new NotImplementedException();
    }
    public override bool IsUserInRole(string username, string roleName)
    {
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(roleName))
            return false;
        string val = username;
        if (val.Contains('#'))
        {
            int type = val.Split('#')[1].ToInt();
            if (type == 2 && roleName == "Teacher")
            {
                return true;
            }
            else if (type == 3 && roleName.Contains("Student"))
            {
                return true;
            }
            else if (type == 4 && roleName == "Admin")
            {
                return true;
            }
            else if (type == 5 && roleName == "Azmoon")
            {
                return true;
            }
            else if (type == 9 && roleName == "Parent")
            {
                return true;
            }
            else if (type == 110 && roleName == "Supervisor")
            {
                return true;
            }
            return false;
        }
        else
        {
            return false;
        }
    }

    public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames)
    {
        throw new NotImplementedException();
    }

    public override bool RoleExists(string roleName)
    {
        throw new NotImplementedException();
    }
}