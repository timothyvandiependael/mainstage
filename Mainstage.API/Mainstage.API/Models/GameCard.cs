namespace Mainstage.API.Models
{
    public class GameCard : ModelBase
    {
        public int GameId { get; set; }
        public int CardId { get; set; }
        public string Pile { get; set; }
        public int PilePosition { get; set; }
    }
}
