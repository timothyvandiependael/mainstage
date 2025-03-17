namespace Mainstage.API.Models
{
    public class GamePlayerCard : ModelBase
    {
        public int GameId { get; set; }
        public string PlayerId { get; set; }
        public int CardId { get; set; }
    }
}
