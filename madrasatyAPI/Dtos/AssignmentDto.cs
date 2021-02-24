namespace madrasaty1.Dtos
{
    public class AssignmentDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Title { get; set; }
        public int DivisionId { get; set; }
        public int StandardId { get; set; }
        public string Subject { get; set; }
        public string Timestamp { get; set; }
        public string Url { get; set; }
        public string Details { get; set; }
    }
}