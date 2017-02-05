import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Router } from '@angular/router';

import { Observable } from 'rxjs/Rx';

import { Rest } from '../rest.service';

import { Planet, PlanetDetail } from '../planet';
import { Building } from './models/building/building.model';
import { Resources } from './models';

@Injectable()
export class PlanetService extends Rest {
  planets: Planet[] = [];
  planet: PlanetDetail;
  detail: Building;
  // amount: Resource[];
  resourceUpdater: any[];
  constructor(http: Http, private router: Router) {
    super(http);
    this.set('planet');
  }

  resolve() {
    return super.find()
    .flatMap((planets: Planet[]) => this.findById(planets[0].id))
    .catch((error) => {
      this.router.navigateByUrl('/portal');
      return Observable.throw(error);
    });
  }

  findCb(response: Response): Planet[] {
    response.json().forEeach((planet) => {
      this.planets.push(new Planet(planet));
    });
    return this.planets;
  }

  findByIdCb(response: Response): PlanetDetail {
    console.log('planet raw', response.json());
    this.planet = new PlanetDetail(response.json());
    console.log('planet', this.planet);
    console.log('metal production', this.planet.resources.getMine('metal').getProduction());
    return this.planet;
  }

  buildingLevelup(slug: string) {
    return this.isBuildingAvailable(slug) ? this.request(`building/${ this.planet.id }/${ slug }/levelup`, 'put')
    .subscribe(() => {
      this.planet.resources.getBuilding(slug).levelUp();
    }) : false;
  }

  isBuildingAvailable(slug) {
    return this.planet.resources.getBuilding(slug).isAvailable(this.planet.amount);
  }

  setDetail(building: Building) {
    this.detail = building;
  }

  getIcon(): string {
    return '/assets/img/planet.png';
  }
}
