import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

import {Observable} from 'rxjs/Rx';
import { Rest } from '../rest.service';
import { Player } from './player.model';
import { PlanetService, Planet } from '../planet';

@Injectable()
export class PlayerService extends Rest {
  player: Player;
  otherPlayer: Player;
  isAuth = false;
  constructor(http: Http, private router: Router, private planetService: PlanetService) {
    super(http);
    this.set('player');
  }

  resolve() {
    return super.find()
    .flatMap((player: Player) => this.planetService.findById(player.planets[0].id))
    .catch((error) => {
      this.router.navigateByUrl('/portal');
      return Observable.throw(error);
    });
  }

  findCb(response: Response): Player {
    console.log('player', response.json());
    this.player = new Player(response.json());
    console.log('player model', this.player);
    return this.player;
  }

  findByIdCb(response: Response): Player {
    return this.otherPlayer = response.json();
  }

  find() {
    return super.find().catch((error) => {
      this.router.navigateByUrl('/portal');
      return Observable.throw(error);
    });
  }

  login(body) {
    return this.http.post(this.url + '/login', JSON.stringify(body), this.options)
      .map((response: Response) => {
        console.log(response);
        this.isAuth = true;
        this.router.navigate(['']);
      })
      .catch((error) => {
        return super.handleError(error);
    });
  }

}
