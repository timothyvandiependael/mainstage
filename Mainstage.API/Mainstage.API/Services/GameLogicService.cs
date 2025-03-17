using Mainstage.API.Models;
using Mainstage.API.Managers;
using System.ComponentModel.DataAnnotations;
using System.Reflection.Metadata;
using Microsoft.AspNetCore.SignalR;
using Mainstage.API.SignalR;
using System.Numerics;

namespace Mainstage.API.Services
{
    public class GameLogicService
    {
        private static List<GameStartRoll> _gameStartRolls = new List<GameStartRoll>();
        private static Dictionary<int, bool> _mustRerollGameStart = new Dictionary<int, bool>();
        private static List<GameStartRoll> _gameStartRerolls = new List<GameStartRoll>();
        private readonly Dictionary<string, TaskCompletionSource<bool>> _interruptResponses = new();
        private readonly Dictionary<string, DateTime> _interruptExpirationTimes = new();
        private readonly Dictionary<string, int> _interruptcounters = new();
        private static readonly object _interruptLock = new();
        private readonly IHubContext<GameHub> _hubContext;

        private readonly CardService _cardService;
        private readonly CardManager _cardManager;
        private readonly GameManager _gameManager;
        private readonly GameActionManager _gameActionManager;
        public GameLogicService(
            CardService cardService,
            CardManager cardManager,
            GameManager gameManager,
            GameActionManager gameActionManager,
            IHubContext<GameHub> hubContext
            )
        {
            _cardService = cardService;
            _cardManager = cardManager;
            _gameManager = gameManager;
            _gameActionManager = gameActionManager;
            _hubContext = hubContext;
        }

        public int Roll()
        {
            // Random number between 1 (included) and 7 (excluded), emulating die roll, seeded with current milliseconds
            var rng = new Random(DateTime.Now.Millisecond);
            var roll = rng.Next(1, 7);
            return roll;
        }

        public async Task ProcessRoll(GameStateInfo info, string playerId, string type, Dictionary<string, string> parameters)
        {
            var roll = int.Parse(parameters["roll"]);
            // Players in 'panne' will be able to move again
            if (roll == 6)
            {
                var pannePlayers = info.Game.Players.Where(p => p.TurnStartMode == "panne").ToList();
                foreach (var p in pannePlayers)
                {
                    p.TurnStartMode = "normal";
                }
            }

            if (type != "you")
            {
                var battlerole = "";
                if (type == "battle")
                {
                    battlerole = parameters["role"];
                }
                AddActionHistory(info, playerId, type + "roll", roll.ToString() + (type == "battle" ? ";" + battlerole : string.Empty));
            }

            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            if (player.TurnStartMode == "panne")
            {
                await ActionSequenceNext(info);
            }
            else if (type == "you")
            {
                // TODO
                // var playerTeleportToStageEntry = info.TurnHistory.Where(t => t.Name == "teleport").Last();
                // AddTurnHistory(info, "performroll", roll.ToString(), playerTeleportToStageEntry.PlayerId);
            }

        }

