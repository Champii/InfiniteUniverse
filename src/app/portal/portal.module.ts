import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PortalComponent } from './portal.component';
import {PanelModule} from 'primeng/primeng';
import {InputTextModule} from 'primeng/primeng';
import {ButtonModule} from 'primeng/primeng';
import { FormsModule } from '@angular/forms';

import { SharedModule } from '../shared/shared.module';
import { PortalRoutingModule } from './portal.routing';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    PortalRoutingModule,
    PanelModule,
    InputTextModule,
    ButtonModule,
    FormsModule
  ],
  declarations: [PortalComponent]
})
export class PortalModule { }
