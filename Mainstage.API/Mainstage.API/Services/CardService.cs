using Microsoft.EntityFrameworkCore;
using Mainstage.API.Models;
using System;
using static System.Collections.Specialized.BitVector32;
using Mainstage.API.Data;
using System.Text;
using Mainstage.API.Managers;
using System.Runtime.CompilerServices;

namespace Mainstage.API.Services
{
    public class CardService
    {
        private readonly CardManager _cardManager;

        public CardService(CardManager cardManager)
        {
            _cardManager = cardManager;
        }

        public async Task PlayCard(GameStateInfo info, string playerId, Card card, Dictionary<string, string> parameters, GameLogicService gameLogicService)
        {
            switch (card.CardType)
            {
                case "allornothing":
                    await PlayAllOrNothing(info, playerId, gameLogicService);
                    break;
                case "attack":
                    await PlayAttack(info, playerId, parameters, gameLogicService);
                    break;
                case "bandwagon":
                    PlayBandWagon(info, playerId, parameters, gameLogicService);
                    break;
                case "collectiveroll":
                    PlayCollectiveRoll(info, playerId, gameLogicService, card);
                    break;
                case "everybodydraws":
                    await PlayEverybodyDraws(info, playerId, gameLogicService);
                    break;
                case "fatlady":
                    await PlayFatLady(info, playerId, gameLogicService, card);
                    break;
                case "joker":
                    PlayJoker(info, playerId, gameLogicService, parameters["jokercard"]);
                    break;
                case "losecards":
                    await PlayLoseCards(info, playerId, gameLogicService, card);
                    break;
                case "metoo":
                    PlayMeToo(info, playerId, gameLogicService, card);
                    break;
                case "move":
                    await PlayMove(info, playerId, gameLogicService, card, parameters);
                    break;
                case "moveroll":
                    await PlayMoveRoll(info, playerId, gameLogicService, card, parameters);
                    break;
                case "nope":
                    await PlayNope(info, playerId, gameLogicService, card);
                    break;
                case "ohjawel":
                    await PlayOhJawel(info, playerId, gameLogicService, card);
                    break;
                case "panne":
                    await PlayPanne(info, playerId, gameLogicService, card, parameters);
                    break;
                case "pass":
                    // No special action required, logic handled in GameLogicService Perform function
                    break;
                case "passcards":
                    await PlayPassCards(info, playerId, gameLogicService, card);
                    break;
                case "prcampaign":
                    await PlayPrCampaign(info, playerId, gameLogicService);
                    break;
                case "shuffle":
                    await PlayShuffle(info, playerId, gameLogicService);
                    break;
                case "skipturn":
                    await PlaySkipTurn(info, playerId, gameLogicService, card);
                    break;
                case "stealcard":
                    await PlayStealCard(info, playerId, gameLogicService, parameters);
                    break;
                case "switchplaces":
                    await PlaySwitchPlaces(info, playerId, gameLogicService, parameters);
                    break;
                case "teleport":
                    await PlayTeleport(info, playerId, gameLogicService, card, parameters);
                    break;
                case "tousensemble":
                    await PlayTousEnsemble(info, playerId, gameLogicService, parameters);
                    break;
                case "zalm":
                    await PlayZalm(info, playerId, gameLogicService);
                    break;

            }
        }

        public async Task PlayAllOrNothing(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            // Player teleports to main stage, where he has to roll, and if he fails, he goes back to Jeugdhuis stage, as handled in GameLogicService Perform method
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            player.ActiveEffects.Add("allornothing", "");
            gameLogicService.InsertInActionSequence(info, playerId, "teleport", "69");
            await gameLogicService.Teleport(info, playerId);
        }

