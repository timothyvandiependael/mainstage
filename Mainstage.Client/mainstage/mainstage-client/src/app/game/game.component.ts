import { Component, ElementRef, OnInit, ViewChild, AfterViewInit, ViewChildren, QueryList, HostListener } from '@angular/core';
import { GameService } from '../services/game.service';
import { GameHubService } from '../services/game-hub.service';
import { DrawService } from '../services/draw.service';
import { NgFor, NgIf, NgClass, NgStyle } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { Subscription } from 'rxjs';
import { first  } from 'rxjs';
import { CardService } from '../services/card.service';
import { ActionPopupComponent, ActionPopupData } from '../action-popup/action-popup.component';

@Component({
  selector: 'app-game',
  imports: [NgFor, NgIf, NgClass, ActionPopupComponent, NgStyle ],
  templateUrl: './game.component.html',
  styleUrl: './game.component.css'
})
export class GameComponent {
  @ViewChild('gameCanvas', { static: true }) gameCanvas!: ElementRef;
  private ctx!: CanvasRenderingContext2D;
  private tileSize: number = 35;
  game: any;
  tiles: any[] = [];
  userId: string = '';
  userIndex: number = 0;
  hasTurn: boolean = false;
  turnPlayerId: string = '';
  gameStateInfo: any = {};
  currentRollType: string = 'perform';

  eventTextQueue: string[] = [];
  showCardButtons: boolean = false;
  showStashButton: boolean = false;

  actionPopupData: ActionPopupData | null = null;
  actionPopupQueue: ActionPopupData[] = [];

  currentSelectedCard: any = null;
  currentSelectedCardParameters: any = {};
  cardText: string = '';
  aboutToPlayEtherealCard: boolean = false;

  testMode: boolean = true;

  gamePaused: boolean = true;

  playerColors: any[] = [
    'blue',
    'red',
    'green',
    'black'
  ];

  @ViewChildren('diceCanvas') diceCanvases!: QueryList<ElementRef<HTMLCanvasElement>>;

  private diceSpritesheet = new Image();
  private frameSize = 46;
  private totalFrames = 115;
  private rolling: boolean[] = [];
  private rollEnabled: boolean[] = [];
  private finalNumbers: number[] = [];
  private finalNumberFrames: number[] = [49, 53, 113, 0, 61, 57];

  private validFrames: { row: number; col: number }[] = [];

  private onDieRollSub?: Subscription;
  private onGameStartDieRollsProcessedSub?: Subscription;
  private onPlayerActionProcessedSub?: Subscription;
  private giveInterruptchanceSub?: Subscription;
  private showCardToEveryoneSub?: Subscription;
  private getGameFromServerSub?: Subscription;
  private isEveryoneConnectedSub?: Subscription;

  constructor(
    private gameService: GameService,
    private gameHubService: GameHubService,
    private drawService: DrawService,
    private authService: AuthService,
    private cardService: CardService
  ) {
  }

  @HostListener('window:keydown', ['$event'])
  handleKeyboardEvent(event: KeyboardEvent) {
    const isChatInput = (event.target as HTMLElement)?.tagName === 'INPUT';

    if (isChatInput) return;
    if (this.gamePaused) return;

    if (event.key === 'r' || event.key === 'R') {
      this.rollDice(this.userIndex, true);
    }
  }

  ngOnDestroy() {
    this.onDieRollSub?.unsubscribe();
    this.onGameStartDieRollsProcessedSub?.unsubscribe();
    this.onPlayerActionProcessedSub?.unsubscribe();
    this.giveInterruptchanceSub?.unsubscribe();
    this.showCardToEveryoneSub?.unsubscribe();
    this.getGameFromServerSub?.unsubscribe();
    this.isEveryoneConnectedSub?.unsubscribe();
  }

  ngOnInit() {
    this.drawService.playerColors = this.playerColors;

    this.game = this.gameService.getCurrentGame();

    var userId = this.authService.getUserId();
    if (userId) {
      this.userId = userId;
    }

    this.getGameFromServerSub?.unsubscribe();
    this.getGameFromServerSub = this.gameService.getGameFromServer(this.userId, this.game).subscribe({
      next: (data) => {
        this.game = data;

        this.initAfterLoadingGame();
      },
      error: (err) => {
        console.error('Failed to load game from server: ', err);
      }
    })
  }

