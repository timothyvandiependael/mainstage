import { Component, HostListener, ViewChild, ElementRef, ChangeDetectorRef } from '@angular/core';
import { NgFor, CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { GameService } from '../services/game.service';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { GameHubService } from '../services/game-hub.service';
import { LobbyHubService } from '../services/lobby-hub.service';
import { Observable, Subscription } from 'rxjs';
import { LoadingService } from '../services/loading.service';
import { ChatMessageService } from '../services/chat-message.service';

@Component({
  selector: 'app-game-lobby',
  imports: [NgFor, FormsModule, CommonModule],
  templateUrl: './game-lobby.component.html',
  styleUrl: './game-lobby.component.css'
})
export class GameLobbyComponent {

  @ViewChild('gameLobbyMessages')
  gameLobbyMessages!: ElementRef;

  game: any = null;
  userId: string = '';
  isCreator: boolean = false;
  messages: any[] = [];
  newMessage: string = '';
  isGameDetailLoading$: Observable<boolean>;
  isChatLoading$: Observable<boolean>;
  currentPlayerAmount: number = 0;

  private onPlayerJoinedSub?: Subscription;
  private onMessagesReceivedSub?: Subscription;
  private getMessagesForChatSub?: Subscription;
  private onPlayerLeftSub?: Subscription;
  private onGameCancelledSub?: Subscription;
  private onGameStartedSub?: Subscription;
  private getGameFromServerSub?: Subscription;

  constructor(
    private gameService: GameService,
    private router: Router,
    private authService: AuthService,
    private gameHubService: GameHubService,
    private lobbyHubService: LobbyHubService,
    private loadingService: LoadingService,
    private chatMessageService: ChatMessageService,
    private cdr: ChangeDetectorRef,
  ) {
    this.isGameDetailLoading$ = this.loadingService.getLoadingState('game-lobby-game-detail');
    this.isChatLoading$ = this.loadingService.getLoadingState('game-lobby-chat');
  }

  ngOnInit() {
    localStorage.removeItem('leavingGame');
    this.loadingService.show('game-lobby-game-detail');
    this.loadingService.show('game-lobby-chat');

    var retrievedUser = this.authService.getUserId();
    if (retrievedUser == null) {
      this.router.navigate(['/login']);
    }
    else {
      this.userId = retrievedUser;

      this.game = this.gameService.getCurrentGame();
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
  }

  initAfterLoadingGame() {
    if (this.game == null) {
      this.router.navigate(['/lobby']);
    }
    else {
      if (this.userId == this.game.crUser) {
        this.isCreator = true;
        this.currentPlayerAmount = this.game.players.length;
        this.loadingService.hide('game-lobby-game-detail');
      }

      this.gameHubService.startConnection(() => {
        if (this.userId != this.game.crUser) {
          this.gameHubService.joinGame(this.game);
        }
        else {
          this.gameHubService.addToGroup(this.game.id);
        }

        this.onPlayerJoinedSub?.unsubscribe();
        this.onPlayerJoinedSub = this.gameHubService.onPlayerJoined().subscribe((data) => {
          if (data) {
            this.game = data.game;
            this.gameService.setCurrentGame(data.game);
            this.currentPlayerAmount = this.game.players.length;
            this.loadingService.hide('game-lobby-game-detail');
            if (!this.isCreator) this.loadingService.hide('game-lobby-chat');
            this.cdr.detectChanges();
            this.scrollChatToBottom();
          }
        });

        this.onMessagesReceivedSub?.unsubscribe();
        this.onMessagesReceivedSub = this.gameHubService.onMessagesReceived().subscribe((chatMessages: any[]) => {
          debugger;
          if (chatMessages) {
            this.messages = chatMessages;
            this.cdr.detectChanges();
            this.scrollChatToBottom();

          }
        })

        this.getMessagesForChatSub?.unsubscribe();
        this.getMessagesForChatSub = this.getMessagesForChatSub = this.chatMessageService.getMessagesForChat(this.game.id, 500).subscribe({
          next: (data) => {
            if (data) {
              this.messages = data;
              if (this.isCreator) this.loadingService.hide('game-lobby-chat');
              this.cdr.detectChanges();
              this.scrollChatToBottom();
            }
          },
          error: (err) => {
            console.log('Fout bij het ophalen van de chatberichten: ', err);
          }
        })

        this.onPlayerLeftSub?.unsubscribe();
        this.onPlayerLeftSub = this.gameHubService.onPlayerLeft().subscribe((data: any) => {
          if (data) {
            this.game = data.game;
            this.gameService.setCurrentGame(data.game);
            this.currentPlayerAmount = this.game.players.length;
            this.cdr.detectChanges();
            this.scrollChatToBottom();
          }

        })

        this.onGameStartedSub?.unsubscribe();
        this.onGameStartedSub = this.gameHubService.onGameStarted().subscribe((game: any) => {

        });

        this.onGameCancelledSub?.unsubscribe();
        this.onGameCancelledSub = this.gameHubService.onGameCancelled().subscribe((game: any) => {
        })
      });

    }
  }

  ngOnDestroy() {
    this.onPlayerJoinedSub?.unsubscribe();
    this.onMessagesReceivedSub?.unsubscribe();
    this.getMessagesForChatSub?.unsubscribe();
    this.onPlayerLeftSub?.unsubscribe();
    this.onGameCancelledSub?.unsubscribe();
    this.getGameFromServerSub?.unsubscribe();
  }

  @HostListener('window:beforeunload', ['$event'])
  onBeforeUnload(event: Event) {
    event.preventDefault();
  }

  ready() {
    this.gameHubService.playerReady(this.game.id, this.userId);
  }

  exit() {
    this.gameHubService.exitGame(this.game.id, this.userId);
  }

  sendMessage() {
    if (this.newMessage.trim()) {
      this.gameHubService.sendMessage(this.newMessage, this.game.id);
      this.newMessage = '';
      this.scrollChatToBottom();
    }

  }

  scrollChatToBottom() {
    if (this.gameLobbyMessages) {
      const chatDiv = this.gameLobbyMessages.nativeElement;
      chatDiv.scrollTop = chatDiv.scrollHeight;
    }
  }
}
