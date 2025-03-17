using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class TempUserManager
    {
        private readonly AuthContext _context;

        public TempUserManager(AuthContext context)
        {
            _context = context;
        }

        public async Task<List<TempUser>> GetAllAsync()
        {
            return await _context.TempUsers.ToListAsync();
        }

        public async Task<TempUser> GetByIdAsync(string id)
        {
            return await _context.TempUsers.FindAsync(id);
        }

        public async Task DeleteOldEntries()
        {
            var oldEntries = _context.TempUsers.Where(u => u.TokenExpirationDate <= DateTime.Now);
            foreach (var u in oldEntries)
            {
                _context.TempUsers.Remove(u);
            }
            await _context.SaveChangesAsync();
        }

        public async Task AddAsync(TempUser entity)
        {
            _context.TempUsers.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(TempUser entity)
        {
            _context.TempUsers.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(string id)
        {
            var entity = await _context.TempUsers.FindAsync(id);
            if (entity != null)
            {
                _context.TempUsers.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}

