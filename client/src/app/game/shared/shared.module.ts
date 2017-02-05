import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FieldsetModule } from 'primeng/primeng';
import { DataGridModule } from 'primeng/primeng';
import { PanelModule } from 'primeng/primeng';

import { OverviewComponent } from './overview/overview.component';
import { BuildingsComponent } from './buildings/buildings.component';

@NgModule({
  imports: [
    CommonModule,
    FieldsetModule,
    DataGridModule,
    PanelModule
  ],
  declarations: [
    OverviewComponent,
    BuildingsComponent
  ],
  exports: [
    OverviewComponent,
    BuildingsComponent
  ]
})
export class SharedModule { }
