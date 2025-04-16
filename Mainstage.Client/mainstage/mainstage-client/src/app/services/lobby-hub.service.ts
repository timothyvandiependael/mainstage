import { Injectable } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { environment } from '../environment';
import { BehaviorSubject } from 'rxjs';
import { AuthService } from './auth.service';
import { GameService } from './game.service';
import { Router } from '@angular/router';
import { LoadingService } from './loading.service';

@Injectable({
  providedIn: 'root'
})
export class LobbyHubService {

  private hubConnection: signalR.HubConnection | undefined;
  private gameUpdatesSource = new BehaviorSubject<any[]>([]);
  private chatUpdatesSource = new BehaviorSubject<any[]>([]);
  private onGameCreatedSource = new BehaviorSubject<any>(null);

  public gameUpdates$ = this.gameUpdatesSource.asObservable();
  public chatUpdates$ = this.chatUpdatesSource.asObservable();
  public onGameCreated$ = this.onGameCreatedSource.asObservable();

  private keepAliveTimer: any;

  constructor(private authService: AuthService, private gameService: GameService, private router: Router) {

  }

  startLobbyConnection(callback: () => void) {
    const token = this.authService.getToken();

    this.hubConnection = new signalR.HubConnectionBuilder()
      .withUrl(environment.serverUrl + '/lobbyhub', {
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

  onGameCreated() {
    this.hubConnection?.on('NavigateToGameScreen', (game) => {
      console.log("Navigating to game screen for game", game.name);
      if (game != null) {
        this.router.navigate(['/game-lobby']);
      }
      this.onGameCreatedSource.next(game);
    })
    return this.onGameCreated$;
  }

  getGameUpdates() {
    this.gameUpdatesSource.next([]);
    this.hubConnection?.on('ReceiveGameUpdates', (gameUpdates: any[]) => {
      console.log('gameupdates ontvangen');
      this.gameUpdatesSource.next(gameUpdates);
    });
    return this.gameUpdates$;
  }

  getChatUpdates() {
    this.chatUpdatesSource.next([]);
    this.hubConnection?.on('ReceiveChatMessages', (chatMessages: any[]) => {
      this.chatUpdatesSource.next(chatMessages);
    });
    return this.chatUpdates$;
  }

  isAlreadyInGame(callback: () => void) {
    this.hubConnection?.invoke('IsAlreadyInGame')
      .then((game) => { 
        console.log('Is Already In Game Request sent to lobby hub.');
        callback();
        if (game && game.id > 0) {
          if (game.state == 'open') {
            this.router.navigate(['/game-lobby']);
          }
          else if (game.state == 'ongoing' || game.state == 'started') {
            this.router.navigate(['/game']);
          }
        }
      })
      .catch(err => console.error('Error sending already in game check to lobby hub: ', err));
  }

  sendLobbyMessage(message: string) {
    if (this.hubConnection) {
      this.hubConnection.send('SendMessage', message)
        .then(() => console.log('Message sent to Lobby Hub'))
        .catch(err => console.error('Error sending message to Lobby Hub: ' + err));
    }
  }

  updateLobbyForCurrentUser() {
    if (this.hubConnection) {
      this.hubConnection.send('UpdateLobbyForCurrentUser')
        .then(() => { console.log('Lobby updated for current user.'); this.router.navigate(['/lobby'], { replaceUrl: true }); })
        .catch(err => console.error('Error updating lobby for current user ', err));
    }
  }



  createLobbyGame(gameOptions: any) {
    if (this.hubConnection) {
      this.hubConnection.send('CreateGame', gameOptions)
        .then(() => {
          console.log('Game creation sent to lobby hub');
        })
        .catch(err => console.error('Error sending game creation to lobby hub.' + err));
    }
  }

  deleteLobbyGame(id: number) {
    if (this.hubConnection) {
      this.hubConnection.send('DeleteGame', id)
        .then(() => console.log('Game deletion sent to lobby hub'))
        .catch(err => console.error('Error sending game deletion to lobby hub.' + err));
    }
  }

  stopConnection(): void {
    if (this.hubConnection) {
      this.hubConnection.stop()
        .then(() => console.log('Lobby SignalR Connection Stopped'))
        .catch(err => console.error('Error stopping Lobby connection: ' + err));
    }
  }
}
