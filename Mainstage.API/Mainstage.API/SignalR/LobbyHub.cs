using Mainstage.API.Managers;
using Mainstage.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace Mainstage.API.SignalR
{
    [Authorize]
    public class LobbyHub : Hub
    {
        private readonly ChatMessageManager _chatMessageManager;
        private readonly GameManager _gameManager;
        private readonly GameOptionsManager _gameOptionsManager;
        private static readonly Dictionary<string, string> _userConnections = new();
        private static Dictionary<string, CancellationTokenSource> _disconnectTimers = new();
        public LobbyHub(ChatMessageManager chatMessageManager, GameManager gameManager, GameOptionsManager gameOptionsManager)
        {
            _chatMessageManager = chatMessageManager;
            _gameManager = gameManager;
            _gameOptionsManager = gameOptionsManager;
        }

        public async Task SendMessage(string message)
        {
            var user = Context.User?.Identity?.Name;
            var chatMessage = new ChatMessage
            {
                ChatId = 0,
                PlayerId = user,
                Message = message,
                CrDate = DateTime.Now,
                CrUser = user,
                LcDate = DateTime.Now,
                LcUser = user
            };
            await _chatMessageManager.AddAsync(chatMessage);
            var allMessages = await _chatMessageManager.GetForChatAsync(0);
            await Clients.All.SendAsync("ReceiveChatMessages", allMessages);
        }

        public async Task CreateGame(GameOptions gameOptions)
        {
            var game = new Game
            {
                Name = "Spel van " + Context.User?.Identity?.Name,
                State = "open",
                IsPublic = true,
                CrDate = DateTime.Now,
                CrUser = Context.User?.Identity?.Name,
                LcDate = DateTime.Now,
                LcUser = Context.User?.Identity?.Name
            };

            game.Options = gameOptions;
            game.Options.CrDate = game.CrDate;
            game.Options.CrUser = game.CrUser;
            game.Options.LcDate = game.LcDate;
            game.Options.LcUser = game.LcUser;

            var gamePlayer = new GamePlayer
            {
                PlayerId = Context.User?.Identity?.Name,
                State = "joined",
                Position = 0,
                HasTurn = false,
                TurnStartMode = "",
                CrDate = DateTime.Now,
                LcDate = DateTime.Now,
                CrUser = Context.User?.Identity?.Name,
                LcUser = Context.User?.Identity?.Name
            };
            if (game.Players == null) game.Players = new List<GamePlayer>();
            game.Players.Add(gamePlayer);

            game.Id = await _gameManager.AddAndGetIdAsync(game);

            var openGames = await _gameManager.GetAllOpenPublicAsync();
            try
            {
                Console.WriteLine($"User: {Context.User?.Identity?.Name}, ConnectionId: {Context.ConnectionId}");
                await Clients.Client(_userConnections[Context.User?.Identity?.Name]).SendAsync("NavigateToGameScreen", game);
                await Clients.All.SendAsync("ReceiveGameUpdates", openGames);
            }
            catch (Exception ex)
            {
                var x = ex;
                throw;
            }
            
        }

        public async Task UpdateLobbyForCurrentUser()
        {
            var allMessages = await _chatMessageManager.GetForChatAsync(0);
            await Clients.Client(_userConnections[Context.User?.Identity?.Name]).SendAsync("ReceiveChatMessages", allMessages);
            var openGames = await _gameManager.GetAllOpenPublicAsync();
            await Clients.Client(_userConnections[Context.User?.Identity?.Name]).SendAsync("ReceiveGameUpdates", openGames);

        }

        public async Task DeleteGame(int id)
        {
            await _gameManager.DeleteAsync(id);
            var openGames = await _gameManager.GetAllOpenPublicAsync();
            await Clients.All.SendAsync("ReceiveGameUpdates", openGames);
        }

        public override async Task OnConnectedAsync()
        {
            var userId = Context.User?.Identity?.Name;
            Console.WriteLine($"user id: {userId}");

            if (_userConnections.ContainsKey(userId))
            {
                _userConnections[userId] = Context.ConnectionId;
                await Reconnect();
            }
            else
            {
                _userConnections.Add(userId, Context.ConnectionId);
            }

            await Clients.Caller.SendAsync("Connected", Context.ConnectionId);

            Console.WriteLine($"User connected: {Context.ConnectionId}");

            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            var userId = Context.User?.Identity?.Name;

            var cts = new CancellationTokenSource();
            _disconnectTimers[userId] = cts;

            try
            {
                await Task.Delay(TimeSpan.FromSeconds(120), cts.Token);
                _userConnections.Remove(userId);

                Console.WriteLine($"User disconnected: {Context.ConnectionId}");

            }
            catch (TaskCanceledException)
            {
                throw;
            }
            finally
            {
                _disconnectTimers.Remove(userId);
            }        

            await base.OnDisconnectedAsync(exception);
        }

        public async Task KeepAlive()
        {
            var userId = Context.User?.Identity?.Name;
            Console.WriteLine($"Received keep-alive ping from {userId}");
        }

        public async Task Reconnect()
        {
            await Task.Delay(2000);
            var userId = Context.User?.Identity?.Name;
            if (_disconnectTimers.TryGetValue(userId, out var cts))
            {
                cts.Cancel();
                _disconnectTimers.Remove(userId);
            }
        }

    }
}