  initDice() {
    this.diceSpritesheet.src = 'assets/dice.png';
    this.generateValidFrames();
    this.diceSpritesheet.onload = () => {
      console.log('spritesheet loaded');
      this.drawAllDice();
    }
  }

  initAfterLoadingGame() {
    this.userIndex = this.game.players.findIndex((p: any) => p.playerId === this.userId);
    this.initDice();
    this.gameHubService.startConnection(() => {
      this.initializeIsEveryoneConnected();
      this.initializeOnDieRoll();
      this.initializeOnGameStartDieRollProcessed();
      this.initializeOnPlayerActionProcessed();
      this.initializeShowCardsToEveryone();
      this.initializeGiveInterruptChance();

      this.gameHubService.addToGroup(this.game.id);

      if (this.game.state == "started") {
        this.eventTextQueue.push('Rol om te beslissen wie begint.');
        this.game.players.forEach((p: any, index: number) => {
          this.rollEnabled[index] = true;
        });
      }
      this.initializeGameBoard();
    });
  }

  initializeIsEveryoneConnected() {
    this.isEveryoneConnectedSub?.unsubscribe();
    this.isEveryoneConnectedSub = this.gameHubService.isEveryoneConnected().subscribe((data) => {
      if (data != null) {
        this.checkPauseCondition(data);
      }
    });
  }

  checkPauseCondition(everyoneConnected: boolean) {
    if (!everyoneConnected) {
      this.pauseGame();
    }
    else {
      this.resumeGame();
    }
  }

  pauseGame() {
    this.gamePaused = true;
  }

  resumeGame() {
    this.gamePaused = false;
  }

  initializeOnDieRoll() {
    this.onDieRollSub?.unsubscribe();
    this.onDieRollSub = this.gameHubService.onDieroll().subscribe((data) => {
      if (data) {
        this.showDiceRoll(data.playerId, data.roll, (playerId, roll) => {
          var testRoll = 0;
          if (testRoll > 0) roll = testRoll;
          if (data.playerId == this.userId) {
            if (this.game.state == "started") {
              this.gameHubService.processGameStartDieRoll(this.game.id, playerId, roll);
            }

            if (this.game.state == "ongoing") {
              var parameters = { "roll": roll.toString() };
              this.gameStateInfo.game = this.game;
              this.gameHubService.processPlayerAction(this.gameStateInfo, this.currentRollType, parameters);
            }
          }
        });
      }
    });
  }

  initializeOnGameStartDieRollProcessed() {
    this.onGameStartDieRollsProcessedSub?.unsubscribe();
    this.onGameStartDieRollsProcessedSub = this.gameHubService.onGameStartDieRollsProcessed().subscribe((model) => {
      if (model) {
        this.game = model.game;
        this.diceCanvases.changes.pipe(first()).subscribe(() => {
          this.drawAllDice();
        });

        this.eventTextQueue.push(model.eventMessage);
        this.gameStateInfo = model;

        if (model.actionSequence && model.actionSequence.length > 0) {

          var rerollActions = model.actionSequence.filter((a: any) => a.actionType == 'gamestartreroll');
          if (rerollActions.length > 0) {
            rerollActions.forEach((a: any, i: number) => {
              if (a.actionType == 'gamestartreroll' && a.playerId == this.userId) {
                this.rollEnabled[this.userIndex] = true;
                this.game.actions.push(a);
              }

            });
          }
          else {
            var startTurnActions = model.actionSequence.filter((a: any) => a.actionType == "awaitingperformroll");
            if (startTurnActions.length > 0) {
              this.turnPlayerId = startTurnActions[0].playerId;
              this.currentRollType = 'perform';
              if (this.turnPlayerId == this.userId) {
                this.hasTurn = true;
                this.rollEnabled[this.userIndex] = true;
              }
            }
          }
        }
      }
    })
  }

