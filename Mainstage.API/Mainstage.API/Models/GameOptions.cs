namespace Mainstage.API.Models
{
    public class GameOptions : ModelBase
    {
        public int GameId { get; set; }
        public int PlayerAmount { get; set; }
        public int TurnTimeLimit { get; set; }
        public int ReactionTimeLimit { get; set; }
        public bool AiPlayers { get; set; }
        public bool UseMegaFatLady { get; set; }
    }
}
