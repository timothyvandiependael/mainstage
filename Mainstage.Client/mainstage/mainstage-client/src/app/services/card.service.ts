import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { BehaviorSubject, Observable, throwError, catchError, Subject, of } from 'rxjs';
import { AuthService } from './auth.service';
import { environment } from '../environment';

@Injectable({
  providedIn: 'root'
})
export class CardService {
  private apiUrl = environment.serverUrl + '/api/Card';

  constructor(private http: HttpClient, private authService: AuthService) { }

  getById(cardId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/get?id=` + cardId);
  }
}
