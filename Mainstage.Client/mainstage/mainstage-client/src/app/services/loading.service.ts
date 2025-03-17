import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoadingService {
  private loadingStates = new Map<string, BehaviorSubject<boolean>>();

  constructor() { }

  getLoadingState(screen: string): Observable<boolean> {
    if (!this.loadingStates.has(screen)) {
      this.loadingStates.set(screen, new BehaviorSubject<boolean>(false));
    }
    return this.loadingStates.get(screen)!.asObservable();
  }

  show(screen: string) {
    this.setLoadingState(screen, true);
  }

  hide(screen: string) {
    this.setLoadingState(screen, false);
  }

  private setLoadingState(screen: string, state: boolean) {
    if (!this.loadingStates.has(screen)) {
      this.loadingStates.set(screen, new BehaviorSubject<boolean>(state));
    }
    this.loadingStates.get(screen)!.next(state);
  }
}
