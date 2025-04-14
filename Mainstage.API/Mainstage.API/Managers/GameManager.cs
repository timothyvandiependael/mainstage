using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GameManager
    {
        private readonly MainstageContext _context;
        private readonly GamePlayerManager _gamePlayerManager;
        private readonly GameCardManager _gameCardManager;
        private readonly GameActionManager _gameActionManager;
        private readonly GameOptionsManager _gameOptionsManager;
        private readonly CardManager _cardManager;
        private readonly TileManager _tileManager;

        public GameManager(MainstageContext context, GamePlayerManager gamePlayerManager, GameCardManager gameCardManager, 
            GameActionManager gameActionManager, GameOptionsManager gameOptionsManager, CardManager cardManager,
            TileManager tileManager)
        {
            _context = context;
            _gamePlayerManager = gamePlayerManager;
            _gameCardManager = gameCardManager;
            _gameActionManager = gameActionManager;
            _gameOptionsManager = gameOptionsManager;
            _cardManager = cardManager;
            _tileManager = tileManager;
        }

        public async Task<List<Game>> GetAllAsync()
        {
            var games = await _context.Games.ToListAsync();
            await GetAdditionalGameElementsListAsync(games);
            return games;
        }

        public async Task<List<Game>> GetAllOpenPublicAsync()
        {
            var games = await _context.Games.Where(g => g.IsPublic && g.State == "open").ToListAsync();
            await GetAdditionalGameElementsListAsync(games);
            return games;
        }

        public async Task<Game> GetByIdAsync(int id)
        {
            var game = await _context.Games.FindAsync(id);
            await GetAdditionalGameElementsAsync(game);
            return game;
        }

        public async Task AddAsync(Game entity)
        {
            _context.Games.Add(entity);
            await _context.SaveChangesAsync();
            entity.Options.GameId = entity.Id;
            await AddAdditionalGameElementsAsync(entity);
        }

        public async Task<int> AddAndGetIdAsync(Game entity)
        {
            _context.Games.Add(entity);
            await _context.SaveChangesAsync();
            await AddAdditionalGameElementsAsync(entity);
            return entity.Id;
        }

        public async Task UpdateAsync(Game entity)
        {
            _context.Games.Update(entity);
            await UpdateAdditionalGameElementsAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _context.Games.FindAsync(id);
            if (entity != null)
            {
                await RemoveAdditionalGameElementsAsync(entity);
                _context.Games.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task RemoveOpenGamesForUserAsync(string userId)
        {
            var games = await _context.Games.Where(g => g.CrUser == userId && g.State == "open").ToListAsync();
            if (games != null)
            {
                foreach (var game in games)
                {
                    await DeleteAsync(game.Id);
                }
            }    
        }

        private async Task GetAdditionalGameElementsListAsync(List<Game> games)
        {
            foreach (var game in games)
            {
                await GetAdditionalGameElementsAsync(game);
            }
        }

        private async Task GetAdditionalGameElementsAsync(Game game)
        {
            try
            {
                game.Options = await _gameOptionsManager.GetByIdAsync(game.Id);
                game.Actions = await _gameActionManager.GetForGameAsync(game.Id);

                var gameCards = await _gameCardManager.GetForGameAsync(game.Id);
                gameCards = gameCards.OrderBy(g => g.PilePosition).ToList();
                var cards = await _cardManager.GetAllAsync();
                foreach (var gameCard in gameCards)
                {
                    var card = cards.Where(c => c.Id == gameCard.CardId).First();
                    if (gameCard.Pile == "discard")
                    {
                        game.DiscardPile.Add(card);
                    }
                    else
                    {
                        game.DrawPile.Add(card);
                    }
                }

                game.Tiles = await _tileManager.GetAllAsync();
                game.Players = await _gamePlayerManager.GetForGameAsync(game.Id);
            }
            catch (Exception ex)
            {
                var x = ex;
                throw;
            }
            
        }

        private async Task UpdateAdditionalGameElementsAsync(Game game)
        {
            try
            {
                var optionsExist = await _gameOptionsManager.AnyForGameAsync(game.Id);
                if (optionsExist)
                {
                    await _gameOptionsManager.UpdateAsync(game.Options);
                }

                var existingActions = await _gameActionManager.GetForGameAsync(game.Id);
                foreach (var action in game.Actions)
                {
                    var existingAction = existingActions.Where(a => a.ActionId == action.ActionId).FirstOrDefault();
                    if (existingAction == null)
                    {
                        await _gameActionManager.AddAsync(action);
                    }
                }

                await _gameCardManager.UpdateCardsForGameAsync(game);

                var existingPlayers = await _gamePlayerManager.GetForGameAsync(game.Id);
                var playersToRemove = existingPlayers.Where(ep => !game.Players.Any(gp => gp.PlayerId == ep.PlayerId)).ToList();
                var playersToUpdate = game.Players.Where(gp => existingPlayers.Any(ep => ep.PlayerId == gp.PlayerId)).ToList();
                var playersToAdd = game.Players.Where(gp => !existingPlayers.Any(ep => ep.PlayerId == gp.PlayerId)).ToList();
                
                foreach (var player in existingPlayers)
                {
                    _context.Entry(player).State = EntityState.Detached;
                }

                foreach (var player in playersToRemove)
                {
                    await _gamePlayerManager.DeleteAsync(game.Id, player.PlayerId);
                }
                foreach (var player in playersToUpdate)
                {
                    _context.GamePlayers.Attach(player);
                    await _gamePlayerManager.UpdateAsync(player);
                }
                foreach (var player in playersToAdd)
                {
                    await _gamePlayerManager.AddAsync(player);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        private async Task AddAdditionalGameElementsAsync(Game game)
        {
            if (game.Options != null)
            {
                game.Options.GameId = game.Id;
                await _gameOptionsManager.AddAsync(game.Options);
            }
                

            if (game.Actions != null && game.Actions.Count > 0)
            {
                foreach (var action in game.Actions)
                {
                    action.GameId = game.Id;
                    await _gameActionManager.AddAsync(action);
                }
            }

            await _gameCardManager.AddCardsForGameAsync(game);

            if (game.Players != null && game.Players.Count > 0)
            {
                foreach (var player in game.Players)
                {
                    player.GameId = game.Id;
                    await _gamePlayerManager.AddAsync(player);
                }
            }
        }

        private async Task RemoveAdditionalGameElementsAsync(Game game)
        {
            var existingOptions = await _gameOptionsManager.GetByIdAsync(game.Id);
            if (existingOptions != null)
                await _gameOptionsManager.DeleteAsync(existingOptions.GameId);

            var existingActions = await _gameActionManager.GetForGameAsync(game.Id);
            if (existingActions != null)
            {
                foreach (var action in existingActions)
                {
                    await _gameActionManager.DeleteAsync(action.GameId, action.PlayerId, action.ActionId);
                }
            }

            var existingCards = await _gameCardManager.GetForGameAsync(game.Id);
            if (existingCards != null)
            {
                foreach (var card in existingCards)
                {
                    await _gameCardManager.DeleteAsync(card.GameId, card.CardId);
                }
            }

            var existingPlayers = await _gamePlayerManager.GetForGameAsync(game.Id);
            if (existingPlayers != null)
            {
                foreach (var player in existingPlayers)
                {
                    await _gamePlayerManager.DeleteAsync(player.GameId, player.PlayerId);
                }
            }
        }

        public async Task<List<Game>> GetUnfinishedForPlayerAsync(string playerId)
        {
            var gamePlayers = await _gamePlayerManager.GetForPlayer(playerId);
            var games = new List<Game>();
            foreach (var player in gamePlayers)
            {
                var game = await GetByIdAsync(player.GameId);
                if (game.State != "finished") 
                    games.Add(game);
            }

            return games;
        }

        public async Task<Game> GetActiveGameForPlayerAsync(string playerId)
        {
            var game = await (

                from p in _context.GamePlayers
                join g in _context.Games on p.GameId equals g.Id
                where g.State == "open" || g.State == "ongoing"
                select g

                ).FirstOrDefaultAsync();
            await GetAdditionalGameElementsAsync(game);
            return game;
        }

        public async Task SaveGameStateToDB(Game game)
        {
            await UpdateAsync(game);
            foreach (var player in game.Players)
            {
                await _gamePlayerManager.SaveFullPlayerStateToDB(player);
            }

            await _gameCardManager.DeleteForGameAsync(game.Id);

            foreach (var card in game.DrawPile)
            {
                var gameCard = new GameCard
                {
                    GameId = game.Id,
                    CardId = card.Id,
                    Pile = "draw",
                    CrDate = DateTime.Now,
                    LcDate = DateTime.Now,
                    CrUser = "sys",
                    LcUser = "sys"
                };

                await _gameCardManager.AddAsync(gameCard);
            }

            foreach (var card in game.DiscardPile)
            {
                var gameCard = new GameCard
                {
                    GameId = game.Id,
                    CardId = card.Id,
                    Pile = "discard",
                    CrDate = DateTime.Now,
                    LcDate = DateTime.Now,
                    CrUser = "sys",
                    LcUser = "sys"
                };

                await _gameCardManager.AddAsync(gameCard);
            }
        }
    }
}

