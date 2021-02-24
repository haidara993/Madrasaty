using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;

namespace madrasaty1.Models
{
    public class User:IdentityUser<int>
    {
        public string PhotoUrl { get; set; }
        public Division Division { get; set; }
        [ForeignKey("Division")]
        public int DivisionId { get; set; }
        public Standard Standard { get; set; }
        [ForeignKey("Standard")]
        public int StandardId { get; set; }
        public string EnrollNo { get; set; }
        public string DisplayName { get; set; }
        public string Dob { get; set; }
        public string GuardianName { get; set; }
        public string BloodGroup { get; set; }
        public string MobileNo { get; set; }
        public bool IsOnline { get; set; }
        public ICollection<UserRole> UserRoles { get; set; }
        
    }
}