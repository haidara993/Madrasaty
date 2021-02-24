using System.ComponentModel.DataAnnotations.Schema;

namespace madrasaty1.Models
{
    public class ExamTopic
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string PhotoUrl { get; set; }
        public string Subject { get; set; }
        public string Description { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; }
    }
}