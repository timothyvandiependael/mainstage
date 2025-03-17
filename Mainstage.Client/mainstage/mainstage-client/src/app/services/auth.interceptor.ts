import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent, HttpErrorResponse } from '@angular/common/http';
import { AuthService } from './auth.service';
import { Observable, switchMap, throwError } from 'rxjs';
import { catchError } from 'rxjs';
import { Router } from '@angular/router';
import { of } from 'rxjs';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(private authService: AuthService, private router: Router) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const token = this.authService.getToken();
    const refreshToken = localStorage.getItem('refreshToken') || '';

    if (token) {
      if (this.authService.isTokenExpired(token)) {
        this.authService.refreshToken(refreshToken).subscribe({
          next: (response) => {
            localStorage.setItem('authToken', response.token);
            localStorage.setItem('refreshToken', response.refreshToken);

            req = req.clone({
              setHeaders: {
                Authorization: `Bearer ${response.Token}`
              }
            })
            return next.handle(req).pipe(
              catchError((error: HttpErrorResponse) => {
                debugger;
                if (error.status === 401) {
                  this.authService.logout();
                  this.router.navigate(['/login']);
                }
                return throwError(error);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
              })
            );
          },
          error: (err) => {
            console.error('Refresh token failed: ', err);
            this.authService.logout();
            return [];
          }
        })
      }
      else {
        req = req.clone({
          setHeaders: {
            Authorization: `Bearer ${token}`
          }
        });
      }
      
      return next.handle(req).pipe(
        catchError((error: HttpErrorResponse) => {
          if (error.status === 401) {
            this.authService.logout();
            debugger;
            this.router.navigate(['/login']);
          }
          return throwError(error);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
        })
      );
    }

    return next.handle(req);
  }
}