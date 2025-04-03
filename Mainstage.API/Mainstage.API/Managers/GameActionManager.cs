using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GameActionManager
    {
        private readonly MainstageContext _context;

        public GameActionManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<GameAction>> GetAllAsync()
        {
            return await _context.GameActions.ToListAsync();
        }

        public async Task<List<GameAction>> GetForGameAsync(int gameId)
        {
            return await _context.GameActions.Where(a => a.GameId == gameId).ToListAsync();
        }

        public async Task<GameAction> GetByIdAsync(int gameId, string playerId, int actionId)
        {
            return await _context.GameActions.FindAsync(gameId, playerId, actionId);
        }

        public async Task AddAsync(GameAction entity)
        {
            _context.GameActions.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(GameAction entity)
        {
            _context.GameActions.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int gameId, string playerId, int actionId)
        {
            var entity = await _context.GameActions.FindAsync(gameId, playerId, actionId);
            if (entity != null)
            {
                _context.GameActions.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task SaveTurnActionsToDB(Game game, List<GameAction> turnActions)
        {
            foreach (var action in turnActions)
            {
                var gameAction = new GameAction
                {
                    GameId = game.Id,
                    PlayerId = action.PlayerId,
                    ActionType = action.ActionType,
                    Parameter = action.Parameter,
                    LcDate = DateTime.Now,
                    CrDate = DateTime.Now,
                    LcUser = "sys",
                    CrUser = "sys"
                };

                await AddAsync(gameAction);
            }
        }
    }
}

