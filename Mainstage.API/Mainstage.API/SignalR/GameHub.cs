using Mainstage.API.Managers;
using Mainstage.API.Models;
using Mainstage.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace Mainstage.API.SignalR
{
    [Authorize]
    public class GameHub : Hub
    {
        private readonly ChatMessageManager _chatMessageManager;
        private readonly GameManager _gameManager;
        private readonly GameOptionsManager _gameOptionsManager;
        private readonly GamePlayerManager _gamePlayerManager;
        private static readonly Dictionary<string, string> _userConnections = new();
        private static Dictionary<string, CancellationTokenSource> _disconnectTimers = new();
        private readonly GameLogicService _gameLogicService;
        private readonly CardService _cardService;
        private readonly CardManager _cardManager;
        private readonly GameActionService _gameActionService;
        public GameHub(
            ChatMessageManager chatMessageManager, 
            GameManager gameManager, 
            GameOptionsManager gameOptionsManager,
            GamePlayerManager gamePlayerManager, 
            GameLogicService gameLogicService,
            CardService cardService,
            CardManager cardManager,
            GameActionService gameActionService
            )
        {
            _chatMessageManager = chatMessageManager;
            _gameManager = gameManager;
            _gameOptionsManager = gameOptionsManager;
            _gamePlayerManager = gamePlayerManager;
            _gameLogicService = gameLogicService;
            _cardService = cardService;
            _cardManager = cardManager;
            _gameActionService = gameActionService;
        }

        public async Task AddToGroup(int gameId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, gameId.ToString());
        }

        public async Task JoinGame(Game game)
        {
            var userId = Context.User?.Identity?.Name;
            await Groups.AddToGroupAsync(Context.ConnectionId, game.Id.ToString());
            var gamePlayer = new GamePlayer
            {
                GameId = game.Id,
                PlayerId = userId,
                State = "joined",
                Position = 0,
                HasTurn = false,
                TurnStartMode = "",
                CrDate = DateTime.Now,
                LcDate = DateTime.Now,
                CrUser = userId,
                LcUser = userId
            };

            if (!game.Players.Any(p => p.PlayerId == userId))
            {
                

                game.Players.Add(gamePlayer);
                await _gameManager.UpdateAsync(game);
                game = await _gameManager.GetByIdAsync(game.Id);

                await SendMessage($"Welkom, speler {gamePlayer.PlayerId}", game.Id, true);
            }
            await Clients.Group(game.Id.ToString()).SendAsync("PlayerJoined", gamePlayer, game);
        }

        public async Task PlayerReady(int gameId, string playerId)
        {
            var game = await _gameManager.GetByIdAsync(gameId);
            var player = game.Players.Where(p => p.PlayerId == playerId).FirstOrDefault();
            player.State = "ready";
            await _gamePlayerManager.SaveFullPlayerStateToDB(player);

            var readyCount = game.Players.Where(p => p.State == "ready").Count();
            if (readyCount == game.Options.PlayerAmount)
            {
                game.State = "started";
                await _gameManager.UpdateAsync(game);
                await Clients.Group(gameId.ToString()).SendAsync("GameStarted", game);
            }
            else
            {
                await Clients.Group(gameId.ToString()).SendAsync("PlayerReady", player, game);
                await SendMessage($"Speler {player.PlayerId} is klaar om te spelen.", game.Id, true);
            }
        }

        public async Task ExitGame(int gameId, string playerId)
        {
            var game = await _gameManager.GetByIdAsync(gameId);
            if (game.State == "open")
            {
                if (game.CrUser == playerId)
                {
                    await _gameManager.DeleteAsync(game.Id);
                    foreach (var player in game.Players)
                    {
                        await Groups.RemoveFromGroupAsync(_userConnections[player.PlayerId], gameId.ToString());
                        // await _gamePlayerManager.DeleteAsync(player.GameId, player.PlayerId);
                        await Clients.Client(_userConnections[player.PlayerId]).SendAsync("GameCancelled", game);
                    }
                }
                else
                {
                    
                    await Groups.RemoveFromGroupAsync(Context.ConnectionId, gameId.ToString());
                    var player = _gamePlayerManager.GetByIdAsync(gameId, playerId);
                    
                    await _gamePlayerManager.DeleteAsync(gameId, playerId);
                    game.Players.RemoveAll(p => p.PlayerId == playerId);

                    await Clients.Group(gameId.ToString()).SendAsync("PlayerLeft", player, game);
                    await SendMessage($"Speler {playerId} heeft het spel verlaten.", gameId, true);
                }
            }
            else
            {
                // TODO : In game logic for exit
            }
            
        }

        public async Task SendMessage(string message, int gameId, bool isSysMessage = false)
        {
            var user = Context.User?.Identity?.Name;
            var chatMessage = new ChatMessage
            {
                ChatId = gameId,
                PlayerId = isSysMessage ? "sys" : user,
                Message = message,
                CrDate = DateTime.Now,
                CrUser = user,
                LcDate = DateTime.Now,
                LcUser = user
            };
            await _chatMessageManager.AddAsync(chatMessage);
            var allMessages = await _chatMessageManager.GetForChatAsync(gameId);
            await Clients.Group(gameId.ToString()).SendAsync("ReceiveMessages", allMessages);
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
                // TODO: use signal to pause game for everyone with countdown for disconnection
                // This way player does not lose any interrupt chances
                // Reset game to start of last action for everyone? To be tried and tested

                /*await Task.Delay(TimeSpan.FromSeconds(60), cts.Token);
                var games = await _gameManager.GetUnfinishedForPlayerAsync(userId);
                foreach (var game in games)
                {
                    await ExitGame(game.Id, userId);
                }

                _userConnections.Remove(userId);*/

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

        // Game Logic:

        public async Task RollDie(int gameId, string playerId)
        {
            var roll = _gameLogicService.Roll();
            await Clients.Group(gameId.ToString()).SendAsync("DieRoll", playerId, roll);

        }

        public async Task ProcessGameStartDieRoll(int gameId, string playerId, int roll)
        {
            var info = await _gameLogicService.ProcessGameStartDieRoll(gameId, playerId, roll);
            if (info != null)
            {
                await Clients.Group(gameId.ToString()).SendAsync("OnGameStartDieRollsProcessed", info);
            }
        }

        public async Task ProcessPlayerAction(GameStateInfo info, string type, Dictionary<string, string> parameters)
        {
            var playerId = Context.User?.Identity?.Name;
            if (info.ActionSequence.Count > 0 && info.ActionSequence[0].ActionType == "startturn")
            {
                var startTurnAction = info.ActionSequence[0];
                info.ActionSequence.Remove(startTurnAction);
                info.Game.Actions.Add(startTurnAction);
            }

            if (type == "perform")
            {
                if (info.ActionSequence.Count > 0 && info.ActionSequence[0].ActionType == "awaitingperformroll")
                {
                    var awaitPerformRollAction = info.ActionSequence[0];
                    info.ActionSequence.Remove(awaitPerformRollAction);
                }
                await _gameLogicService.ProcessRoll(info, playerId, type, parameters);
                _gameActionService.InsertInActionSequence(info, playerId, type, parameters["roll"]);
                await _gameLogicService.Perform(info);
            }
            else if (type == "move")
            {
                if (info.ActionSequence.Count > 0 && info.ActionSequence[0].ActionType == "awaitingmoveroll")
                {
                    var awaitMoveRollAction = info.ActionSequence[0];
                    info.ActionSequence.Remove(awaitMoveRollAction);
                }
                await _gameLogicService.ProcessRoll(info, playerId, type, parameters);

                var interrupted = await IsInterrupted(info, playerId, "move", string.Empty);
                if (!interrupted)
                {
                    _gameActionService.InsertInActionSequence(info, playerId, type, parameters["roll"]);
                    await _gameLogicService.ExecuteMove(info, playerId, "+");
                }    
            }
            else if (type == "battle")
            {
                if (info.ActionSequence.Count > 0)
                {
                    var awaitingBattleRollAction = 
                        info.ActionSequence.Where(a => a.ActionType == "awaitingbattleroll" && a.PlayerId == playerId).FirstOrDefault();
                    if (awaitingBattleRollAction != null)
                    {
                        info.ActionSequence.Remove(awaitingBattleRollAction);
                        parameters.Add("role", awaitingBattleRollAction.Parameter);
                        await _gameLogicService.ProcessRoll(info, playerId, type, parameters);

                        var battleRollActions = info.ActionSequence.Where(a => a.ActionType == "awaitingbattleroll").ToList();
                        if (battleRollActions.Count == 0)
                        {
                            await _gameLogicService.ResolveBattle(info);
                        }
                    }

                }
            }
            else if (type == "collective")
            {
                if (info.ActionSequence.Count > 0)
                {
                    var awaitingCollectiverollAction =
                        info.ActionSequence.Where(a => a.ActionType == "awaitingcollectiveroll" && a.PlayerId == playerId).FirstOrDefault();
                    if (awaitingCollectiverollAction != null)
                    {
                        info.ActionSequence.Remove(awaitingCollectiverollAction);
                        await _gameLogicService.ProcessRoll(info, playerId, type, parameters);

                        var collectiveRollActions = info.ActionSequence.Where(a => a.ActionType == "awaitingcollectiveroll").ToList();
                        if (collectiveRollActions.Count == 0)
                        {
                            var cardId = int.Parse(awaitingCollectiverollAction.Parameter);
                            await _cardService.ResolveCollectiveRoll(info, playerId, _gameLogicService, cardId);
                        }
                    }
                }
            }
            else if (type == "stashcard")
            {
                await _gameLogicService.StashCard(info, playerId, parameters);
            }
            else if (type == "playcard")
            {
                var card = await _cardManager.GetByIdAsync(int.Parse(parameters["cardid"]));
                _gameActionService.AddActionHistory(info, playerId, "playcard", card.Id.ToString());
                var jokerCard = string.Empty;
                if (card.Id == 73) // joker
                {
                    jokerCard = parameters["jokercard"];
                }
                await ShowCardToEveryone(info, playerId, card, jokerCard);
                var interrupted = await IsInterrupted(info, playerId, "playcard", parameters["cardid"]);
                if (!interrupted)
                {
                    await _gameLogicService.PlayCard(info, playerId, parameters);
                }
                else
                {
                    _gameActionService.AddActionHistory(info, playerId, "cardinterrupted", card.Id.ToString());
                    await _gameLogicService.DiscardCard(info, playerId, parameters);
                }
                
            }

            await Clients.Group(info.Game.Id.ToString()).SendAsync("OnPlayerActionProcessed", info);
        }

        private async Task ShowCardToEveryone(GameStateInfo info, string playerId, Card card, string jokerCard)
        {
            await Clients.Group(info.Game.Id.ToString()).SendAsync("ShowCardToEveryone", playerId, card, jokerCard);
            await Task.Delay(2500);
        }

        private async Task<bool> IsInterrupted(GameStateInfo info, string playerId, string actionType, string actionParameter)
        {
            var interrupted = false;
            if (_gameLogicService.AnyPlayerHasCards(info))
            {
                await Clients.Group(info.Game.Id.ToString()).SendAsync("GiveInterruptChance", playerId, actionType, actionParameter);
                interrupted = await _gameLogicService.IsInterrupted(info, playerId);
            }

            return interrupted;
        }
    }
}
