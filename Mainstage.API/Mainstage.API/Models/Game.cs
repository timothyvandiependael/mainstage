using System.ComponentModel.DataAnnotations.Schema;

namespace Mainstage.API.Models
{
    public class Game : ModelBase
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string State { get; set; }
        public bool IsPublic { get; set; }
        [NotMapped]
        public List<GamePlayer> Players { get; set; }
        [NotMapped]
        public List<Tile> Tiles { get; set; }
        [NotMapped]
        public List<Card> DrawPile { get; set; }
        [NotMapped]
        public List<Card> DiscardPile { get; set; }
        [NotMapped]
        public List<GameAction> Actions { get; set; }
        [NotMapped]
        public GameOptions Options { get; set; }

        public Game()
        {
            Players = new List<GamePlayer>();
            Tiles = new List<Tile>();
            DrawPile = new List<Card>();
            DiscardPile = new List<Card>();
            Actions = new List<GameAction>();
        }
    }
}
