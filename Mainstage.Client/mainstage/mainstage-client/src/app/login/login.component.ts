import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-login',
  imports: [FormsModule, NgIf],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  username: string = '';
  password: string = '';
  errorMessage: string = '';

  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit(): void {
    const token = this.authService.getToken();
    if (token) {
      this.router.navigate(['/lobby']);
    }

    this.authService.error$.subscribe((errorMessage: string) => {
      this.errorMessage = errorMessage;
    })
  }

  onLogin(event: Event) {
    event.preventDefault();
    this.errorMessage = '';
    this.authService.login(this.username, this.password);
  }
}
