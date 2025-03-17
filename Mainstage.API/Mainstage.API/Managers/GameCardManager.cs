using Mainstage.API.Models;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;

namespace Mainstage.API.Managers
{
    public class GameCardManager
    {
        private readonly MainstageContext _context;
        private readonly CardManager _cardManager;

        public GameCardManager(MainstageContext context, CardManager cardManager)
        {
            _context = context;
            _cardManager = cardManager;
        }

        public async Task<List<GameCard>> GetAllAsync()
        {
            return await _context.GameCards.ToListAsync();
        }

        public async Task<List<GameCard>> GetForGameAsync(int gameId)
        {
            return await _context.GameCards.Where(c => c.GameId == gameId).ToListAsync();
        }

        public async Task<GameCard> GetByIdAsync(int gameId, int cardId)
        {
            return await _context.GameCards.FindAsync(gameId, cardId);
        }

        public async Task AddAsync(GameCard entity)
        {
            _context.GameCards.Add(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(GameCard entity)
        {
            _context.GameCards.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int gameId, int cardId)
        {
            var entity = await _context.GameCards.FindAsync(gameId, cardId);
            if (entity != null)
            {
                _context.GameCards.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteForGameAsync(int gameId)
        {
            var cards = await _context.GameCards.Where(c => c.GameId == gameId).ToListAsync();
            foreach (var card in cards)
            {
                await DeleteAsync(card.GameId, card.CardId);
            }
        }

        public async Task UpdateCardsForGameAsync(Game game)
        {
            await UpdatePileAsync(game, true, game.DiscardPile);
            await UpdatePileAsync(game, false, game.DrawPile);
        }

        private async Task UpdatePileAsync(Game game, bool isDiscard, List<Card> cards)
        {
            foreach (var card in cards)
            {
                var gameCard = await GetByIdAsync(game.Id, card.Id);
                if (gameCard != null)
                {
                    gameCard.Pile = isDiscard ? "discard" : "draw";
                    gameCard.PilePosition = cards.IndexOf(card);
                    await UpdateAsync(gameCard);
                }
            }
        }

        public async Task AddCardsForGameAsync(Game game)
        {
            var cards = await _cardManager.GetAllAsync();
            if (!game.Options.UseMegaFatLady)
            {
                cards = cards.Where(c => c.Id != 59).ToList(); // ID of Mega Fat Lady
            }

            var rng = new Random(DateTime.Now.Millisecond);

            while (cards.Count > 0)
            {
                var cardIndex = rng.Next(0, cards.Count);
                var selectedCard = cards[cardIndex];
                game.DrawPile.Add(selectedCard);

                var gameCard = new GameCard
                {
                    GameId = game.Id,
                    CardId = selectedCard.Id,
                    Pile = "draw",
                    PilePosition = game.DrawPile.IndexOf(selectedCard),
                    CrDate = DateTime.Now,
                    LcDate = DateTime.Now,
                    CrUser = "sys",
                    LcUser = "sys"
                };
                await AddAsync(gameCard);

                cards.Remove(selectedCard);
            }
        }
    }
}
