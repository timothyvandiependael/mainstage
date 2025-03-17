using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GamePlayerCardManager
    {
        private readonly MainstageContext _context;

        public GamePlayerCardManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<GamePlayerCard>> GetAllAsync()
        {
            return await _context.GamePlayerCards.ToListAsync();
        }

        public async Task<GamePlayerCard> GetByIdAsync(int gameId, string playerId, int cardId)
        {
            return await _context.GamePlayerCards.FindAsync(gameId, playerId, cardId);
        }

        public async Task AddAsync(GamePlayerCard entity)
        {
            _context.GamePlayerCards.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(GamePlayerCard entity)
        {
            _context.GamePlayerCards.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int gameId, string playerId, int cardId)
        {
            var entity = await _context.GamePlayerCards.FindAsync(gameId, playerId, cardId);
            if (entity != null)
            {
                _context.GamePlayerCards.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteForPlayerAsync(int gameId, string playerId)
        {
            var cards = await _context.GamePlayerCards.Where(c => c.GameId == gameId && c.PlayerId == playerId).ToListAsync();

            foreach (var card in cards)
            {
                await DeleteAsync(card.GameId, card.PlayerId, card.CardId);
            }
        }
    }
}
