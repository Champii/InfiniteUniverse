import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PanelModule } from 'primeng/primeng';
import { ChartModule } from 'primeng/primeng';

import { DashboardComponent } from './dashboard.component';

@NgModule({
  imports: [
    CommonModule,
    PanelModule,
    ChartModule
  ],
  declarations: [
    DashboardComponent
  ]
})
export class DashboardModule { }
