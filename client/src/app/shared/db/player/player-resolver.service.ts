import { Injectable } from '@angular/core';
import { Router, ActivatedRouteSnapshot, Resolve } from '@angular/router';
import { Observable } from 'rxjs/Rx';

import { PlanetService } from '../planet/planet.service';
import { PlayerService } from '../player/player.service';
import { Player } from './player.model';

@Injectable()
export class PlayerResolveService implements Resolve<Player> {

  constructor(
    private playerService: PlayerService,
    private router: Router) { }

  resolve(route: ActivatedRouteSnapshot): Observable<Player> {
    return this.playerService.resolve();
  }
}
