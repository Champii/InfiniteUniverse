import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SharedModule } from '../../shared/shared.module';
import { PanelModule } from 'primeng/primeng';

import { SidebarComponent } from './sidebar.component';
import { PlanetsComponent } from './planets/planets.component';


@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    PanelModule
  ],
  declarations: [
    SidebarComponent,
    PlanetsComponent
  ],
  exports: [SidebarComponent]
})
export class SidebarModule { }
