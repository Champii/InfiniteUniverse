import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SharedModule } from '../shared/shared.module';
import { TooltipModule } from 'primeng/primeng';

import { FactoriesComponent } from './factories.component';
import { ResourcesBarComponent } from './resources-bar/resources-bar.component';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    TooltipModule
  ],
  declarations: [
    FactoriesComponent,
    ResourcesBarComponent
  ],
  exports: [ResourcesBarComponent],
  providers: []
})
export class FactoriesModule { }
