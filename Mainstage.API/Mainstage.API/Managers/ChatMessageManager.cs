using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace Mainstage.API.Managers
{
    public class ChatMessageManager
    {
        private readonly MainstageContext _context;

        public ChatMessageManager(MainstageContext context)
        {
            _context = context;
        }

        public async Task<List<ChatMessage>> GetAllAsync()
        {
            return await _context.ChatMessages.ToListAsync();
        }

        public async Task<List<ChatMessage>> GetForChatAsync(int chatId, int lastXMessages = 500)
        {
            try
            {
                return await _context.ChatMessages.Where(c => c.ChatId == chatId).OrderByDescending(c => c.CrDate)
                    .Take(lastXMessages).OrderBy(c => c.CrDate).ToListAsync();
            }
            catch (Exception ex)
            {
                var x = ex;
                throw;
            }
            
        }

        public async Task<ChatMessage> GetByIdAsync(int chatId, string playerId, int messageId)
        {
            return await _context.ChatMessages.FindAsync(chatId, playerId, messageId);
        }

        public async Task AddAsync(ChatMessage entity)
        {
            try
            {
                _context.ChatMessages.Add(entity);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                var x = 10;
            }
        }

        public async Task UpdateAsync(ChatMessage entity)
        {
            _context.ChatMessages.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int chatId, string playerId, int messageId)
        {
            var entity = await _context.ChatMessages.FindAsync(chatId, playerId, messageId);
            if (entity != null)
            {
                _context.ChatMessages.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
