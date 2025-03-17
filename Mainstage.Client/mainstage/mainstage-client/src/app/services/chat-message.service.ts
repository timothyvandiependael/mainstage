import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { BehaviorSubject, Observable, throwError, catchError, Subject, of } from 'rxjs';
import { AuthService } from './auth.service';
import { environment } from '../environment';
import { AuthInterceptor } from './auth.interceptor'; 

@Injectable({
  providedIn: 'root'
})
export class ChatMessageService {
  private apiUrl = environment.serverUrl + '/api/ChatMessage';

  constructor(private http: HttpClient, private authService: AuthService) { }

  getMessagesForChat(chatId: number, lastXMessages: number): Observable<any> {

    return this.http.get(`${this.apiUrl}/getforchat?chatId=${chatId}&lastXMessages=${lastXMessages}`);
  }
}
