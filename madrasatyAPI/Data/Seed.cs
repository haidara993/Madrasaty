using System;
using System.Collections.Generic;
using System.Linq;
using madrasaty1.Models;
using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json;

namespace madrasaty1.Data
{
    public class Seed
    {
        public static void SeedUsers(UserManager<User> _userManager ,RoleManager<Role> _roleManager,DataContext context){
            if (_userManager.Users.Any()) 
            {
                return;
            }
            var userData = System.IO.File.ReadAllText("Data/UserSeedData.json");
            var users = JsonConvert.DeserializeObject<List<User>>(userData);

            var roles = new List<Role> 
            {
                new Role { Name = "Student" },
                new Role { Name = "Admin" },
                new Role { Name = "Teacher" },
                new Role { Name = "Parent" }
            };

            foreach (var role in roles) 
            {
                _roleManager.CreateAsync(role).Wait();
            }

            var standards = new List<Standard> 
            {
                new Standard {StandardName="1",StandardNum=1 },
            };

            foreach (var standard in standards) 
            {
                context.Standards.AddAsync(standard);
                context.SaveChangesAsync();
            }

            var divisions = new List<Division> 
            {
                new Division {DivisionName="A",DivisionNum=1,StandardId=1 },
                new Division {DivisionName="B",DivisionNum=2,StandardId=1 },
            };

            foreach (var division in divisions) 
            {
                context.Divisions.AddAsync(division);
                context.SaveChangesAsync();
            }

           
            foreach (var user in users)
            {
                _userManager.CreateAsync(user, "password").Wait();
                _userManager.AddToRoleAsync(user, roles[0].Name).Wait();
            }

            var adminUser = new User
            {
                UserName = "Admin"
            };

            IdentityResult result = _userManager.CreateAsync(adminUser, "password").Result;
            if (result.Succeeded) 
            {
               var admin = _userManager.FindByNameAsync(adminUser.UserName).Result;
               _userManager.AddToRolesAsync(admin, new[] {"Student", "Admin", "Teacher", "Parent"} ).Wait();

            }

        }

    }
}