  initializeOnPlayerActionProcessed() {
    this.onPlayerActionProcessedSub?.unsubscribe();
    this.onPlayerActionProcessedSub = this.gameHubService.onPlayerActionProcessed().subscribe(async (data: any) => {
      if (data) {
        this.gameStateInfo = data;
        this.game = this.gameStateInfo.game;
        this.diceCanvases.changes.pipe(first()).subscribe(() => {
          this.drawAllDice();
        });

        if (data.clientActionReportQueue && data.clientActionReportQueue.length > 0) {
          for (const car of data.clientActionReportQueue) {
            await this.processClientActionQueueEntry(car)
          }
          /*data.clientActionReportQueue.forEach((car: any, index: number) => {
            this.processClientActionQueueEntry(car, index);
          });*/

          data.clientActionReportQueue = [];
        }
      }
    });
  }

  initializeShowCardsToEveryone() {
    this.showCardToEveryoneSub?.unsubscribe();
    this.showCardToEveryoneSub = this.gameHubService.showCardToEveryone().subscribe((data: any) => {
      if (data) {
        this.showCardButtons = false;
        this.showStashButton = false;
        var showCardString = data.card.name.toUpperCase() + ': ' + data.card.description;
        if (data.jokerCard && data.jokerCards != '') {
          showCardString += " : Gekozen kaart: " + data.jokerCard;
        }
        this.showCard(showCardString, true);
      }
    });
  }

  initializeGiveInterruptChance() {
    this.giveInterruptchanceSub?.unsubscribe();
    this.giveInterruptchanceSub = this.gameHubService.giveInterruptChance().subscribe((data: any) => {
      if (data) {
        // TODO : player cards that are applicable will get highlighted for easy playing?
        // For example nope cards can not be played on other nope cards, oh jawel can only be played on nope, bandwagon can only be played on a move etc
      }
    });
  }

  activateRollIfCurrentUser(playerId: string, rollType: string) {
    if (playerId == this.userId) {
      this.hasTurn = true;
      this.rollEnabled[this.userIndex] = true;
      this.currentRollType = rollType;
    }
  }

