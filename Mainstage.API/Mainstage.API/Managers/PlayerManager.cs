using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class PlayerManager
    {
        private readonly MainstageContext _context;

        public PlayerManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<Player>> GetAllAsync()
        {
            return await _context.Players.ToListAsync();
        }

        public async Task<Player> GetByIdAsync(string id)
        {
            return await _context.Players.FindAsync(id);
        }

        public async Task AddAsync(Player entity)
        {
            _context.Players.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Player entity)
        {
            _context.Players.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(string id)
        {
            var entity = await _context.Players.FindAsync(id);
            if (entity != null)
            {
                _context.Players.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
