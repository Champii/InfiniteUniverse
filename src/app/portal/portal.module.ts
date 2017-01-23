import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PortalComponent } from './portal.component';
import {PanelModule} from 'primeng/primeng';
import {InputTextModule} from 'primeng/primeng';
import {ButtonModule} from 'primeng/primeng';

import { PortalRoutingModule } from './portal.routing';

@NgModule({
  imports: [
    CommonModule,
    PanelModule,
    PortalRoutingModule,
    InputTextModule,
    ButtonModule
  ],
  declarations: [PortalComponent]
})
export class PortalModule { }
