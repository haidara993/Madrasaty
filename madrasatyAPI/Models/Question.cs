using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace madrasaty1.Models
{
    public class Question
    {
        public int Id { get; set; }
        public string question { get; set; }
        public ICollection<Answer> answer { get; set; }
        public string type { get; set; }
        public ICollection<Option> Options { get; set; }
        public string Description { get; set; }
        public int level { get; set; }
        public string subject { get; set; }
        public int ExamId { get; set; }
        [ForeignKey("ExamId")]
        public ExamTopic Exam { get; set; }
        public string standard { get; set; }
    }
}