        public async Task PlayAttack(GameStateInfo info, string playerId, Dictionary<string, string> parameters, GameLogicService gameLogicService)
        {
            // Player who rolled for a move must move backwards
            if (parameters.ContainsKey("targetid"))
            {
                var targetId = parameters["targetid"];
                gameLogicService.ReactToAction(info.Game.Id, targetId, true);

                var rollTurnAction = info.Game.Actions.FindLast(a => a.PlayerId == targetId && a.ActionType == "moveroll");
                if (rollTurnAction != null)
                {
                    gameLogicService.InsertInActionSequence(info, targetId, "movebackwards", rollTurnAction.Parameter);
                    await gameLogicService.ActionSequenceNext(info);
                }
            }
        }

        public void PlayBandWagon(GameStateInfo info, string playerId, Dictionary<string, string> parameters, GameLogicService gameLogicService)
        {
            // Player who plays this card may move an equal amount of tiles forward as the person who just rolled for a move
            if (parameters.ContainsKey("targetid"))
            {
                var targetId = parameters["targetid"];
                gameLogicService.ReactToAction(info.Game.Id, targetId, false);
                var rollTurnAction = info.Game.Actions.FindLast(a => a.PlayerId == targetId && a.ActionType == "moveroll");
                if (rollTurnAction != null)
                {
                    gameLogicService.InsertInActionSequence(info, playerId, "moveforwardbandwagon", rollTurnAction.Parameter);
                }
            }
        }

        public void PlayCollectiveRoll(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card)
        {
            // Setting up rolls for all player, then no other code executed => return to client
            for (var i = 0; i < info.Game.Players.Count; i++)
            {
                gameLogicService.InsertInActionSequence(info, info.Game.Players[i].PlayerId, "awaitingcollectiveroll", card.Id.ToString());
            }
        }

