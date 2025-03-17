using System.ComponentModel.DataAnnotations.Schema;

namespace Mainstage.API.Models
{
    public class GameStateInfo
    {
        public Game Game { get; set; }
        public List<ClientActionReport> ClientActionReportQueue{ get; set; }
        public List<GameAction> ActionSequence { get; set; }
        public string EventMessage { get; set; }
        public List<Card> JokerCardList { get; set; }
        public Card LastEtherealCard { get; set; }
        public GameStateInfo()
        {
            Game = new Game();
            ClientActionReportQueue = new List<ClientActionReport>();
            ActionSequence = new List<GameAction>();
            JokerCardList = new List<Card>();
            LastEtherealCard = new Card();
        }



    }
}
