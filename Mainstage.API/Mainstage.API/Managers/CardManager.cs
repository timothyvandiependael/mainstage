using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;

namespace Mainstage.API.Managers
{
    public class CardManager
    {
        private readonly MainstageContext _context;

        public CardManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<Card>> GetAllAsync()
        {
            return await _context.Cards.ToListAsync();
        }

        public async Task<Card> GetByIdAsync(int id)
        {
            return await _context.Cards.FindAsync(id);
        }

        public async Task<Card> GetFirstByName(string name)
        {
            var matches = await _context.Cards.Where(c => c.Name == name).ToListAsync();
            return matches.First();
        }

        public async Task AddAsync(Card entity)
        {
            _context.Cards.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Card entity)
        {
            _context.Cards.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _context.Cards.FindAsync(id);
            if (entity != null)
            {
                _context.Cards.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task <List<Card>> GetCardListForJoker()
        {
            // No doubles and exclude cards that would do nothing or are not applicable in the situation of drawing the joker card
            var excludedCardIds = new List<int>
            {
                3, 8, 9, 12, 13, 17, 18, 19, 20, 21, 22, 24, 26, 30, 33, 35, 39, 43, 46, 47, 48, 49, 51, 55, 58, 60, 61,
                63, 66, 69, 70, 72, 73, 74, 76, 77
            };

            var cards = await _context.Cards
                .Where(c => !excludedCardIds.Contains(c.Id))
                .GroupBy(c => c.Name)
                .Select(g => g.FirstOrDefault())
                .ToListAsync();

            return cards;
        }
    }
}