        public async Task ResolveCollectiveRoll(GameStateInfo info, string playerId, GameLogicService gameLogicService, int cardId)
        {
            var card = await _cardManager.GetByIdAsync(cardId);
            var playCardAction = info.Game.Actions.Where(a => a.ActionType == "playcard" && a.Parameter == card.Id.ToString()).Last();

            var rerollEntry = info.Game.Actions.Where(a => a.ActionType == "reroll" && a.ActionId > playCardAction.ActionId).Last();
            List<GameAction> collectiveRolls;
            if (rerollEntry != null)
            {
                collectiveRolls = info.Game.Actions.Where(a => a.ActionType == "collectiveroll" && a.ActionId > rerollEntry.ActionId).ToList();
            }
            else
            {
                collectiveRolls = info.Game.Actions.Where(a => a.ActionType == "collectiveroll" && a.ActionId > playCardAction.ActionId).ToList();
            }

            if (card.Parameter1 == "kakfans") // Player who drew the card moves backwards an amount equal to the sum of the rolls
            {
                var sum = 0;
                foreach (var roll in collectiveRolls)
                {
                    sum += int.Parse(roll.Parameter);
                }
                gameLogicService.InsertInActionSequence(info, playCardAction.PlayerId, "movebackwards", sum.ToString());

                var car = new ClientActionReport
                {
                    PlayerId = playCardAction.PlayerId,
                    Type = "resolvecollective",
                    EventMessage = $"Kakfans! {playCardAction.PlayerId} moet {sum.ToString()} vakjes terug."
                };
                info.ClientActionReportQueue.Add(car);

                await gameLogicService.ActionSequenceNext(info);
            }
            else
            {
                var significantRoll = 0;
                var targetActionType = "";
                if (card.Parameter1 == "battle") // Loser matters, moves backwards equal to his roll
                {
                    significantRoll = collectiveRolls.Min(a => int.Parse(a.Parameter));
                    targetActionType = "movebackwards";
                }
                else if (card.Parameter1 == "poll") // Winner matters, moves forward an amount equal to sum of rolls & skip stage
                {
                    significantRoll = collectiveRolls.Max(a => int.Parse(a.Parameter));
                    targetActionType = "moveforwardandskipstage";
                }
                else if (card.Parameter1 == "rockrally") // Winner matters, moves forward an amount equal to sum of ALL rolls, including the rolls before rerolls
                {
                    significantRoll = collectiveRolls.Max(a => int.Parse(a.Parameter));
                    targetActionType = "moveforward";
                }

                var equalPlayers = collectiveRolls.Where(a => int.Parse(a.Parameter) == significantRoll).ToList();

                if (equalPlayers.Count > 1)
                {
                    // Only these players roll again
                    gameLogicService.AddActionHistory(info, playCardAction.PlayerId, "reroll", "");

                    var car = new ClientActionReport
                    {
                        PlayerId = playCardAction.PlayerId,
                        Type = "awaitingcollectiveroll",
                        EventMessage = "Spelers "

                    };

                    foreach (var player in equalPlayers)
                    {
                        gameLogicService.InsertInActionSequence(info, player.PlayerId, "collectiveroll", card.Id.ToString());
                        car.EventMessage += player.PlayerId + ", ";
                    }
                    car.EventMessage.Remove(car.EventMessage.Length - 2);
                    car.EventMessage += " moeten opnieuw gooien!";
                    info.ClientActionReportQueue.Add(car);
                }
                else
                {
                    var eventMessageEnd = string.Empty;
                    var targetValue = string.Empty;
                    var sum = 0;
                    switch (card.Parameter1)
                    {
                        case "battle":
                            targetValue = equalPlayers.First().Parameter;
                            eventMessageEnd = $"moet {targetValue} vakjes terug!";
                            break;
                        case "poll":
                            foreach (var player in info.Game.Players)
                            {
                                var lastRollForPlayerEntry = info.Game.Actions.Where(a => a.PlayerId == player.PlayerId
                                                                                        && a.ActionType == "collectiveroll").Last();
                                sum += int.Parse(lastRollForPlayerEntry.Parameter);
                            }
                            targetValue = sum.ToString();
                            eventMessageEnd = $"mag {targetValue} vakjes vooruit, inclusief skip stage!";
                            break;
                        case "rockrally":
                            var allRollsSinceCardPlayed = info.Game.Actions.Where(a => a.ActionType == "collectiveroll"
                                                                                    && a.ActionId > playCardAction.ActionId).ToList();
                            foreach (var roll in allRollsSinceCardPlayed)
                            {
                                sum += int.Parse(roll.Parameter);
                            }
                            targetValue = sum.ToString();
                            eventMessageEnd = $"mag {targetValue} vakjes vooruit!";
                            break;
                    }

                    var car = new ClientActionReport
                    {
                        PlayerId = equalPlayers.First().PlayerId,
                        Type = "resolvecollective",
                        EventMessage = $"{equalPlayers.First().PlayerId} {eventMessageEnd}"
                    };
                    info.ClientActionReportQueue.Add(car);
                    gameLogicService.InsertInActionSequence(info, equalPlayers.First().PlayerId, targetActionType, targetValue);

                }
                await gameLogicService.ActionSequenceNext(info);
            }

        }

        public async Task PlayEverybodyDraws(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            // Cycle through players starting with the player who plays the card, everybody draws a card
            var playersInOrder = gameLogicService.GetPlayersInClockOrder(info, playerId);
            playersInOrder.Reverse();

            foreach (var player in playersInOrder)
            {
                gameLogicService.InsertInActionSequence(info, player.PlayerId, "drawcard", string.Empty);
            }

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayFatLady(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card)
        {
            // Either player who drew the card, or all players in case of 'mega fat lady', must lose all their cards and further actions, and return to tile 0
            if (card.Parameter1 == "self")
            {
                gameLogicService.InsertInActionSequence(info, playerId, "fatlady", string.Empty);
                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "fatlady",
                    EventMessage = $"Fat Lady! {playerId} verliest al zijn kaarten en gaat terug naar het repetitiekot!"
                };
                info.ClientActionReportQueue.Add(car);
                await gameLogicService.ActionSequenceNext(info);
            }
            else if (card.Parameter1 == "everyone")
            {
                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "megafatlady",
                    EventMessage = $"Mega fat lady! Iedereen verliest alle kaarten en gaat terug naar het repetitiekot!"
                };
                foreach (var player in info.Game.Players)
                {
                    gameLogicService.InsertInActionSequence(info, player.PlayerId, "fatlady", string.Empty);
                }
                await gameLogicService.ActionSequenceNext(info);
            }
        }

