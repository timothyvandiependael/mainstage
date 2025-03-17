namespace Mainstage.API.Models
{
    public class TempUser : ModelBase
    {
        public string Id { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Token { get; set; }
        public DateTime TokenExpirationDate { get; set; }
    }
}
