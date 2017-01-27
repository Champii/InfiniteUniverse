import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PlanetService } from './db/planet/planet.service';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  providers: [
    PlanetService
  ]
})
export class SharedModule { }
