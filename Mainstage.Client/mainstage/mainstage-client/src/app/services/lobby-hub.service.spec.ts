import { TestBed } from '@angular/core/testing';

import { LobbyHubService } from './lobby-hub.service';

describe('SignalrServiceService', () => {
  let service: LobbyHubService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LobbyHubService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