        public async Task ExecuteFatLady(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            if (player.Cards != null && player.Cards.Count > 0)
            {
                foreach (var card in player.Cards)
                {
                    info.Game.DiscardPile.Add(card);
                    player.Cards.Remove(card);
                }
            }

            var actionSequenceEntries = info.ActionSequence.Where(a => a.PlayerId == playerId);
            foreach (var entry in actionSequenceEntries)
            {
                info.ActionSequence.Remove(entry);
            }

            gameLogicService.AddActionHistory(info, playerId, "teleport", "0");
            await gameLogicService.Teleport(info, playerId, true); // Teleport with no further action on destination tile 0
        }

        public async void PlayJoker(GameStateInfo info, string playerId, GameLogicService gameLogicService, string jokerCard)
        {
            // Play any card (that is applicable in the situation, because this card is not a keeper)
            gameLogicService.AddActionHistory(info, playerId, "playjoker", "");
            gameLogicService.InsertInActionSequence(info, playerId, "drawetherealcard", jokerCard);
        }

        public async Task PlayLoseCards(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card)
        {
            // Either player who drew the card loses all cards, or all players

            if (card.Parameter1 == "self")
            {
                gameLogicService.InsertInActionSequence(info, playerId, "losecards", string.Empty);
            }
            else if (card.Parameter1 == "everyone")
            {
                foreach (var player in info.Game.Players)
                {
                    gameLogicService.InsertInActionSequence(info, player.PlayerId, "losecards", string.Empty);
                }
            }

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task ExecuteLoseCards(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            if (player.Cards != null && player.Cards.Count > 0)
            {
                foreach (var card in player.Cards)
                {
                    info.Game.DiscardPile.Add(card);
                    player.Cards.Remove(card);
                }

                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "losecards",
                    EventMessage = $"{playerId} verliest al zijn kaarten!"
                };
                info.ClientActionReportQueue.Add(car);
            }

            await gameLogicService.ActionSequenceNext(info);
        }

        public void PlayMeToo(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card)
        {
            // Copy card that was just played by someone else and execute after the copied player's actions

            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var cardToCopyEntry = info.Game.Actions.Where(t => t.PlayerId != player.PlayerId && t.Parameter == "playcard").Last();

            gameLogicService.ReactToAction(info.Game.Id, cardToCopyEntry.PlayerId, false);

            gameLogicService.InsertInActionSequence(info, playerId, "drawetherealcard", cardToCopyEntry.Parameter);
        }

