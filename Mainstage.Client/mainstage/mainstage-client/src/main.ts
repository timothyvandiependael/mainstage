import { bootstrapApplication } from '@angular/platform-browser';
import {provideRouter, RouterModule } from '@angular/router';
import { appConfig } from './app/app.config';
import { AppComponent } from './app/app.component';
import { provideHttpClient } from '@angular/common/http';
 

  bootstrapApplication(AppComponent, appConfig)
  .catch((err) => console.error(err));
