import { Injectable } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { environment } from '../environment';
import { BehaviorSubject } from 'rxjs';
import { AuthService } from './auth.service';
import { GameService } from './game.service';
import { Router } from '@angular/router';
import { LobbyHubService } from './lobby-hub.service';

@Injectable({
  providedIn: 'root'
})
export class GameHubService {

  private hubConnection: signalR.HubConnection | undefined;

  private onPlayerJoinedSource = new BehaviorSubject<{ game: any; player: any } | null>(null);
  public onPlayerJoined$ = this.onPlayerJoinedSource.asObservable();

  private onMessagesReceivedSource = new BehaviorSubject<any[]>([]);
  public onMessagesReceived$ = this.onMessagesReceivedSource.asObservable();

  private onGameStartedSource = new BehaviorSubject<any | null>(null);
  public onGameStarted$ = this.onGameStartedSource.asObservable();

  private onGameCancelledSource = new BehaviorSubject<any | null>(null);
  public onGameCancelled$ = this.onGameCancelledSource.asObservable();

  private onPlayerLeftSource = new BehaviorSubject<{ game: any; player: any } | null>(null);
  public onPlayerLeft$ = this.onPlayerLeftSource.asObservable();

  private onDieRollSource = new BehaviorSubject<{ playerId: string, roll: number } | null>(null);
  public onDieRoll$ = this.onDieRollSource.asObservable();

  private onGameStartDieRollsProcessedSource = new BehaviorSubject<any | null>(null);
  public onGameStartDieRollsProcessed$ = this.onGameStartDieRollsProcessedSource.asObservable();

  private onPlayerActionProcessedSource = new BehaviorSubject<any | null>(null);
  public onPlayerActionProcessed$ = this.onPlayerActionProcessedSource.asObservable();

  private showCardToEveryoneSource = new BehaviorSubject<{ playerId: string, card: any, jokerCard: string } | null>(null);
  public showCardToEveryone$ = this.showCardToEveryoneSource.asObservable();

  private giveInterruptChanceSource = new BehaviorSubject<{ playerId: string, actionType: string, actionParameter: string} | null>(null);
  public giveinterruptchance$ = this.giveInterruptChanceSource.asObservable();

  private keepAliveTimer: any;

  constructor(private authService: AuthService, private gameService: GameService, private router: Router, private lobbyHubService: LobbyHubService) {

  }

  startConnection(callback: () => void) {
    const token = this.authService.getToken();

    this.hubConnection = new signalR.HubConnectionBuilder()
      .withUrl(environment.serverUrl + '/gamehub', {
        accessTokenFactory: () => token || ''
      })
      .withAutomaticReconnect()
      .build();

    this.hubConnection.onreconnected((connectionId) => {
      console.log(`Reconnected! New connection ID: ${connectionId}`);
      this.hubConnection?.send('Reconnect');
    });

    this.hubConnection.onclose(() => {
      debugger;
      var userId = this.authService.getUserId();
      if (userId != null) {
        localStorage.setItem('lastUserId', userId);
      }
    });

    this.hubConnection.keepAliveIntervalInMilliseconds = 10000;
    this.hubConnection.serverTimeoutInMilliseconds = 60000;

    this.hubConnection
      .start()
      .then(() => {
        console.log("SignalR connection established");
        const lastUserId = localStorage.getItem('lastUserId');
        if (lastUserId) {
          this.hubConnection?.send('Reconnect');
          localStorage.removeItem('lastUserId');
        }
        callback();
      })
      .catch(err => console.error('Error while starting signalR connection: ' + err));
  }

  onPlayerLeft() {
    this.hubConnection?.on('PlayerLeft', (player, game) => {
      console.log('Player left: ', player);
      this.onPlayerLeftSource.next({ player, game });
    });
    return this.onPlayerLeft$;
  }

  rollDice(gameId: number, playerId: string) {
    if (this.hubConnection) {
      this.hubConnection.send('RollDie', gameId, playerId)
        .then(() => console.log('die rolling'))
        .catch(err => console.error('error rolling die ', err));
    }
  }

  processGameStartDieRoll(gameId: number, playerId: string, roll: number) {
    if (this.hubConnection) {
      this.hubConnection.send('ProcessGameStartDieRoll', gameId, playerId, roll)
        .then(() => console.log('Processing die roll'))
        .catch(err => console.error('error processing die roll ', err));
    }
  }

