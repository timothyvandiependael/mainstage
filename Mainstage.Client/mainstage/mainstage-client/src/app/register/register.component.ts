import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-register',
  imports: [FormsModule, NgIf],
  templateUrl: './register.component.html',
  styleUrl: './register.component.css'
})
export class RegisterComponent {
  username: string = '';
  email: string = '';
  password: string = '';
  passwordconfirm: string = '';
  errorMessage: string = '';

  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit(): void {
    debugger;
    const token = this.authService.getToken();
    if (token) {
      this.router.navigate(['/lobby']);
    }

    this.authService.error$.subscribe((errorMessage: string) => {
      this.errorMessage = errorMessage;
    })
  }

  onRegister(form: any) {
    this.errorMessage = '';

    if (this.password != this.passwordconfirm) {
      this.errorMessage = "Wachtwoorden zijn niet hetzelfde.";
    }
    else {
      if (form.valid) {
        this.authService.register(this.username, this.password, this.email);
      } 
    }
  }
}
