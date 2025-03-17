namespace Mainstage.API.Models
{
    public class ChatMessage : ModelBase
    {
        public int ChatId { get; set; }
        public string PlayerId { get; set; }
        public int MessageId { get; set; }
        public string Message { get; set; }
    }
}
