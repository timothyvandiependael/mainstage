import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { LobbyComponent } from './lobby/lobby.component';
import { AuthGuard } from './services/auth.guard';
import { RegisterComponent } from './register/register.component';
import { RegisterSuccessComponent } from './register-success/register-success.component';
import { ConfirmEmailComponent } from './confirm-email/confirm-email.component';
import { GameLobbyComponent } from './game-lobby/game-lobby.component';
import { GameComponent } from './game/game.component';

export const routes: Routes = [
    { path: '', redirectTo: '/login', pathMatch: 'full' },
    { path: 'login', component: LoginComponent },
    { path: 'register', component: RegisterComponent },
    { path: 'register-success', component: RegisterSuccessComponent},
    { path: 'confirm-email', component: ConfirmEmailComponent },
    { path: 'lobby', component: LobbyComponent, canActivate: [AuthGuard], runGuardsAndResolvers: 'always' },
    { path: 'game-lobby', component: GameLobbyComponent, canActivate: [AuthGuard], runGuardsAndResolvers: 'always' },
    { path: 'game', component: GameComponent, canActivate: [AuthGuard], runGuardsAndResolvers: 'always'}
];