  async processClientActionQueueEntry(entry: any) {
    if (entry.eventMessage)
      this.eventTextQueue.push(entry.eventMessage);

    if (entry.type == "startturn" || entry.type == "awaitingmoveroll") {
      this.activateRollIfCurrentUser(entry.playerId, 'move');
    }
    else if (entry.type == "awaitingperformroll") {
      this.activateRollIfCurrentUser(entry.playerId, 'perform');
    }
    else if (entry.type == "awaitingbattleroll") {
      var battleEntries = this.gameStateInfo.actionSequence.filter((a: any) => a.actionType == 'awaitingbattleroll');
      battleEntries.forEach((b: any) => {
        this.activateRollIfCurrentUser(b.playerId, 'battle');
      });
    }
    else if (entry.type == "awaitingcollectiveroll") {
      var collectiveEntries = this.gameStateInfo.actionSequence.filter((a: any) => a.actionType == 'awaitingcollectiveroll');
      collectiveEntries.forEach((c: any) => {
        this.activateRollIfCurrentUser(c.playerId, 'collective');
      })
    }
    else if (entry.type == "moveforward") {
      var moveroll = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == 'moveroll').parameter);
      var start = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == "starttile").parameter);
      var destination = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == 'movetotile').parameter);
      var playerIndex = this.game.players.findIndex((p: any) => p.playerId == entry.playerId);
      await this.drawService.movePawnForward(this.ctx, playerIndex, start, destination, this.tileSize, this.game.tiles, this.game.players);
    }
    else if (entry.type == "movebackward") {
      var moveroll = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == 'moveroll').parameter);
      var start = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == "starttile").parameter);
      var destination = parseInt(this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == 'movetotile').parameter);
      var playerIndex = this.game.players.findIndex((p: any) => p.playerId == entry.playerId);
      await this.drawService.movePawnBackward(this.ctx, playerIndex, start, destination, this.tileSize, this.game.tiles, this.game.players);
    }
    else if (entry.type == "performfail") {
      // No action for now
    }
    else if (entry.type == "performpass0") {
      this.activateRollIfCurrentUser(entry.playerId, "move");
    }
    else if (entry.type == "performpass") {
      // TODO
    }
    else if (entry.type == "performfailallornothing") {

    }
    else if (entry.type == "teleport") {
      var teleportAction = this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == "teleport");
      var destination = parseInt(teleportAction.parameter);
      await this.drawService.teleportPawn(this.ctx, playerIndex, destination, this.tileSize, this.game.tiles, this.game.players);
    }
    else if (entry.type == "carddrawn") {
      debugger;
      if (entry.playerId == this.userId) {
        var cardDrawnAction = this.game.actions.findLast((a: any) => a.playerId == entry.playerId && a.actionType == "carddrawn");
        var card = this.game.drawPile.find((c: any) => c.id == parseInt(cardDrawnAction.parameter));

        this.showCardButtons = true;
        if (card.isKeeper)
          this.showStashButton = true;
        this.currentSelectedCard = card;
        this.showCard(card.name.toUpperCase() + ': ' + card.description, false);
      }
    }
    else if (entry.type == "etherealcarddrawn") {
      if (entry.playerId == this.userId) {
        var card = this.gameStateInfo.lastEtherealCard;

        this.showCardButtons = true;
        this.showStashButton = false;
        this.currentSelectedCard = card;
        this.showCard(card.name.toUpperCase() + ': ' + card.description, false);
        this.aboutToPlayEtherealCard = true;
      }
    }
    else if (entry.type == "fatlady") {
      var playerIndex = this.game.players.findIndex((p: any) => p.playerId === entry.playerId);
      await this.drawService.teleportPawn(this.ctx, playerIndex, 0, this.tileSize, this.game.tiles, this.game.players);

      // TODO : reflect card loss on UI
    }
    else if (entry.type == "megafatlady") {
      this.game.players.forEach((p: any, index: number) => {
        this.drawService.teleportPawn(this.ctx, index, 0, this.tileSize, this.game.tiles, this.game.players);
      })

      // TODO: reflect card loss visualization
    }
    else if (entry.type == "losecards") {
      // TODO: reflect card loss visualization
    }
    else if (entry.type == "passcards") {
      // TODO: visualization of the passing of cards
    }
  }

  showCard(cardText: string, hasTimeout: boolean) {
    this.cardText = cardText;
    const popup = document.getElementById('cardPopup');

    if (popup) {
      popup.classList.add('visible');

      if (hasTimeout) {
        setTimeout(() => {
          popup.classList.remove('visible');
        }, 1700);
      }
    }
  }

  hideCard() {
    const popup = document.getElementById('cardPopup');
    if (popup)
      popup.classList.remove('visible');
    this.showCardButtons = false;
    this.showStashButton = false;
  }

  playCard() {
    var card = this.currentSelectedCard;
    this.actionPopupQueue = [];
    this.currentSelectedCardParameters = {};
    if (this.aboutToPlayEtherealCard) {
      this.currentSelectedCardParameters['ethereal'] = 'true';
      this.aboutToPlayEtherealCard = false;
    }
    this.currentSelectedCardParameters['cardid'] = card.id.toString();

    switch (card.cardType) {
      case 'attack':
      case 'bandwagon':
        var targetEntry = this.game.actions.findLast((a: any) => a.actionType == 'moveroll');
        if (targetEntry) {
          this.currentSelectedCardParameters['targetid'] = targetEntry.playerId;
          this.hideCard();
          this.sendPlayCard();
        }
        break;
      case 'joker':
        this.addToPopupActionQueue('joker', '');
        this.processNextPopupAction();
        break;
      case 'move':
        if (card.parameter1 != 'self' && card.parameter1 != 'everyone') {
          if (card.parameter1 == 'self1opponent2' || card.parameter1 == 'self1opponent2 skipstage') {
            this.addToPopupActionQueue('self1opponent2choice', 'jij ' + card.parameter3, 'tegenstander ' + card.parameter4);
          }
          else {
            this.addToPopupActionQueue('target', card.parameter1);
            if (card.parameter2 == 'choice' && card.parameter1 == 'anyone') {
              this.addToPopupActionQueue('targetmovechoice', card.parameter3, card.parameter4)
            }
          }

          this.processNextPopupAction();
        }
        else {
          this.sendPlayCard();
        }
        break;
      case 'moveroll':
        if (card.parameter1 == 'opponent') {
          this.addToPopupActionQueue('target', card.parameter1);
          this.processNextPopupAction();
        }
        else {
          this.sendPlayCard();
        }
        break;
      case 'stealcard':
        var playersWithCards = this.game.players.filter((p: any) => p.cards.length > 0);
        if (playersWithCards.length == 0) {
          this.currentSelectedCardParameters['targetid'] == 'nobody';
        }
        else {
          this.addToPopupActionQueue('target', 'opponent');
          this.addToPopupActionQueue('stealcard', '');
          this.processNextPopupAction();
        }
        break;
      case 'switchplaces':
        this.addToPopupActionQueue('target', 'opponent');
        this.processNextPopupAction();
        break;
      case 'teleport':
        if (card.parameter1 == 'opponent youroll') {
          this.addToPopupActionQueue('target', 'opponent');
          this.processNextPopupAction();
        }
        else {
          this.sendPlayCard();
        }
        break;
      case 'panne':
        if (card.parameter1 == 'opponent') {
          this.addToPopupActionQueue('target', card.parameter1);
          this.processNextPopupAction();
        }
        break;
      case 'tousensemble':
        this.addToPopupActionQueue('target', 'opponent');
        this.processNextPopupAction();
        break;
      default:
        this.sendPlayCard();
        break;
    }
  }

  addToPopupActionQueue(type: string, value: string, value2: string = '') {
    var options: any[] = [];
    var description: string = '';

    if (type == 'target') {
      description = 'Kies een speler.';
      if (value == 'anyone') {
        options = this.game.players.map((p: any) => p.playerId);
      }
      else if (value == 'opponent') {
        options = this.game.players.filter((p: any) => p.playerId != this.userId).map((p: any) => p.playerId);
      }
    }
    else if (type == 'stealcard') {
      var playerId = this.currentSelectedCardParameters['targetid'];
      description = 'Kies een kaart om te stelen van speler ' + playerId;
      var targetPlayer = this.game.players.filter((p: any) => p.playerId == playerId);
      var cardCount = targetPlayer.cards.length;
      for (var i = 1; i <= cardCount; i++) {
        options.push(i.toString());
      }
    }
    else if (type == 'joker') {
      description = 'Kies een kaart om te spelen.';
      options = this.gameStateInfo.jokerCardList.map((c: any) => c.name);
    }
    else if (type == 'targetmovechoice') {
      description = 'Kies een optie, doelwit moet dit aantal vakjes verzetten.';
      options.push(value);
      options.push(value2);
    }
    else if (type == 'self1opponent2choice') {
      description = 'Kies een optie';
      options.push(value);
      options.push(value2);
    }

    this.actionPopupQueue.push({
      type: type,
      value: value,
      options: options,
      description: description
    });
  }

  processNextPopupAction() {
    if (this.actionPopupQueue.length > 0) {
      this.actionPopupData = this.actionPopupQueue.shift() || null;
    }
    else {
      this.actionPopupData = null;
      this.sendPlayCard();
    }
  }

  handleActionChoice(choice: any) {
    if (choice !== null) {
      if (this.actionPopupData) {
        if (this.actionPopupData.type == 'target') {
          this.currentSelectedCardParameters['targetid'] = choice;
        }
        else if (this.actionPopupData.type == 'stealcard') {
          var playerId = this.currentSelectedCardParameters['targetid'];
          var targetPlayer = this.game.players.filter((p: any) => p.playerId == playerId);
          this.currentSelectedCardParameters['targetcardid'] = targetPlayer.cards[parseInt(choice) - 1].id;
        }
        else if (this.actionPopupData.type == 'joker') {
          this.currentSelectedCardParameters['jokercard'] = choice;
        }
        else if (this.actionPopupData.type == 'targetmovechoice') {
          this.currentSelectedCardParameters['moveamount'] = choice;
        }
        else if (this.actionPopupData.type == 'self1opponent2choice') {
          if (this.actionPopupData.options) {
            if (choice == this.actionPopupData.options[0]) {
              this.currentSelectedCardParameters['movetarget'] = 'self';
              this.currentSelectedCardParameters['moveamount'] = this.currentSelectedCard.parameter3;
            }
            else {
              this.currentSelectedCardParameters['movetarget'] = 'opponent';
              this.currentSelectedCardParameters['moveamount'] = this.currentSelectedCard.parameter4;
              this.addToPopupActionQueue('target', 'opponent');
            }
          }

        }
      }
      this.processNextPopupAction();
    }
  }

  sendPlayCard() {
    this.hideCard();
    var parameters = { ...this.currentSelectedCardParameters };
    this.gameHubService.processPlayerAction(this.gameStateInfo, "playcard", parameters);
  }

  stashCard() {
    this.hideCard();
    this.gameHubService.processPlayerAction(this.gameStateInfo, "stashcard", { "cardid": this.currentSelectedCard.id });
  }

  ngAfterViewInit() {
    this.diceCanvases.forEach((canvasRef, index) => {
      const dctx = canvasRef.nativeElement.getContext('2d');
      this.rolling[index] = false;
      this.finalNumbers[index] = 1;
    })
  }

  generateValidFrames() {
    this.validFrames.push({ row: 0, col: 0 });
    for (let row = 1; row <= 7; row++) {
      for (let col = 0; col < 16; col++) {
        this.validFrames.push({ row, col });
      }
    }
    this.validFrames.push({ row: 8, col: 0 });
  }

  drawAllDice() {
    this.diceCanvases.forEach((canvasRef, index) => {
      const dctx = canvasRef.nativeElement.getContext('2d');
      if (!dctx) return;
      debugger;
      var playerId = this.game.players[index].playerId;
      var playerIndex = this.game.players.findIndex((p: any) => p.playerId === playerId);
      debugger;
      var finalNumber = this.finalNumbers[playerIndex] == null ? 1 : this.finalNumbers[playerIndex];
      this.drawDie(dctx, this.finalNumberFrames[finalNumber - 1]);
    })
  }

  showDiceRoll(playerId: string, roll: number, callback: (playerId: string, roll: number) => void) {
    var playerIndex = this.game.players.findIndex((p: any) => p.playerId === playerId);
    this.rolling[playerIndex] = true;
    this.finalNumbers[playerIndex] = roll;

    let elapsedTime = 0;
    let totalTime = 1500;
    let intervalTime = 50;
    let lastIndex = -1;

    const animate = () => {
      const canvasRef = this.diceCanvases.get(playerIndex);
      if (!canvasRef) return;

      const ctx = canvasRef.nativeElement.getContext('2d');
      if (!ctx) return;

      elapsedTime += intervalTime;
      if (elapsedTime >= totalTime) {
        this.drawDie(ctx, this.finalNumberFrames[this.finalNumbers[playerIndex] - 1]);
        this.rolling[playerIndex] = false;
        if (callback)
          callback(playerId, roll);
        return;
      }

      let newIndex;
      do {
        newIndex = Math.floor(Math.random() * this.validFrames.length);
      } while (newIndex === lastIndex);

      this.drawDie(ctx, newIndex);
      lastIndex = newIndex;
      intervalTime *= 1.1;

      setTimeout(animate, intervalTime);
    }

    animate();

  }

  rollDice(playerIndex: number, fromUi: boolean = false) {
    var player = this.game.players[playerIndex];

    if (this.rolling[playerIndex]) return;
    if (fromUi) {
      if (player.playerId != this.userId) {
        return;
      }
    }

    if (this.rollEnabled[playerIndex] == false) return;
    this.rollEnabled[playerIndex] = false;

    this.gameHubService.rollDice(this.game.id, player.playerId);
  }

  drawDie(ctx: CanvasRenderingContext2D, frameIndex: number) {
    if (!this.diceSpritesheet.complete) {
      console.warn('spritesheet not loaded yet');
      return;
    }

    const { row, col } = this.validFrames[frameIndex];

    ctx.clearRect(0, 0, this.frameSize, this.frameSize);
    ctx.drawImage(
      this.diceSpritesheet,
      col * this.frameSize, row * this.frameSize, this.frameSize, this.frameSize,
      0, 0, this.frameSize, this.frameSize
    );
  }

  initializeGameBoard() {
    const canvas: HTMLCanvasElement = this.gameCanvas.nativeElement;
    canvas.width = this.tileSize * 16;
    canvas.height = this.tileSize * 22;
    this.ctx = canvas.getContext('2d')!;
    this.drawService.drawGameBoard(this.ctx, this.tileSize, this.game.tiles);
    this.drawService.drawPawns(this.ctx, this.tileSize, this.game.players, this.game.tiles);
  }

}
