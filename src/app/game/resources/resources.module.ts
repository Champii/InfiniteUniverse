import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SharedModule } from '../shared/shared.module';
import { TooltipModule } from 'primeng/primeng';

import { ResourcesComponent } from './resources.component';
import { ResourcesBarComponent } from './resources-bar/resources-bar.component';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    TooltipModule
  ],
  declarations: [
    ResourcesComponent,
    ResourcesBarComponent
  ],
  exports: [ResourcesBarComponent]
})
export class ResourcesModule { }
