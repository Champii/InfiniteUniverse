import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PlanetService, PlanetResolveService } from './db/planet';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  providers: [
    PlanetService,
    PlanetResolveService
  ]
})
export class SharedModule { }
