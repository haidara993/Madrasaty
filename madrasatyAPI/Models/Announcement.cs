using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace madrasaty1.Models
{
    public class Announcement
    {
        public int Id { get; set; } 
        public string caption { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; }
        public string DisplayName { get; set; }
        public string UserPhotoUrl { get; set; }
        public int StandardId { get; set; }
        [ForeignKey("StandardId")]
        public Standard Standard { get; set; }
        public int DivisionId { get; set; }
        [ForeignKey("DivisionId")]
        public Division Division { get; set; }
        public string Timestamp { get; set; }
        public string PhotoUrl { get; set; }
        public string AnnouncementType { get; set; }

    }
}