import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PlayerService, PlayerResolveService } from './db/player';
import { PlanetService, PlanetResolveService } from './db/planet';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  providers: [
    PlayerService,
    PlayerResolveService,
    PlanetService
  ]
})
export class SharedModule { }
