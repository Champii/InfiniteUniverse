import { Component, OnInit } from '@angular/core';

import { Building } from '../../shared/db/building/building.model';
import { PlanetService } from '../../shared/db/planet/planet.service';

@Component({
  selector: 'app-factories',
  templateUrl: './factories.component.html',
  styleUrls: ['./factories.component.scss']
})
export class FactoriesComponent implements OnInit {
  buildings: [Building];

  constructor(public planetService: PlanetService) {}

  ngOnInit() {}
}
