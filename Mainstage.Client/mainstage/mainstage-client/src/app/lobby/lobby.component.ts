import { Component, ChangeDetectorRef, ViewChild, ElementRef } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { NgIf, NgFor } from '@angular/common';
import { LobbyHubService } from '../services/lobby-hub.service';
import { CommonModule } from '@angular/common';
import { ChatMessageService } from '../services/chat-message.service';
import { MatDialog } from '@angular/material/dialog';
import { GameOptionsDialogComponent } from '../game-options-dialog/game-options-dialog.component';
import { GameService } from '../services/game.service';
import { Observable, Subscription } from 'rxjs';
import { LoadingService } from '../services/loading.service';


@Component({
  selector: 'app-lobby',
  imports: [NgFor, NgIf, FormsModule, CommonModule],
  templateUrl: './lobby.component.html',
  styleUrl: './lobby.component.css'
})
export class LobbyComponent {

  @ViewChild('lobbyMessages')
  lobbyMessages!: ElementRef;

  openGames: any[] = [];
  messages: any[] = [];
  newMessage: string = '';
  isChatLoading$: Observable<boolean>;
  isGamesLoading$: Observable<boolean>;

  private gameUpdatesSub?: Subscription;
  private chatUpdatesSub?: Subscription;
  private gameCreatedSub?: Subscription;
  private getMessagesForChatSub?: Subscription;
  private getOpenPublicGamesSub?: Subscription;

  constructor(
    private lobbyHubService: LobbyHubService, 
    private chatMessageService: ChatMessageService, 
    private authService: AuthService,
    public dialog: MatDialog,
    private gameService: GameService,
    private router: Router,
    private cdr: ChangeDetectorRef,
    private loadingService: LoadingService
  ) {
    this.isChatLoading$ = this.loadingService.getLoadingState('lobby-chat');
    this.isGamesLoading$ = this.loadingService.getLoadingState('lobby-games');
  }

  ngOnInit() {
    debugger;
    this.loadingService.show('lobby-chat');
    this.loadingService.show('lobby-games');

    this.authService.checkIfLoggedIn();

    this.lobbyHubService.startLobbyConnection();

    this.gameUpdatesSub?.unsubscribe();
    this.gameUpdatesSub = this.lobbyHubService.getGameUpdates().subscribe((gameUpdates: any[]) => {
        console.log('sub games');
        console.log(gameUpdates);
        this.openGames = gameUpdates;
        //this.cdr.detectChanges();
    })

    this.chatUpdatesSub?.unsubscribe();
    this.chatUpdatesSub = this.lobbyHubService.getChatUpdates().subscribe((chatMessages: any[]) => {
        this.messages = chatMessages;
        this.cdr.detectChanges();
        this.scrollChatToBottom();
    })

    this.gameCreatedSub?.unsubscribe();
    this.gameCreatedSub = this.lobbyHubService.onGameCreated().subscribe(( game: any) => { })

    this.getMessagesForChatSub?.unsubscribe();
    this.getMessagesForChatSub = this.chatMessageService.getMessagesForChat(0, 500).subscribe({
      next: (data) => {
        this.messages = data;
        this.cdr.detectChanges();
        this.scrollChatToBottom();
        this.loadingService.hide('lobby-chat');
      },
      error: (err) => {
        console.log('Fout bij het ophalen van de chatberichten: ', err);
      }
    })

    this.getOpenPublicGamesSub?.unsubscribe();
    this.getOpenPublicGamesSub = this.gameService.getOpenPublicGames().subscribe({
      next: (data) => {
        console.log('game updates on component load');
        console.log(data);
        this.openGames = data;
        this.cdr.detectChanges();
        this.loadingService.hide('lobby-games');
      },
      error: (err) => {
        console.error('Fout bij het ophalen van open games', err);
      }
    })
  }

  ngOnDestroy() {
    this.gameUpdatesSub?.unsubscribe();
    this.chatUpdatesSub?.unsubscribe();
    this.gameCreatedSub?.unsubscribe();
    this.getMessagesForChatSub?.unsubscribe();
    this.getOpenPublicGamesSub?.unsubscribe();
  }

  openNewGameDialog() {
    const dialogRef = this.dialog.open(GameOptionsDialogComponent, {
      width: '500px',
      data: {},
      panelClass: 'game-options-dialog'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        console.log('Game created with options: ', result);
        this.lobbyHubService.createLobbyGame(result);
      }
    })
  }

  sendMessage() {
    if (this.newMessage.trim()) {
      this.lobbyHubService.sendLobbyMessage(this.newMessage);
      this.newMessage = '';
      this.scrollChatToBottom();
    }
  }

  logOut() {
    this.lobbyHubService.stopConnection();
    this.authService.logout();
  }

  joinGame(game: any) {
    this.gameService.setCurrentGame(game);
    debugger;
    
    this.router.navigate(['/game-lobby']);
  }

  scrollChatToBottom() {
    if (this.lobbyMessages) {
      const chatDiv = this.lobbyMessages.nativeElement;
      chatDiv.scrollTop = chatDiv.scrollHeight;
    }
  }
}
