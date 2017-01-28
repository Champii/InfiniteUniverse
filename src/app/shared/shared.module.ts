import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PlayerService } from './db/player/player.service';
import { PlanetService, PlanetResolveService } from './db/planet';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  providers: [
    PlayerService,
    PlanetService,
    PlanetResolveService
  ]
})
export class SharedModule { }
