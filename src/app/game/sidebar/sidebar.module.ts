import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import {PanelModule} from 'primeng/primeng';

import { SidebarComponent } from './sidebar.component';
import { PlanetsComponent } from './planets/planets.component';

@NgModule({
  imports: [
    CommonModule,
    PanelModule
  ],
  declarations: [
    SidebarComponent,
    PlanetsComponent
  ],
  exports: [SidebarComponent]
})
export class SidebarModule { }
