using Microsoft.AspNetCore.Http;

namespace madrasaty1.Dtos
{
    public class UserForListDto
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string PhotoUrl { get; set; }
        public int DivisionId { get; set; }
        public string Division { get; set; }
        public string EnrollNo { get; set; }
        public string DisplayName { get; set; }
        public string Standard { get; set; }
        public int StandardId { get; set; }
        public string Dob { get; set; }
        public string GuardianName { get; set; }
        public string BloodGroup { get; set; }
        public string MobileNo { get; set; }
        public bool IsVerified { get; set; }
        public string jwt { get; set; }
    }
}