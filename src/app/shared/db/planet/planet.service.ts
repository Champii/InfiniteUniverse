import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';

import { Rest } from '../rest.service';

import { Planet } from '../planet/planet.model';
import { Building } from '../building/building.model';
import { Mine } from '../building/mine/mine.model';
import { Resource } from '../resource/resource.model';

@Injectable()
export class PlanetService extends Rest {
  list: Planet[] = [];
  current: Planet;
  buildings: Building[];
  constructor(http: Http) {
    super(http);
    this.set('planet');
  }

  resolve() {
    return this.find()
    .flatMap((planets: Planet[]) => this.findById(planets[0].id));
  }

  find() {
    return super.find((planets: Planet[]) => {
      console.log('planets', this.list);
    });
  }

  findById(id) {
    return super.findById(id)
      .map((planet: Planet) => {
        this.current = planet;
        this.setBuildings();
        return this.current;
      });
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

  setBuildings(): void {
    this.buildings = [
      new Mine('metal mine', 'metalmine', this.current.metalmine),
      new Mine('crystal mine', 'crystalmine', this.current.crystalmine),
      new Mine('deuterium mine', 'deutmine', this.current.deutmine)
    ];
  }

  getIcon(): string {
    return '/assets/img/planet.png';
  }
}