        public async Task PlayMove(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card, Dictionary<string, string> parameters) // All cards that move a player
        {
            var currentPlayer = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            switch (card.Parameter1) // type of move card
            {
                case "anyone":
                case "opponent":
                case "self":
                    var moveAmount = card.Parameter2;
                    if (moveAmount == "choice")
                    {
                        moveAmount = parameters["moveamount"];
                    }

                    var moveType = "forward";
                    if (int.Parse(moveAmount) < 0)
                    {
                        moveType = "backwards";
                        moveAmount = Math.Abs(int.Parse(moveAmount)).ToString();
                    }

                    var targetPlayerId = card.Parameter1 == "self"
                        ? currentPlayer.PlayerId
                        : parameters["targetid"];

                    gameLogicService.InsertInActionSequence(info, targetPlayerId, "move" + moveType, moveAmount);
                    break;

                case "everyone":
                    var players = gameLogicService.GetPlayersInClockOrder(info, currentPlayer.PlayerId);
                    players.Reverse();
                    foreach (var player in players)
                    {
                        gameLogicService.InsertInActionSequence(info, player.PlayerId,
                            "move" + (int.Parse(card.Parameter2) > 0 ? "forward" : "backwards"),
                            Math.Abs(int.Parse(card.Parameter2)).ToString());
                    }
                    break;

                case "self opponent":
                    var amount = Math.Abs(int.Parse(card.Parameter2)).ToString();
                    var type = "move" + (int.Parse(card.Parameter2) > 0 ? "forward" : "backwards");
                    var opponentId = parameters["targetid"];
                    gameLogicService.InsertInActionSequence(info, opponentId, type, amount);
                    gameLogicService.InsertInActionSequence(info, currentPlayer.PlayerId, type, amount);
                    break;
                case "self1opponent2":
                case "self1opponent2 skipstage":
                    var targetId = string.Empty;
                    var moveDistance = 0;
                    var skipStage = card.Parameter1.Contains("skipstage");
                    if (parameters["movetarget"] == "self")
                    {
                        targetId = currentPlayer.PlayerId;
                        moveDistance = int.Parse(card.Parameter3);
                    }
                    else
                    {
                        targetId = parameters["targetid"];
                        moveDistance = int.Parse(card.Parameter4);
                    }

                    gameLogicService.InsertInActionSequence(info, targetId,
                      "move" + (moveDistance > 0 ? "forward" + (skipStage ? "andskipstage" : "") : "backwards"), moveDistance.ToString());
                    break;
            }

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayMoveRoll(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card, Dictionary<string, string> parameters) // Cards that make you roll for a move
        {
            var targetId = string.Empty;
            var direction = card.Parameter2;
            if (card.Parameter1 == "opponent")
            {
                targetId = parameters["targetid"];
            }
            else if (card.Parameter1 == "self")
            {
                targetId = playerId;
            }

            var directionString = direction == "+" ? "vooruit" : "achteruit";
            var car = new ClientActionReport
            {
                PlayerId = targetId,
                EventMessage = $"{targetId} moet gooien om {directionString} te gaan.",
                Type = "awaitingmoveroll"
            };
            info.ClientActionReportQueue.Add(car);
        }

        public async Task PlayNope(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card) // Cancel last played card
        {
            var lastPlayedCardEntry = info.Game.Actions
                .Where(a => a.ActionType == "playcard" && a.Parameter != card.Id.ToString()).Last();
            var targetCard = await _cardManager.GetByIdAsync(int.Parse(lastPlayedCardEntry.Parameter));
            if (targetCard.CardType != "nope")
            {
                gameLogicService.ReactToAction(info.Game.Id, lastPlayedCardEntry.PlayerId, true);
                gameLogicService.AddActionHistory(info, "noped", playerId, lastPlayedCardEntry.Parameter);

                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "nope",
                    EventMessage = $"{playerId} speelde een nope kaart!"
                };
                info.ClientActionReportQueue.Add(car);

                await gameLogicService.ActionSequenceNext(info);
            }
        }

        public async Task PlayOhJawel(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card) // Cancel last cancellation of a card
        {
            var lastPlayedCardEntry = info.Game.Actions
                .Where(a => a.ActionType == "playcard" && a.Parameter != card.Id.ToString()).Last();
            var targetCard = await _cardManager.GetByIdAsync(int.Parse(lastPlayedCardEntry.Parameter));
            if (targetCard.CardType == "nope")
            {
                gameLogicService.ReactToAction(info.Game.Id, lastPlayedCardEntry.PlayerId, true);
                gameLogicService.AddActionHistory(info, "noped", playerId, lastPlayedCardEntry.Parameter);

                var car = new ClientActionReport
                {
                    PlayerId = playerId,
                    Type = "ohjawel",
                    EventMessage = $"{playerId} speelde een oh jawel kaart!"
                };
                info.ClientActionReportQueue.Add(car);

                await gameLogicService.ActionSequenceNext(info);
            }
            
        }

