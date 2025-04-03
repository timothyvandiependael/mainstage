using Mainstage.API.Models;

namespace Mainstage.API.Services
{
    public class GameActionService
    {
        public int GetNextActionHistoryId(GameStateInfo info)
        {
            var newId = info.Game.Actions.Max(a => a.ActionId) + 1;
            return newId;
        }

        public int GetNextActionId(GameStateInfo info)
        {
            var lastActionId = 0;
            if (info.ActionSequence != null && info.ActionSequence.Count > 0)
            {
                lastActionId = info.ActionSequence.Max(a => a.ActionId);
            }
            else if (info.Game.Actions != null && info.Game.Actions.Count > 0)
            {
                lastActionId = info.Game.Actions.Max(a => a.ActionId);
            }

            lastActionId++;
            return lastActionId;
        }

        public void AddActionHistory(GameStateInfo info, string playerId, string type, string parameter)
        {
            if (info.ActionSequence.Count > 0)
            {
                foreach (var action in info.ActionSequence)
                {
                    action.ActionId += 1;
                }
            }

            var ga = new GameAction()
            {
                GameId = info.Game.Id,
                PlayerId = playerId,
                ActionId = GetNextActionHistoryId(info),
                ActionType = type,
                Parameter = parameter
            };
            info.Game.Actions.Add(ga);
        }

        public void InsertInActionSequence(GameStateInfo info, string playerId, string type, string parameter)
        {
            if (info.ActionSequence.Count > 0)
            {
                foreach (var action in info.ActionSequence)
                {
                    action.ActionId += 1;
                }
            }
            var ga = new GameAction()
            {
                GameId = info.Game.Id,
                PlayerId = playerId,
                ActionId = GetNextActionHistoryId(info),
                ActionType = type,
                Parameter = parameter
            };
            info.ActionSequence.Insert(0, ga);
        }

        public GamePlayer GetNextActionPlayer(GameStateInfo info)
        {
            var nextAction = info.ActionSequence.First();
            if (nextAction == null)
            {
                return null;
            }
            else
            {
                var player = info.Game.Players.Where(p => p.PlayerId == nextAction.PlayerId).First();
                return player;
            }
        }

    }
}