        public async Task<GameStateInfo> ProcessGameStartDieRoll(int gameId, string playerId, int roll)
        {
            var game = await _gameManager.GetByIdAsync(gameId);
            var player = game.Players.Where(p => p.PlayerId == playerId).First();

            var gameStartRoll = new GameStartRoll
            {
                GameId = gameId,
                PlayerId = playerId,
                Roll = roll
            };
            var existingRoll = _gameStartRolls.Where(g => g.GameId == gameId && g.PlayerId == playerId).FirstOrDefault();
            if (existingRoll == null)
                _gameStartRolls.Add(gameStartRoll);
            else
                existingRoll.Roll = roll;

            var rollsForGame = _gameStartRolls.Where(g => g.GameId == gameId).ToList();

            var isReroll = false;
            if (_mustRerollGameStart.ContainsKey(gameId) && _mustRerollGameStart[gameId])
            {
                isReroll = true;
            }

            if ((rollsForGame.Count == game.Players.Count) || (isReroll && (rollsForGame.Count == _gameStartRerolls.Count)))
            {
                var info = new GameStateInfo();
                info.JokerCardList = await _cardManager.GetCardListForJoker();
                info.Game = game;
                foreach (var rollInfo in rollsForGame)
                {
                    var ga = new GameAction
                    {
                        GameId = game.Id,
                        PlayerId = rollInfo.PlayerId,
                        ActionId = GetNextActionId(info),
                        ActionType = "gamestartroll",
                        Parameter = rollInfo.Roll.ToString()
                    };

                    info.Game.Actions.Add(ga);
                }

                _gameStartRolls.RemoveAll(g => g.GameId == gameId);

                var highestRoll = rollsForGame.Max(r => r.Roll);
                var highestRolls = rollsForGame.Where(r => r.Roll == highestRoll).ToList();
                if (highestRolls.Count > 1)
                {
                    info.EventMessage = "Spelers ";
                    foreach (var r in highestRolls)
                    {
                        info.EventMessage += r.PlayerId;

                        var ga = new GameAction
                        {
                            GameId = game.Id,
                            PlayerId = r.PlayerId,
                            ActionId = GetNextActionId(info),
                            ActionType = "gamestartreroll",
                            Parameter = string.Empty
                        };

                        info.ActionSequence.Add(ga);
                        _gameStartRerolls.Add(r);

                        if (r != highestRolls.Last())
                            info.EventMessage += ", ";
                    }
                    info.EventMessage += " moeten opnieuw gooien.";

                    if (!_mustRerollGameStart.ContainsKey(gameId))
                        _mustRerollGameStart.Add(gameId, true);
                    else
                        _mustRerollGameStart[gameId] = true;
                }
                else
                {
                    var turnPlayerId = highestRolls.First().PlayerId;
                    info.ActionSequence.Add(new GameAction
                    {
                        GameId = game.Id,
                        PlayerId = turnPlayerId,
                        ActionId = GetNextActionId(info),
                        ActionType = "awaitingperformroll",
                        Parameter = ""
                    });

                    info.EventMessage = $"Speler {turnPlayerId} is aan de beurt. Gooi om te repeteren.";

                    _gameStartRolls.RemoveAll(g => g.GameId == gameId);
                    game.State = "ongoing";
                    await _gameManager.UpdateAsync(game);

                    if (isReroll)
                    {
                        _mustRerollGameStart[gameId] = false;
                        _gameStartRerolls.RemoveAll(g => g.GameId == gameId);
                    }
                }

                return info;
            }
            else
            {
                return null;
            }
        }

        public int GetNextActionHistoryId(GameStateInfo info)
        {
            var newId = info.Game.Actions.Max(a => a.ActionId) + 1;
            return newId;
        }

        public int GetNextActionId(GameStateInfo info)
        {
            var lastActionId = 0;
            if (info.ActionSequence != null && info.ActionSequence.Count > 0)
            {
                lastActionId = info.ActionSequence.Max(a => a.ActionId);
            }
            else if (info.Game.Actions != null && info.Game.Actions.Count > 0)
            {
                lastActionId = info.Game.Actions.Max(a => a.ActionId);
            }

            lastActionId++;
            return lastActionId;
        }

        public void AddActionHistory(GameStateInfo info, string playerId, string type, string parameter)
        {
            if (info.ActionSequence.Count > 0)
            {
                foreach (var action in info.ActionSequence)
                {
                    action.ActionId += 1;
                }
            }

            var ga = new GameAction()
            {
                GameId = info.Game.Id,
                PlayerId = playerId,
                ActionId = GetNextActionHistoryId(info),
                ActionType = type,
                Parameter = parameter
            };
            info.Game.Actions.Add(ga);
        }

        public void InsertInActionSequence(GameStateInfo info, string playerId, string type, string parameter)
        {
            if (info.ActionSequence.Count > 0)
            {
                foreach (var action in info.ActionSequence)
                {
                    action.ActionId += 1;
                }
            }
            var ga = new GameAction()
            {
                GameId = info.Game.Id,
                PlayerId = playerId,
                ActionId = GetNextActionHistoryId(info),
                ActionType = type,
                Parameter = parameter
            };
            info.ActionSequence.Insert(0, ga);
        }

        public GamePlayer GetNextActionPlayer(GameStateInfo info)
        {
            var nextAction = info.ActionSequence.First();
            if (nextAction == null)
            {
                return null;
            }
            else
            {
                var player = info.Game.Players.Where(p => p.PlayerId == nextAction.PlayerId).First();
                return player;
            }
        }