        public async Task PlayPanne(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card, Dictionary<string, string> parameters) // Player skips turns until 6 rolled or someone passes them
        {
            var targetPlayerId = string.Empty;
            if (card.Parameter1 == "opponent")
            {
                targetPlayerId = parameters["targetid"];
            }
            else if (card.Parameter1 == "self")
            {
                targetPlayerId = playerId;
            }

            var targetPlayer = info.Game.Players.Where(p => p.PlayerId == targetPlayerId).First();
            targetPlayer.TurnStartMode = "panne";

            gameLogicService.AddActionHistory(info, targetPlayerId, "panne", "");

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayPassCards(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card) // Passing held cards
        {
            if (card.Parameter1 == "everyone") // Everyone passes their cards clockwise
            {
                var toReceiveCards = new List<List<Card>>();
                for (var i = 0; i < info.Game.Players.Count; i++)
                {
                    var currentPlayer = info.Game.Players[i];
                    if (currentPlayer.Cards == null || currentPlayer.Cards.Count == 0)
                    {
                        toReceiveCards.Add(new List<Card>());
                    }
                    else
                    {
                        toReceiveCards.Add(currentPlayer.Cards);
                    }
                }

                // Change card order and redistribute
                var lastCards = toReceiveCards.Last();
                toReceiveCards.Remove(lastCards);
                toReceiveCards.Insert(0, lastCards);

                for (var i = 0; i < info.Game.Players.Count; i++)
                {
                    var currentPlayer = info.Game.Players[i];
                    currentPlayer.Cards = toReceiveCards[i];
                }
            }
            else if (card.Parameter1 == "self") // Player divides his cards among players clockwise
            {
                var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
                var nextPlayerIndex = info.Game.Players.IndexOf(info.Game.Players.Where(p => p.PlayerId == player.PlayerId).First()) + 1;
                var nextPlayer = new GamePlayer();

                if (player.Cards != null)
                {
                    foreach (var c in player.Cards)
                    {
                        player.Cards.Remove(c);
                        if (nextPlayerIndex == info.Game.Players.Count) nextPlayerIndex = 0;
                        nextPlayer = info.Game.Players[nextPlayerIndex];
                        if (nextPlayer.Cards == null) nextPlayer.Cards = new List<Card>();
                        nextPlayer.Cards.Add(c);
                        nextPlayerIndex++;
                    }
                }
            }

            gameLogicService.AddActionHistory(info, playerId, "passedcards", card.Parameter1);
            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayPrCampaign(GameStateInfo info, string playerId, GameLogicService gameLogicService) // Move again equal to last roll
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var lastRoll = info.Game.Actions.Where(t => t.PlayerId == player.PlayerId && t.ActionType == "moveroll").Last();
            gameLogicService.InsertInActionSequence(info, player.PlayerId, "moveforward", lastRoll.Parameter);

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayShuffle(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            gameLogicService.Shuffle(info);
            gameLogicService.AddActionHistory(info, playerId, "shuffledeck", "");
            await gameLogicService.ActionSequenceNext(info);
        } // Shuffle discard into drawpile

        public async Task PlaySkipTurn(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            player.TurnStartMode = "skipturn " + card.Parameter2;
            // Parameter2: Amount of turns to skip
            gameLogicService.AddActionHistory(info, player.PlayerId, "skipturn", card.Parameter2);
            await gameLogicService.ActionSequenceNext(info);
            // Keeping track of turn losses in GameLogicService EndTurn method
        } // Player must skip 1 or 2 turns depending on card

        public async Task PlayStealCard(GameStateInfo info, string playerId, GameLogicService gameLogicService, Dictionary<string, string> parameters)
        {
            var targetPlayer = info.Game.Players.Where(p => p.PlayerId == parameters["targetid"]).First();
            var targetCard = targetPlayer.Cards
                .Where(c => c.Id == int.Parse(parameters["targetcardid"])).First();
            var currentPlayer = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            currentPlayer.Cards.Add(targetCard);
            targetPlayer.Cards.Remove(targetCard);
            gameLogicService.AddActionHistory(info, playerId, "cardstolen", targetPlayer.PlayerId + " " + targetCard.Id.ToString());
            await gameLogicService.ActionSequenceNext(info);
        } // Steal a card

        public async Task PlaySwitchPlaces(GameStateInfo info, string playerId, GameLogicService gameLogicService, Dictionary<string, string> parameters)
        {
            var targetPlayer = info.Game.Players.Where(p => p.PlayerId == parameters["targetid"]).First();
            var currentPlayer = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var currentPosition = currentPlayer.Position.ToString();
            var targetPosition = targetPlayer.Position.ToString();

            gameLogicService.InsertInActionSequence(info, targetPlayer.PlayerId, "teleport", currentPosition);
            gameLogicService.InsertInActionSequence(info, currentPlayer.PlayerId, "teleport", targetPosition);

            targetPlayer.Position = int.Parse(currentPosition);
            currentPlayer.Position = int.Parse(targetPosition); // Already adjust position to prevent players from doing battle when teleported
            await gameLogicService.ActionSequenceNext(info);
        } // Switch places with opponent

        public async Task PlayTeleport(GameStateInfo info, string playerId, GameLogicService gameLogicService, Card card, Dictionary<string, string> parameters) // Teleport to target tile
        {
            var affectedPlayers = new List<GamePlayer>();
            // Parameter1 = type
            if (card.Parameter1 == "everyone")
            {
                affectedPlayers = info.Game.Players;
            }
            else if (card.Parameter1.Contains("opponent"))
            {
                affectedPlayers.Add(info.Game.Players.Where(p => p.PlayerId == parameters["targetid"]).First());
            }
            else if (card.Parameter1 == "self")
            {
                affectedPlayers.Add(info.Game.Players.Where(p => p.PlayerId == playerId).First());
            }

            foreach (var player in affectedPlayers)
            {
                // Parameter2 = destination
                if (card.Parameter2 == "previousstage")
                {
                    var stageTile = info.Game.Tiles.OrderBy(t => t.Id).Where(t => t.Id < player.Position && t.IsStage).LastOrDefault();
                    if (stageTile != null)
                    {
                        gameLogicService.InsertInActionSequence(info, player.PlayerId, "teleport", stageTile.Id.ToString());
                    }
                }
                else if (card.Parameter2 == "nextstage")
                {
                    var stageTile = info.Game.Tiles.OrderBy(t => t.Id).Where(t => t.Id > player.Position && t.IsStage).First();
                    if (stageTile != null)
                    {
                        gameLogicService.InsertInActionSequence(info, player.PlayerId, "teleport", stageTile.Id.ToString());
                    }
                }
                else if (card.Parameter2 == "jeugdhuis")
                {
                    var stageTile = info.Game.Tiles.Where(t => t.Stage == 1).First();
                    if (stageTile != null)
                    {
                        gameLogicService.InsertInActionSequence(info, player.PlayerId, "teleport", stageTile.Id.ToString());
                    }
                }
                else
                {
                    gameLogicService.InsertInActionSequence(info, player.PlayerId, "teleport", card.Parameter2);
                }
            }

            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayTousEnsemble(GameStateInfo info, string playerId, GameLogicService gameLogicService, Dictionary<string, string> parameters) // Kies een tegenstander die hetzelfde moet doen als opdracht van laatst getrokken kaart
        {
            var lastPlayedCardEntry = info.Game.Actions.Where(t => t.ActionType == "playcard" && t.Parameter != "74").Last(); // 74 - Id of Tous ensemble card
            gameLogicService.InsertInActionSequence(info, parameters["targetid"], "drawetherealcard", lastPlayedCardEntry.Parameter);
            await gameLogicService.ActionSequenceNext(info);
        }

        public async Task PlayZalm(GameStateInfo info, string playerId, GameLogicService gameLogicService)
        {
            var player = info.Game.Players.Where(p => p.PlayerId == playerId).First();
            var tile = info.Game.Tiles.Where(t => t.Id == player.Position).First();
            if (tile.ArrowSource != 0)
            {
                gameLogicService.InsertInActionSequence(info, playerId, "zalmtravel", tile.ArrowSource.ToString());

                await gameLogicService.ActionSequenceNext(info);
            }
        }

    }
}
