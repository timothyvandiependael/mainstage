using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GamePlayerManager
    {
        private readonly MainstageContext _context;
        private readonly GamePlayerCardManager _gamePlayerCardManager;

        public GamePlayerManager(MainstageContext context, GamePlayerCardManager gamePlayerCardManager)
        {
            _context = context;
            _gamePlayerCardManager = gamePlayerCardManager;
        }

        public async Task<List<GamePlayer>> GetAllAsync()
        {
            return await _context.GamePlayers.ToListAsync();
        }

        public async Task<List<GamePlayer>> GetForGameAsync(int gameId)
        {
            return await _context.GamePlayers.Where(p => p.GameId == gameId).ToListAsync();
        }

        public async Task<GamePlayer> GetByIdAsync(int gameId, string playerId)
        {
            return await _context.GamePlayers.FindAsync(gameId, playerId);
        }

        public async Task AddAsync(GamePlayer entity)
        {
            try
            {
                _context.GamePlayers.Add(entity);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                var x = ex;
                throw;
            }
            
        }

        public async Task UpdateAsync(GamePlayer entity)
        {
            _context.GamePlayers.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int gameId, string playerId)
        {
            var entity = await _context.GamePlayers.FindAsync(gameId, playerId);
            if (entity != null)
            {
                _context.GamePlayers.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<GamePlayer>> GetForPlayer(string playerId)
        {
            var lst = await _context.GamePlayers.Where(g => g.PlayerId == playerId).ToListAsync();
            return lst;
        }

        public async Task SaveFullPlayerStateToDB(GamePlayer player)
        {
            await UpdateAsync(player);

            await _gamePlayerCardManager.DeleteForPlayerAsync(player.GameId, player.PlayerId);

            foreach (var card in player.Cards)
            {
                var gamePlayerCard = new GamePlayerCard
                {
                    GameId = player.GameId,
                    PlayerId = player.PlayerId,
                    CardId = card.Id,
                    LcUser = "sys",
                    LcDate = DateTime.Now,
                    CrUser = "sys",
                    CrDate = DateTime.Now
                };
                await _gamePlayerCardManager.AddAsync(gamePlayerCard);
            }

        }
    }
}
