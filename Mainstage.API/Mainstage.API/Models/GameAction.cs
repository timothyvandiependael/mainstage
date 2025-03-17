using System.ComponentModel.DataAnnotations.Schema;

namespace Mainstage.API.Models
{
    public class GameAction : ModelBase
    {
        public int GameId { get; set; }
        public string PlayerId { get; set; }
        public int ActionId { get; set; }
        public string ActionType { get; set; }
        public string Parameter { get; set; }
    }
}
