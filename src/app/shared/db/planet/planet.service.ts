import { Injectable } from '@angular/core';
import { Http } from '@angular/http';

import { Rest } from '../rest.service';

@Injectable()
export class PlanetService extends Rest {

  constructor(http: Http) {
    super(http);
    this.set('planet');
  }

}