        public async Task Perform(GameStateInfo info)
        {
            var ga = info.ActionSequence.Where(a => a.ActionType == "perform").FirstOrDefault();
            if (ga != null)
            {
                var player = info.Game.Players.Where(p => p.PlayerId == ga.PlayerId).First();
                var roll = int.Parse(ga.Parameter);
                var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();
                var stageNumber = tile.Stage;
                var execution = "normal";

                var car = new ClientActionReport()
                {
                    PlayerId = player.PlayerId,
                    Type = "perform",
                    EventMessage = string.Empty
                };
                info.ClientActionReportQueue.Add(car);

                // If player played a stage pass that requires rolling, apply logic, else, use standard logic for stage
                var lastAction = info.Game.Actions.Last();
                if (lastAction.PlayerId == player.PlayerId && lastAction.ActionType == "playcard")
                {
                    var card = player.Cards.Where(c => c.Id == int.Parse(lastAction.Parameter)).First();
                    if (card.CardType == "pass")
                    {
                        execution = card.Parameter1; // Parameter1 contains the type of the stage pass (range of succesful rolls, or no roll required)
                    }
                }

                info.ActionSequence.Remove(ga);
                info.Game.Actions.Add(ga);

                List<int> allowedRolls = new List<int>();
                var failTileId = 0; // If player fails the performance, he moves to this tile
                if (execution == "normal")
                {
                    switch (stageNumber)
                    {
                        case 0:
                            allowedRolls = new List<int> { 3, 4, 5, 6 };
                            failTileId = 0;
                            break;
                        case 1:
                            allowedRolls = new List<int> { 4, 5, 6 };
                            failTileId = 22;
                            break;
                        case 2:
                            allowedRolls = new List<int> { 5, 6 };
                            failTileId = 42;
                            break;
                        case 3:
                            allowedRolls = new List<int> { 6 };
                            failTileId = 62;
                            break;
                    }
                }
                else
                {
                    var stringRolls = execution.Split(" ");
                    foreach (var sr in stringRolls)
                    {
                        allowedRolls.Add(int.Parse(sr));
                    }
                }

                if (allowedRolls.Contains(roll))
                {
                    if (player.ActiveEffects.ContainsKey("allornothing"))
                        player.ActiveEffects.Remove("allornothing");

                    if (player.Position == 0)
                    {
                        car.EventMessage =
                            $"De repetitie van {player.PlayerId} is geslaagd! {player.PlayerId} mag nu gooien om vooruit te gaan.";
                    }
                    else
                    {
                        var location = "";
                        var successType = "";

                        if (player.Position == 24)
                        {
                            location = "in het jeugdhuis";
                            switch (roll)
                            {
                                case 4:
                                    successType = "kon er net door.";
                                    break;
                                case 5:
                                    successType = "was goed!";
                                    break;
                                case 6:
                                    successType = "was goddelijk!";
                                    break;
                            }
                        }
                        else if (player.Position == 46)
                        {
                            location = "in de marquee";
                            switch (roll)
                            {
                                case 5:
                                    successType = "was goed genoeg.";
                                    break;
                                case 6:
                                    successType = "was fantastisch!";
                                    break;
                            }
                        }
                        else if (player.Position == 69)
                        {
                            location = "op de mainstage";
                            successType = "was glorieus! Gefeliciteerd, u bent gewonnen!";
                        }
                        car.EventMessage = $"Het optreden {location} van {player.PlayerId} {successType}";
                    }

                    await PassStage(info, player.PlayerId);
                }
                else if (player.ActiveEffects.ContainsKey("allornothing"))
                {
                    // if player ended up on main stage because of 'All or nothing' card, move to Jeugdhuis stage
                    player.ActiveEffects.Remove("allornothing");
                    car.EventMessage = $"Het optreden van {player.PlayerId} was een grandioze klucht.";
                    InsertInActionSequence(info, player.PlayerId, "teleport", "24");
                    await ActionSequenceNext(info);
                }
                else if (player.Position == 0)
                {
                    car.EventMessage = $"De repetitie van {player.PlayerId} was een grandioze klucht.";
                    await ActionSequenceNext(info);
                }
                else
                {
                    car.EventMessage = $"Het optreden van {player.PlayerId} was een grandioze klucht.";
                    InsertInActionSequence(info, player.PlayerId, "teleport", failTileId.ToString());
                    await ActionSequenceNext(info);
                }
            }
        }

        public async Task Teleport(GameStateInfo info, string playerId, bool noAction = false) // noAction for fat lady card
        {
            var action = info.ActionSequence.First();
            if (action.ActionType == "teleport" || action.ActionType == "zalmtravel")
            {
                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "teleport",
                    EventMessage = string.Empty
                };
                info.ClientActionReportQueue.Add(car);

                info.ActionSequence.Remove(action);
                info.Game.Actions.Add(action);

                var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
                player.Position = int.Parse(action.Parameter);

                if (noAction)
                {
                    await ActionSequenceNext(info);
                }
                else
                {
                    await ReachedDestination(info, playerId);
                }
            }
        }

