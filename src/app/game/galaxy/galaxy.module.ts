import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataTableModule } from 'primeng/primeng';

import { SharedModule } from '../../shared/shared.module';

@NgModule({
  imports: [
    CommonModule,
    DataTableModule,
    SharedModule
  ],
  declarations: []
})
export class GalaxyModule { }
