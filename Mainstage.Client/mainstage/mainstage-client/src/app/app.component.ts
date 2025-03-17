import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule],
  template: '<router-outlet></router-outlet>',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'mainstage-client';

  constructor(private authService: AuthService) {};

  ngOnInit(): void {
    window.addEventListener('beforeunload', this.saveSession);
  }

  ngOnDestroy(): void {
    window.removeEventListener('beforeunload', this.saveSession);
  }

  private saveSession = () => {
    const userId = this.authService.getUserId();
    if (userId) {
      localStorage.setItem('lastUserId', userId);
    }
  };
}
