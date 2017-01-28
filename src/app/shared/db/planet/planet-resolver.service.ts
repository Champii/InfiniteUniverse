import { Injectable } from '@angular/core';
import { Router, ActivatedRouteSnapshot, Resolve } from '@angular/router';
import { Observable } from 'rxjs/Rx';

import { Planet } from './planet.model';
import { PlanetService } from './planet.service';
import { PlayerService } from '../player/player.service';

@Injectable()
export class PlanetResolveService implements Resolve<Planet> {

  constructor(
    private planetService: PlanetService,
    private playerService: PlayerService,
    private router: Router) { }

  resolve(route: ActivatedRouteSnapshot): Observable<Planet> {
    if (this.playerService.isAuth) {
      return this.planetService.resolve();
    } else {
      this.router.navigateByUrl('/portal');
    }
  }
}
