using Mainstage.API.Data;
using Mainstage.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Mainstage.API.Managers;

namespace Mainstage.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ChatMessageController : ControllerBase
    {
        private readonly ChatMessageManager _chatMessageManager;

        public ChatMessageController(ChatMessageManager chatMessageManager)
        {
            _chatMessageManager = chatMessageManager;
        }

        [HttpGet("getforchat")]
        public async Task<ActionResult<List<ChatMessage>>> GetForChat(int chatId, int lastXMessages)
        {
            var messages = await _chatMessageManager.GetForChatAsync(chatId, lastXMessages);
            if (messages != null)
            {
                return Ok(messages);
            }

            return BadRequest("Er liep iets fout tijdens het ophalen van de chatberichten.");
        }
    }
}
