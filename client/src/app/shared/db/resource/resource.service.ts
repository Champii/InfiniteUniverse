import { Injectable } from '@angular/core';

import { Rest } from '../rest.service';
import { PlanetService } from '../planet/planet.service';
import { Resource } from './resource.model';

@Injectable()
export class ResourceService  {
  resource: Resource;

  constructor(public planetService: PlanetService) {}

  values(): [any] {
    return Object(this.resource).values();
  }
}
