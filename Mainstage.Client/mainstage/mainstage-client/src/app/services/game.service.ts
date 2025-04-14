import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { BehaviorSubject, Observable, throwError, catchError, Subject, of } from 'rxjs';
import { AuthService } from './auth.service';
import { environment } from '../environment';

@Injectable({
  providedIn: 'root'
})
export class GameService {
  private apiUrl = environment.serverUrl + '/api/Game';

  constructor(private http: HttpClient, private authService: AuthService) { }

  getOpenPublicGames(): Observable<any> {
    return this.http.get(`${this.apiUrl}/getallopenpublicgames`);
  }

  setCurrentGame(game: any) {
    localStorage.setItem('currentGame', JSON.stringify(game));
  }

  getCurrentGame() {
    var raw = localStorage.getItem('currentGame');
    if (raw != null)
      return JSON.parse(raw);
    return '';
  }

  getGameFromServer(playerId: string, game: any): Observable<any> {

    if (game != '') {
      return this.http.get(`${this.apiUrl}/getgame?id=` + game.id);
    }
    else {
      return this.http.get(`${this.apiUrl}/getgameforplayer?playerId=` + playerId);
    }
   
  }
}
