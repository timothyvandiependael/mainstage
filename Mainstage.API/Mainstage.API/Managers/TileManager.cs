using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class TileManager
    {
        private readonly MainstageContext _context;

        public TileManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<Tile>> GetAllAsync()
        {
            return await _context.Tiles.ToListAsync();
        }

        public async Task<Tile> GetByIdAsync(int id)
        {
            return await _context.Tiles.FindAsync(id);
        }

        public async Task AddAsync(Tile entity)
        {
            _context.Tiles.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Tile entity)
        {
            _context.Tiles.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _context.Tiles.FindAsync(id);
            if (entity != null)
            {
                _context.Tiles.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
