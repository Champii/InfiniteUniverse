import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import { Router } from '@angular/router';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

import {Observable} from 'rxjs/Rx';
import { Rest } from '../rest.service';
import { Player } from './player.model';

@Injectable()
export class PlayerService extends Rest {
  player: Player;
  isAuth = false;
  constructor(http: Http, private router: Router) {
    super(http);
    this.set('player');
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
