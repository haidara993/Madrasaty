using System;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace madrasaty1.Dtos
{
    public class UserForRegisterDto
    {
        [Required]
        public string UserName { get; set; }

        [Required]
        [StringLength(8, MinimumLength = 4, ErrorMessage = "You must specify a password between 4 and 8 characters")]
        public string Password { get; set; }

        [Required]
        public string PhotoUrl { get; set; }
        [Required]
        public int DivisionId { get; set; }
        [Required]
        public string EnrollNo { get; set; }
        [Required]
        public string DisplayName { get; set; }
        [Required]
        public int StandardId { get; set; }
        [Required]
        public string Dob { get; set; }
        [Required]
        public string GuardianName { get; set; }
        [Required]
        public string BloodGroup { get; set; }
        [Required]
        public string MobileNo { get; set; }

        public string SecurityStamp { get; set; }


    }
}