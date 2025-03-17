namespace Mainstage.API.Models
{
    public class RefreshToken
    {
        public string UserId { get; set; }
        public string Token { get; set; }
        public DateTime Expires { get; set; }
    }
}
