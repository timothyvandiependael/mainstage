using Mainstage.API.Data;
using Mainstage.API.Models;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GameOptionsManager
    {
        private readonly MainstageContext _context;

        public GameOptionsManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<bool> AnyForGameAsync(int gameId)
        {
            return await _context.GameOptions.AnyAsync(g => g.GameId == gameId);
        }

        public async Task<List<GameOptions>> GetAllAsync()
        {
            return await _context.GameOptions.ToListAsync();
        }

        public async Task<GameOptions> GetByIdAsync(int id)
        {
            return await _context.GameOptions.FindAsync(id);
        }

        public async Task AddAsync(GameOptions entity)
        {
            try
            {
                _context.GameOptions.Add(entity);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                var x = ex;
                throw;
            }
        }

        public async Task UpdateAsync(GameOptions entity)
        {
            _context.GameOptions.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _context.GameOptions.FindAsync(id);
            if (entity != null)
            {
                _context.GameOptions.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
