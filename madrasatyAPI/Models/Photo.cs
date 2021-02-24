using System.ComponentModel.DataAnnotations;

namespace madrasaty1.Models
{
    public class Photo
    {
        public int Id { get; set; }
        [Required]
        public string FileName { get; set; }
        public bool IsProfilePhoto { get; set; }
        public int UserId { get; set; }
    }
}