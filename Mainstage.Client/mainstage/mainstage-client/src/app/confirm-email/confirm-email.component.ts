import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';
import { NgIf } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-confirm-email',
  imports: [NgIf, FormsModule],
  templateUrl: './confirm-email.component.html',
  styleUrl: './confirm-email.component.css'
})
export class ConfirmEmailComponent {
  message: string = "";
  success: boolean = false;

  constructor(private authService: AuthService, private route: ActivatedRoute, private router: Router) {}

  ngOnInit(): void {
    this.route.queryParams.subscribe(params => {
      const token = params['token'];
      const userid = params['userid'];

      if (token && userid) {
        this.authService.confirmEmail(userid, token).subscribe({
          next: (response) => {
            this.message = response.message || 'Account succesvol bevestigd!';
            this.success = true;
          },
          error: (error) => {
            this.message = error.error || 'Fout bij het bevestigen van uw account.'
          },
          complete: () => {
            console.log('bevestigen gelukt.')
          }
        })
      }
    })
  }

  onButtonClick(): void {
    this.router.navigate(['/login']);
  }
}