        public async Task PassStage(GameStateInfo info, string playerId)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            AddActionHistory(info, player.PlayerId, "passedperform", player.Position.ToString());

            if (player.Position == 0)
            {
                InsertInActionSequence(info, playerId, "awaitingmoveroll", string.Empty);
            }
            else
            {
                await ActionSequenceNext(info);
            }

        }

        //public async Task EndPlayerSequence(GameStateInfo info, string playerId)
        //{
        //    if (info.ActionSequence.Count == 0)
        //    {
        //        await EndTurn(info);
        //    }
        //    else
        //    {
        //        var isBattleRoll = false;
        //        var isCollectiveRoll = false;
        //        var collectiveCardId = 0;

        //        if (info.ChainReaction[0].Type == "battleroll")
        //        {
        //            isBattleRoll = true;
        //        }
        //        if (info.ChainReaction[0].Type == "collectiveroll")
        //        {
        //            isCollectiveRoll = true;
        //            collectiveCardId = int.Parse(info.ChainReaction[0].Value);
        //        }

        //        if (info.ChainReaction[0].Type == "fatlady")
        //        {
        //            // If player draws fat lady card, he goes back to tile 0, loses all cards and anything that was still queued up
        //            // for them to happen in the action sequence will not happen anymore
        //            info.ChainReaction.RemoveAll(c => c.PlayerId == info.ChainReaction[0].PlayerId);
        //        }
        //        else
        //        {
        //            info.ChainReaction.RemoveAt(0);
        //        }

        //        if (info.ChainReaction.Count == 0)
        //        {
        //            if (isBattleRoll)
        //            {
        //                await ResolveBattle(info);
        //            }
        //            else if (isCollectiveRoll)
        //            {
        //                await _cardService.ResolveCollectiveRoll(info, this, collectiveCardId);
        //            }
        //            else
        //            {
        //                await EndTurn(info);
        //            }
        //        }
        //        else
        //        {
        //            if (isBattleRoll && info.ChainReaction[0].Type != "battleroll")
        //            {
        //                await ResolveBattle(info);
        //            }
        //            else if (isCollectiveRoll && info.ChainReaction[0].Type != "collectiveroll")
        //            {
        //                await _cardService.ResolveCollectiveRoll(info, this, collectiveCardId);
        //            }
        //            else
        //            {
        //                StartNextChainReactionPart(info);
        //            }

        //        }
        //    }
        //}

        public async Task EndTurn(GameStateInfo info)
        {
            var turnPlayerId = info.Game.Actions.Where(a => a.ActionType == "startturn").Last().PlayerId;
            var totalPlayers = info.Game.Players.Count;
            var playerInList = info.Game.Players.Where(p => p.PlayerId == turnPlayerId).First();
            var playerIndex = info.Game.Players.IndexOf(playerInList);

            var newPlayerIndex = 0;
            if (playerIndex < info.Game.Players.Count - 1)
            {
                newPlayerIndex = playerIndex + 1;
            }
            var newPlayerId = info.Game.Players[newPlayerIndex].PlayerId;

            await _gameManager.UpdateAsync(info.Game);

            var newPlayer = info.Game.Players.Where(p => p.PlayerId == newPlayerId).First();

            if (newPlayer.TurnStartMode.Contains("skipturn")) // keep track of potential turn skips and skip turn for that player
            {
                if (newPlayer.TurnStartMode.Contains("2"))
                {
                    newPlayer.TurnStartMode = "skipturn 1";
                }
                else
                {
                    newPlayer.TurnStartMode = "normal";
                }
                AddActionHistory(info, newPlayerId, "startturn", string.Empty);
                AddActionHistory(info, newPlayerId, "turnskipped", string.Empty);
                await EndTurn(info); // Repeat EndTurn to move to next player
            }
            else
            {
                // Get player for next turn, return to client
                InsertInActionSequence(info, newPlayerId, "startturn", string.Empty);
                var car = new ClientActionReport
                {
                    PlayerId = newPlayerId,
                    Type = "startturn",
                    EventMessage = "{newPlayerId} is aan de beurt. Gooi voor je zet."
                };
                info.ClientActionReportQueue.Add(car);
            }
        }

        public async Task ActionSequenceNext(GameStateInfo info)
        {
            if (info.ActionSequence.Count > 0)
            {
                var nextAction = info.ActionSequence[0];
                info.ActionSequence.Remove(nextAction);
                info.Game.Actions.Add(nextAction);

                switch (nextAction.ActionType)
                {
                    case "moveforward":
                        AddActionHistory(info, nextAction.PlayerId, "moveroll", nextAction.Parameter);
                        await ExecuteMove(info, nextAction.PlayerId, "+");
                        break;
                    case "moveforwardbandwagon":
                        AddActionHistory(info, nextAction.PlayerId, "moveroll", nextAction.Parameter);
                        await ExecuteMove(info, nextAction.PlayerId, "+");
                        var car = new ClientActionReport
                        {
                            PlayerId = nextAction.PlayerId,
                            Type = "bandwagonmove",
                            EventMessage = $"{nextAction.PlayerId} mag {nextAction.Parameter} vakjes vooruit dankzij bandwagon."
                        };
                        info.ClientActionReportQueue.Add(car);
                        break;
                    case "moveforwardandskipstage":
                        AddActionHistory(info, nextAction.PlayerId, "moveroll", nextAction.Parameter);
                        await ExecuteMove(info, nextAction.PlayerId, "+", true);
                        break;
                    case "movebackward":
                    case "movebackwards":
                        InsertInActionSequence(info, nextAction.PlayerId, "moveroll", nextAction.Parameter);
                        await ExecuteMove(info, nextAction.PlayerId, "-");
                        break;
                    case "zalmtravel":
                    case "teleport":
                        await Teleport(info, nextAction.PlayerId);
                        break;
                    case "teleportnoroll":
                        AddActionHistory(info, nextAction.PlayerId, "teleport", nextAction.Parameter);
                        await Teleport(info, nextAction.PlayerId, true);
                        break;
                    //case "youroll":
                    //    AddTurnHistory(info, "awaitingyouroll", info.ChainReaction[0].Value);
                    //    break;
                    case "drawcard":
                        var drawnCard = info.Game.DrawPile.First();
                        car = new ClientActionReport
                        {
                            PlayerId = nextAction.PlayerId,
                            Type = "carddrawn",
                            EventMessage = $"{nextAction.PlayerId} trekt een kaart."
                        };
                        info.ClientActionReportQueue.Add(car);
                        AddActionHistory(info, nextAction.PlayerId, "carddrawn", drawnCard.Id.ToString());
                        break;
                    case "drawetherealcard":
                        var card = await _cardManager.GetFirstByName(nextAction.Parameter);
                        car = new ClientActionReport
                        {
                            PlayerId = nextAction.PlayerId,
                            Type = "etherealcarddrawn",
                            EventMessage = $"{nextAction.PlayerId} speelt een kaart..."
                        };
                        info.ClientActionReportQueue.Add(car);
                        AddActionHistory(info, nextAction.PlayerId, "etherealcarddrawn", card.Id.ToString());
                        info.LastEtherealCard = card;
                        break;
                    case "reacheddestination":
                        await ReachedDestination(info, nextAction.PlayerId);
                        break;
                    case "fatlady":
                        info.ActionSequence.Remove(nextAction);
                        info.Game.Actions.Add(nextAction);
                        await _cardService.ExecuteFatLady(info, nextAction.PlayerId, this);
                        break;
                    case "losecards":
                        info.ActionSequence.Remove(nextAction);
                        info.Game.Actions.Add(nextAction);
                        await _cardService.ExecuteLoseCards(info, nextAction.PlayerId, this);
                        break;
                }
            }
            else
            {
                await EndTurn(info);
            }
        }

        public async Task ExecuteMove(GameStateInfo info, string playerId, string direction, bool skipStage = false)
        {
            var rollTurnAction = info.ActionSequence.FindLast(ta => ta.ActionType == "moveroll" && ta.PlayerId == playerId);
            info.ActionSequence.Remove(rollTurnAction);
            info.Game.Actions.Add(rollTurnAction);

            if (rollTurnAction != null)
            {
                var roll = int.Parse(rollTurnAction.Parameter);
                var player = info.Game.Players.Where(p => p.PlayerId == rollTurnAction.PlayerId).First();

                AddActionHistory(info, player.PlayerId, "starttile", player.Position.ToString());

                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "move" + (direction == "+" ? "forward" : "backward"),
                    EventMessage = string.Empty
                };
                info.ClientActionReportQueue.Add(car);

                // Move player 1 tile at a time
                for (var i = 1; i <= roll; i++)
                {
                    if (direction == "+")
                    {
                        player.Position++;
                        var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();

                        // If tile contains a player in 'panne', the player's panne is cancelled
                        var pannePlayer = info.Game.Players.Where(p => p.PlayerId != player.PlayerId
                                                                    && p.TurnStartMode == "panne"
                                                                    && p.Position == player.Position).FirstOrDefault();
                        if (pannePlayer != null)
                        {
                            pannePlayer.TurnStartMode = "normal";
                        }

                        // If tile is a stage, player needs to stop there, unless parameter skipstage.
                        if (tile.IsStage && !skipStage)
                        {
                            break;
                        }
                    }
                    else
                    {
                        if (player.Position > 0)
                            player.Position--;
                    }

                }

                AddActionHistory(info, player.PlayerId, "movetotile", player.Position.ToString());

                // Player reaches target tile
                await ReachedDestination(info, player.PlayerId);
            }
        }

        public async Task ReachedDestination(GameStateInfo info, string playerId)
        {
            // Checking in order, after arriving on tile
            // - Is the tile a stage? (player needs to perform)
            // - Arrow presence (player needs to move if at arrow source) 
            // - Other player presence (player needs to do battle with opponent if player present)
            // - Card yield on tile (player needs to draw a card if tile has card yield)

            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();

            // If tile is stage, report this in info object so that player can perform, and do no further checks
            if (IsStage(info, player))
            {
                InsertInActionSequence(info, playerId, "awaitingperformroll", string.Empty);
                var car = new ClientActionReport
                {
                    PlayerId = player.PlayerId,
                    Type = "awaitingperformroll",
                    EventMessage = $"{playerId} mag nu gooien om op te treden."
                };
                info.ClientActionReportQueue.Add(car);

                return;
            }

            // If player didn't travel upstream on an arrow by using the salmon card, check and handle arrow travel repositioning
            if (info.Game.Actions.Last().ActionType != "zalmtravel")
            {
                var result = ArrowCheck(info, player); // 0 if no arrow, otherwise tile number of target
                if (result > 0)
                {
                    InsertInActionSequence(info, player.PlayerId, "teleport", result.ToString());
                    await ActionSequenceNext(info);
                    return;
                }
            }

            var otherPlayerId = OtherPlayerOnTileCheck(info, player);
            // If other player found, return to client, set up sequencing and prepare for battle
            if (!string.IsNullOrEmpty(otherPlayerId))
            {
                var car = new ClientActionReport
                {
                    PlayerId = player.PlayerId,
                    Type = "awaitingbattleroll",
                    EventMessage = $"Battle tussen {playerId} en {otherPlayerId}. Hoogste worp wint!"
                };
                info.ClientActionReportQueue.Add(car);
                InsertInActionSequence(info, otherPlayerId, "awaitingbattleroll", "defender");
                InsertInActionSequence(info, playerId, "awaitingbattleroll", "attacker");
                return;
            }

            // If card drawn, return to client for card handling
            if (TileYieldsCardCheck(info, player))
            {
                var car = new ClientActionReport
                {
                    PlayerId = player.PlayerId,
                    Type = "carddrawn",
                    EventMessage = $"{player.PlayerId} trekt een kaart."
                };
                info.ClientActionReportQueue.Add(car);

                return;
            }

            // When ending up on normal tile, sequence ends
            await ActionSequenceNext(info);
        }

        public bool IsStage(GameStateInfo info, GamePlayer player)
        {
            var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();
            if (tile.IsStage)
            {
                return true;
            }
            return false;
        }

        public int ArrowCheck(GameStateInfo info, GamePlayer player)
        {
            var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();
            // Is there an arrow that takes you to another tile? 
            if (tile.ArrowTarget > 0)
            {

                return tile.ArrowTarget;
            }
            return 0;
        }

        public string OtherPlayerOnTileCheck(GameStateInfo info, GamePlayer player)
        {
            // Is there a player present on the tile? Report this in result, so that battle can commence
            var otherPlayer = info.Game.Players.Where(p => p.PlayerId != player.PlayerId
                                                          && p.Position == player.Position).FirstOrDefault();
            if (otherPlayer != null)
            {
                return otherPlayer.PlayerId;
            }
            return string.Empty;
        }

        public bool TileYieldsCardCheck(GameStateInfo info, GamePlayer player)
        {
            // Is the tile one that yields a card? Draw card
            var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();
            if (tile.HasCard)
            {
                var drawnCard = info.Game.DrawPile.First();
                AddActionHistory(info, player.PlayerId, "carddrawn", drawnCard.Id.ToString());
                return true;
            }
            return false;
        }

        public async Task ResolveBattle(GameStateInfo info)
        {
            var battleRolls = info.Game.Actions.Where(ta => ta.ActionType == "battleroll").Reverse().Take(2).Reverse().ToList();
            var lastEntry = battleRolls[battleRolls.Count - 1];
            var secondLastEntry = battleRolls[battleRolls.Count - 2];

            // Compare die rolls
            var winnerEntry = new GameAction();
            var loserEntry = new GameAction();

            var lastRoll = int.Parse(lastEntry.Parameter.Split(";")[0]);
            var secondLastRoll = int.Parse(secondLastEntry.Parameter.Split(";")[0]);


            if (lastRoll == secondLastRoll)
            {
                var lastRole = lastEntry.Parameter.Split(";")[1];
                var secondLastRole = secondLastEntry.Parameter.Split(";")[1];
                var car = new ClientActionReport
                {
                    PlayerId = lastEntry.PlayerId,
                    Type = "awaitingbattleroll",
                    EventMessage = $"Gelijke worpen! Gooi opnieuw."
                };
                info.ClientActionReportQueue.Add(car);
                InsertInActionSequence(info, secondLastEntry.PlayerId, "awaitingbattleroll", secondLastRole);
                InsertInActionSequence(info, lastEntry.PlayerId, "awaitingbattleroll", lastRole);
                return;
            }
            else
            {
                if (lastRoll > secondLastRoll)
                {
                    winnerEntry = lastEntry;
                    loserEntry = secondLastEntry;
                }
                else if (lastRoll < secondLastRoll)
                {
                    winnerEntry = secondLastEntry;
                    loserEntry = lastEntry;
                }

                var car = new ClientActionReport
                {
                    PlayerId = lastEntry.PlayerId,
                    Type = "resolvebattle",
                    EventMessage = $"{winnerEntry.PlayerId} heeft de battle gewonnen! {loserEntry.PlayerId} moet {loserEntry.Parameter.Split(";")[0]} vakjes terug"
                };
                info.ClientActionReportQueue.Add(car);

                InsertInActionSequence(info, loserEntry.PlayerId, "movebackwards", loserEntry.Parameter.Split(";")[0]);

                var winnerRole = winnerEntry.Parameter.Split(";")[1];
                if (winnerRole == "attacker")
                {
                    InsertInActionSequence(info, winnerEntry.PlayerId, "reacheddestination", winnerEntry.Parameter);
                }

                await ActionSequenceNext(info);
            }
        }

        public async Task StashCard(GameStateInfo info, string playerId, Dictionary<string, string> parameters)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var cardId = int.Parse(parameters["cardid"]);
            var card = await _cardManager.GetByIdAsync(cardId);

            if (card.IsKeeper)
            {
                player.Cards.Add(card);
                AddActionHistory(info, playerId, "stashcard", card.Id.ToString());
                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    EventMessage = $"{playerId} kiest om de kaart bij te houden.",
                    Type = "stashcard"
                };
            }
        }

        public async Task PlayCard(GameStateInfo info, string playerId, Dictionary<string, string> parameters)
        {
            var cardId = int.Parse(parameters["cardid"]);
            var card = await _cardManager.GetByIdAsync(cardId);
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();

            // if card played with joker, it's not actually a card from draw pile or hand, and it doesn't need to be added to discard
            // similar when card is executed via the #metoo card and the tousensemble card
            // we brand these cards as 'ethereal'
            var ethereal = parameters.ContainsKey("ethereal") && parameters["ethereal"] == "true";
            if (!ethereal)
            {
                if (player.Cards.Any(c => c.Id == card.Id))
                {
                    player.Cards.Remove(player.Cards.First(c => c.Id == card.Id));
                }
                if (info.Game.DrawPile.Any(c => c.Id == card.Id))
                {
                    info.Game.DrawPile.Remove(info.Game.DrawPile.First(c => c.Id == card.Id));
                }
                info.Game.DiscardPile.Add(card);
            }
            await _cardService.PlayCard(info, playerId, card, parameters, this);
        }

        public async Task DiscardCard(GameStateInfo info, string playerId, Dictionary<string, string> parameters)
        {
            var cardId = int.Parse(parameters["cardid"]);
            var card = await _cardManager.GetByIdAsync(cardId);
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();

            // if card played with joker, it's not actually a card from draw pile or hand, and it doesn't need to be added to discard
            // similar when card is executed via the #metoo card and the tousensemble card
            // we brand these cards as 'ethereal'
            var ethereal = parameters.ContainsKey("ethereal") && parameters["ethereal"] == "true";
            if (!ethereal)
            {
                if (player.Cards.Any(c => c.Id == card.Id))
                {
                    player.Cards.Remove(player.Cards.First(c => c.Id == card.Id));
                }
                if (info.Game.DrawPile.Any(c => c.Id == card.Id))
                {
                    info.Game.DrawPile.Remove(info.Game.DrawPile.First(c => c.Id == card.Id));
                }
                info.Game.DiscardPile.Add(card);
            }
        }

        public void Shuffle(GameStateInfo info)
        {
            var cardsInGame = info.Game.DiscardPile;
            cardsInGame.AddRange(info.Game.DrawPile);
            info.Game.DiscardPile = new List<Card>();
            info.Game.DrawPile = new List<Card>();

            var rng = new Random(DateTime.Now.Millisecond);

            while (cardsInGame.Count > 0)
            {
                var cardIndex = rng.Next(0, cardsInGame.Count);
                info.Game.DrawPile.Add(cardsInGame[cardIndex]);
                cardsInGame.Remove(cardsInGame[cardIndex]);
            }
        }

        public List<GamePlayer> GetPlayersInClockOrder(GameStateInfo info, string playerId)
        {
            var currentPlayer = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var playerCount = info.Game.Players.Count;
            var orderPlayerIndex = info.Game.Players.IndexOf(currentPlayer);
            var playersInOrder = new List<GamePlayer>();

            for (var i = 0; i < playerCount; i++)
            {
                playersInOrder.Add(info.Game.Players[orderPlayerIndex]);

                orderPlayerIndex++;
                if (orderPlayerIndex == playerCount)
                {
                    orderPlayerIndex = 0;
                }
            }

            return playersInOrder;
        }

        public async Task<bool> IsInterrupted(GameStateInfo info, string playerId)
        {
            var key = info.Game.Id.ToString();
            TaskCompletionSource<bool> tcs;
            int interruptId;

            lock (_interruptLock)
            {
                if (!_interruptcounters.TryGetValue(key, out interruptId))
                {
                    interruptId = 0;
                }
                interruptId++;
                _interruptcounters[key] = interruptId;

                tcs = new TaskCompletionSource<bool>();
                _interruptResponses[key + "_" + interruptId.ToString()] = tcs;

                var newExpiration = DateTime.UtcNow.AddSeconds(info.Game.Options.ReactionTimeLimit);
                if (!_interruptExpirationTimes.TryGetValue(key, out var currentExpiration) || newExpiration > currentExpiration)
                {
                    _interruptExpirationTimes[key] = newExpiration;
                }
            }
            try
            {
                var remainingTime = _interruptExpirationTimes[key] - DateTime.UtcNow; ;
                while (remainingTime > TimeSpan.Zero)
                {
                    lock (_interruptLock)
                    {
                        remainingTime = _interruptExpirationTimes[key] - DateTime.UtcNow;
                        if (remainingTime <= TimeSpan.Zero)
                        {
                            return false;
                        }
                    }

                    var interval = TimeSpan.FromMilliseconds(100);
                    var delayTask = Task.Delay(interval);
                    var interruptTask = tcs.Task;

                    var completedTask = await Task.WhenAny(delayTask, interruptTask);
                    if (completedTask == interruptTask)
                    {

                        return interruptTask.Result;
                    }
                }

                return false;
            }
            finally
            {
                lock (_interruptLock)
                {
                    _interruptResponses.Remove(key + "_" + interruptId.ToString());
                    if (!_interruptResponses.Keys.Any(k => k.StartsWith(key)))
                    {
                        _interruptcounters.Remove(key);
                    }

                    _interruptExpirationTimes.Remove(key);
                }
            }
        }

        public void ReactToAction(int gameId, string playerId, bool interrupts)
        {
            var key = $"{gameId}_{playerId}";
            if (_interruptResponses.TryGetValue(key, out var tcs))
            {
                tcs.TrySetResult(interrupts);

            }
        }

        public bool AnyPlayerHasCards(GameStateInfo info)
        {
            return info.Game.Players.Any(player => player.Cards.Any());
        }


    }
}
