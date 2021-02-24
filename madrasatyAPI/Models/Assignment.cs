using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace madrasaty1.Models
{
    public class Assignment
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; }
        public string Title { get; set; }
        public int DivisionId { get; set; }
        [ForeignKey("DivisionId")]
        public Division Division { get; set; }
        public string Subject { get; set; }
        public string Timestamp { get; set; }
        public string Url { get; set; }
        public string Details { get; set; }
        
    }
}