import { Component, OnInit } from '@angular/core';

import { PlanetService } from '../../shared/db/planet/planet.service';

@Component({
  selector: 'app-factories',
  templateUrl: './factories.component.html',
  styleUrls: ['./factories.component.scss']
})
export class FactoriesComponent implements OnInit {

  constructor(public planetService: PlanetService) {}

  ngOnInit() {
    console.log('planet', this.planetService.planet);
  }
}
