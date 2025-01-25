using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class RoleModel
{
    public long Id { get; set; }
    public string Name { get; set; }
}
public class Roles
{
    public static RoleModel Admin = new RoleModel
    {
        Id = 4,
        Name="Admin"
    };
    public static RoleModel Monshi = new RoleModel
    {
        Id = 5,
        Name = "Monshi"
    };
    public static RoleModel Designer = new RoleModel
    {
        Id = 6,
        Name = "Designer"
    };
    public static RoleModel Photographer = new RoleModel
    {
        Id = 7,
        Name = "Photographer"
    };
}