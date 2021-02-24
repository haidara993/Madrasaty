using System;

namespace madrasaty1.Models
{
    public class Holiday
    {
        public int Id { get; set; }
        public string name { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Type { get; set; }
        public string Location { get; set; }
        public bool IsExpanded { get; set; }
    }
}