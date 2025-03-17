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
    public class CardController : ControllerBase
    {
        private readonly CardManager _cardManager;

        public CardController(CardManager cardManager)
        {
            _cardManager = cardManager;
        }

        [HttpGet("get")]
        public async Task<ActionResult<Game>> Get(int id)
        {
            var card = await _cardManager.GetByIdAsync(id);

            if (card == null)
            {
                return NotFound();
            }

            return Ok(card);
        }
    }
}
