import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, throwError, catchError, Subject } from 'rxjs';
import { Router } from '@angular/router'; 
import { environment } from '../environment';
import { jwtDecode } from 'jwt-decode';


@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private apiUrl = environment.serverUrl + '/api/Account';
  private tokenKey = 'authToken';
  private errorSubject = new Subject<string>();
  error$ = this.errorSubject.asObservable();
  private successSubject = new Subject<string>();
  success$ = this.successSubject.asObservable();

  constructor(private http: HttpClient, private router: Router) {}

  isTokenExpired(token: string): boolean {
    try {
      const decodedToken: any = jwtDecode(token);
      const expDate = decodedToken.exp * 1000;  
      return new Date().getTime() > expDate;
    } catch (error) {
      return true; 
    }
  }

  checkIfLoggedIn() {
    var token = this.getToken();
    if (token != null) {
      var isExpired = this.isTokenExpired(token);
      if (isExpired)
        this.logout();

    }
    else {
      this.logout();
    }

  }

  getUserId(): string | null {
    const token = this.getToken();
    if (!token) return null;
    try {
      const decodedToken: any = jwtDecode(token);
      return decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"] || null;
    }
    catch (err) {
      console.error('Error decoding JWT: ', err);
      return null;
    }
  }

  login(username: string, password: string) {
    return this.http.post<{ token: string, refreshToken: string }>(`${this.apiUrl}/login`, { username, password }, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
      .subscribe({
        next: (response) => {
          localStorage.setItem(this.tokenKey, response.token);
          localStorage.setItem('refreshToken', response.refreshToken)
          console.log('Login succesful');
          this.router.navigate(['/lobby']);
        },
        error: (error) => {
          console.error('Login failed ', error);
          this.errorSubject.next(error.error || 'Er is een fout opgetreden tijdens het inloggen.');
        },
        complete: () => {
          console.log('Login complete');
        }
      })
  }

  refreshAccessToken() {
    const refreshToken = localStorage.getItem('refreshToken');
    if (refreshToken) {
      this.refreshToken(refreshToken).subscribe({
        next: (response) => {
          localStorage.setItem('authToken', response.token);
          localStorage.setItem('refreshToken', response.refreshToken);
        },
        error: (err) => {
          console.error('Refresh token failed: ', err);
        }
      })
    }
  }

  refreshToken(refreshToken: string): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}refresh`, { refreshToken });
  }

  register(username: string, password: string, email: string) {
    return this.http.post(`${this.apiUrl}/register`, { username, password, email }, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
      .subscribe({
        next: (response) => {
          this.successSubject.next("We hebben uw gegevens ontvangen. Check uw email voor bevestiging van uw account.");
          this.router.navigate(['/register-success']);
        },
        error: (error) => {
          this.errorSubject.next(error.error || 'Er is een fout opgetreden tijdens het registreren van uw account.');
        },
        complete: () => {
          console.log('Registration start success.')
        }
      })
  }

  confirmEmail(userid: string, token: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/confirmemail?userid=${userid}&token=${token}`, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem('refreshToken');
    this.router.navigate(['/login']);
  }

  isLoggedIn() {
    return localStorage.getItem(this.tokenKey) !== null;
  }

  getToken(): string | null {
    var token = localStorage.getItem(this.tokenKey);
    if (token == null || token == "") {
      //this.router.navigate(['/login']);
      return null;
    }
    return token;
  }
}
