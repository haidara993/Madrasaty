using System.Collections.Generic;
using Microsoft.AspNetCore.Identity;

namespace madrasaty1.Models
{
    public class Role : IdentityRole<int>
    {
        public ICollection<UserRole> UserRoles { get; set; }
    }
}