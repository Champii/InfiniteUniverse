import { Component, OnInit } from '@angular/core';

import { PlanetService } from '../shared/db/planet/planet.service';

@Component({
  selector: 'app-game',
  templateUrl: './game.component.html',
  styleUrls: ['./game.component.scss']
})
export class GameComponent implements OnInit {

  constructor(private planetService: PlanetService) {}

  ngOnInit() {}

}
