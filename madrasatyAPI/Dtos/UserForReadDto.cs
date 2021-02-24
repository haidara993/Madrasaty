using System;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace madrasaty1.Dtos
{
    public class UserForReadDto
    {
        public string UserName { get; set; }
        public string PhotoUrl { get; set; }
        public string Division { get; set; }
        public string EnrollNo { get; set; }
        public string DisplayName { get; set; }
        public string Standard { get; set; }
        public string Dob { get; set; }
        public string GuardianName { get; set; }
        public string BloodGroup { get; set; }
        public string MobileNo { get; set; }

    }
}