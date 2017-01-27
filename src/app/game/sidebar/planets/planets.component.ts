import { Component, OnInit } from '@angular/core';

import { PlanetService, Planet } from '../../../shared/db/planet';

@Component({
  selector: 'app-planets',
  templateUrl: './planets.component.html',
  styleUrls: ['./planets.component.scss']
})
export class PlanetsComponent implements OnInit {

  constructor(public planetService: PlanetService) { }

  ngOnInit() {
    this.planetService.find().subscribe((planets) => console.log(planets));
  }
}
