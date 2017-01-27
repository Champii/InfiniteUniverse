/* tslint:disable:no-unused-variable */

import { TestBed, async, inject } from '@angular/core/testing';
import { PlanetService } from './planet.service';

describe('Service: Planet', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [PlanetService]
    });
  });

  it('should ...', inject([PlanetService], (service: PlanetService) => {
    expect(service).toBeTruthy();
  }));
});
