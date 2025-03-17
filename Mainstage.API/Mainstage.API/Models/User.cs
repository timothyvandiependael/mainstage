namespace Mainstage.API.Models
{
    public class User : ModelBase
    {
        public string Id { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
    }
}
