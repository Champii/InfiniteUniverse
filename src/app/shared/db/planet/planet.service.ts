import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';

import { Rest } from '../rest.service';

import { Planet } from '../planet/planet.model';
import { Mine } from '../building/mine/mine.model';
import { Resource } from '../resource/resource.model';

@Injectable()
export class PlanetService extends Rest {
  list: Planet[] = [];
  current: Planet;
  constructor(http: Http) {
    super(http);
    this.set('planet');
  }

  resolve() {
    return this.find()
    .flatMap(() => this.findById(this.current.id));
  }

  find() {
    return super.find(() => {
      this.current = this.list[0];
      console.log('planets', this.list);
    });
  }

  findById(id) {
    return super.findById(id).map((planet: Planet) => this.current = planet);
  }

  getAmount(): Resource[] {
    const amount = this.current.amount;
    return [
      new Resource('metal', amount.metal),
      new Resource('crystal', amount.crystal),
      new Resource('deut', amount.deut),
      new Resource('energy', amount.energy)
    ];
  }

  getIcon(): string {
    return '/assets/img/planet.png';
  }
}
