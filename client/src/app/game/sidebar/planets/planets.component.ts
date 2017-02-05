import { Component, OnInit } from '@angular/core';

import { PlayerService } from '../../../shared/db/player/player.service';
import { PlanetService, Planet } from '../../../shared/db/planet';

@Component({
  selector: 'app-planets',
  templateUrl: './planets.component.html',
  styleUrls: ['./planets.component.scss']
})
export class PlanetsComponent implements OnInit {

  constructor(public playerService: PlayerService, public planetService: PlanetService) { }

  ngOnInit() {
  }

  goTo(id) {
    this.planetService.findById(id).subscribe();
  }
}