  showCardToEveryone() {
    this.hubConnection?.on('ShowCardToEveryone', (playerId, card, jokerCard) => {
      this.showCardToEveryoneSource.next({ playerId, card, jokerCard });
    });
    return this.showCardToEveryone$;
  }

  giveInterruptChance() {
    this.hubConnection?.on('GiveInterruptChance', (playerId, actionType, actionParameter) => {
      this.giveInterruptChanceSource.next({ playerId, actionType, actionParameter });
    });
    return this.giveinterruptchance$;
  }

  onGameStartDieRollsProcessed() {
    this.hubConnection?.on('OnGameStartDieRollsProcessed', (model) => {
      this.onGameStartDieRollsProcessedSource.next(model);
    });
    return this.onGameStartDieRollsProcessed$;
  }

  processPlayerAction(gameStateInfo: any, type: string, parameters: any) {
    if (this.hubConnection) {
      this.hubConnection.send('ProcessPlayerAction', gameStateInfo, type, parameters)
        .then(() => console.log('Action sent'))
        .catch(err => console.error('Error sending action ', err));
    }
  }

  onPlayerActionProcessed() {
    this.hubConnection?.on('OnPlayerActionProcessed', (gai) => {
      this.onPlayerActionProcessedSource.next(gai);
    });
    return this.onPlayerActionProcessed$;
  }

  onDieroll() {
    this.onDieRollSource.next(null);
    this.hubConnection?.on('DieRoll', (playerId, roll) => {
      debugger;
      this.onDieRollSource.next({ playerId, roll });
    })
    return this.onDieRoll$;
  }

  onPlayerJoined() {
    this.onPlayerJoinedSource.next(null);
    this.hubConnection?.on('PlayerJoined', (player, game) => {
      debugger;
      console.log("Player joined: ", player);
      console.log("For game: ", game);
      this.onPlayerJoinedSource.next({ game, player });
    })
    return this.onPlayerJoined$;
  }

  addToGroup(gameId: number) {
    if (this.hubConnection) {
      this.hubConnection.send('AddToGroup', gameId)
        .then(() => console.log('Owner add to group request sent to gamehub'))
        .catch(err => console.error('Error adding owner to game group', err));
    }
  }

  joinGame(game: any) {
    if (this.hubConnection) {
      this.hubConnection.send('JoinGame', game)
        .then(() => console.log('Joining game sent to gamehub'))
        .catch(err => console.error('Error joining game ', err));
    }
  }

  sendMessage(message: string, gameId: number) {
    if (this.hubConnection) {
      this.hubConnection.send('SendMessage', message, gameId, false)
        .then(() => console.log('Message sent to Game Hub'))
        .catch(err => console.error('Error sending message to Game Hub: ' + err));
    }
  }

  onGameStarted() {
    this.hubConnection?.on('GameStarted', (game) => {
      this.gameService.setCurrentGame(game);
      this.router.navigate(['/game']);
      this.onGameStartedSource.next(game);
    })
    return this.onGameStarted$;
  }

  onGameCancelled() {
    this.hubConnection?.on('GameCancelled', (game) => {
      this.lobbyHubService.updateLobbyForCurrentUser();
      this.onGameCancelledSource.next(game);
    })
    return this.onGameCancelled$;
  }

  onMessagesReceived() {
    this.onMessagesReceivedSource.next([]);
    this.hubConnection?.on('ReceiveMessages', (messages) => {
      this.onMessagesReceivedSource.next(messages);
    })
    return this.onMessagesReceived$;
  }

  playerReady(gameId: number, playerId: string) {
    if (this.hubConnection) {
      this.hubConnection.send('PlayerReady', gameId, playerId)
        .then(() => console.log('Player ready sent to gamehub'))
        .catch(err => console.error('Error sending player ready to hub ', err));
    }
  }

  exitGame(gameId: number, playerId: string) {
    if (this.hubConnection) {
      this.hubConnection.invoke('ExitGame', gameId, playerId)
        .then(() => {
          console.log('Player exit sent to gamehub');
          this.router.navigate(['/lobby']);
        })
        .catch(err => console.error('Error sending player exit to hub ', err));
    }
  }

  keepAlive() {
    if (this.keepAliveTimer) {
      clearInterval(this.keepAliveTimer);
    }
    this.keepAliveTimer = setInterval(() => {
      if (this.hubConnection?.state === signalR.HubConnectionState.Connected) {
        this.hubConnection.send("KeepAlive").catch(err => console.error(err));
      }
    }, 119000);
  }
}
