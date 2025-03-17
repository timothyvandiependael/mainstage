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
    public class GameController : ControllerBase
    {
        private readonly GameManager _gameManager;

        public GameController(GameManager gameManager)
        {
            _gameManager = gameManager;
        }

        [HttpPost("creategame")]
        public async Task<ActionResult<Game>> CreateGame([FromBody] Game game)
        {
            await _gameManager.AddAsync(game);
            return CreatedAtAction(nameof(GetGame), new { id = game.Id }, game);
        }

        [HttpGet("getgame")]
        public async Task<ActionResult<Game>> GetGame(int id)
        {
            var game = await _gameManager.GetByIdAsync(id);

            if (game == null)
            {
                return NotFound();
            }

            return Ok(game);
        }

        [HttpGet("getallopenpublicgames")] 
        public async Task<ActionResult<List<Game>>> GetAllOpenPublicGames()
        {
            var games = await _gameManager.GetAllOpenPublicAsync();
            if (games != null)
            {
                return Ok(games);
            }

            return BadRequest("Er liep iets fout tijdens het ophalen van de open games.");
        }
    }
}
