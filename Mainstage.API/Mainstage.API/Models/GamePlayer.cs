using System.ComponentModel.DataAnnotations.Schema;

namespace Mainstage.API.Models
{
    public class GamePlayer : ModelBase
    {
        public int GameId { get; set; }
        [NotMapped]
        public Game Game { get; set; }
        public string PlayerId { get; set; }
        [NotMapped]
        public Player Player { get; set; }
        public string State { get; set; }
        [NotMapped]
        public short LastRoll { get; set; }
        public int Position { get; set; }
        public bool HasTurn { get; set; }
        public string TurnStartMode { get; set; }
        [NotMapped]
        public Dictionary<string, string> ActiveEffects { get; set; }
        [NotMapped]
        public List<Card> Cards { get; set; }

        public GamePlayer()
        {
            Cards = new List<Card>();
            ActiveEffects = new Dictionary<string, string>();
        }
    }
}
