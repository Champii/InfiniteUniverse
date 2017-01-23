import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PanelModule } from 'primeng/primeng';
import { MenubarModule } from 'primeng/primeng';

import { HeaderComponent } from './header.component';

@NgModule({
  imports: [
    CommonModule,
    PanelModule,
    MenubarModule
  ],
  declarations: [
    HeaderComponent
  ],
  exports: [HeaderComponent]
})
export class HeaderModule { }
