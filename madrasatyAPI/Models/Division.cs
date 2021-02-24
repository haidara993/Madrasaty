using System.ComponentModel.DataAnnotations.Schema;

namespace madrasaty1.Models
{
    public class Division
    {
        public int Id { get; set; }
        public string DivisionName { get; set; }   
        public int DivisionNum { get; set; }
        public int StandardId { get; set; }
        [ForeignKey("StandardId")]
        public Standard Standard { get; set; }
    }
}