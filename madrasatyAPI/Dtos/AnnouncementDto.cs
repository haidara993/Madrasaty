using System;

namespace madrasaty1.Dtos
{
    public class AnnouncementDto
    {
        public int Id { get; set; } 
        public string caption { get; set; }
        public int UserId { get; set; }
        public string DisplayName { get; set; }
        public string UserPhotoUrl { get; set; }
        public int StandardId { get; set; }
        public int DivisionId { get; set; }
        public string Timestamp { get; set; }
        public string PhotoUrl { get; set; }
        public string AnnouncementType { get; set; }
    }
}