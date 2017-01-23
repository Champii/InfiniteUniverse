import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import {MenuModule } from 'primeng/primeng';
import {ButtonModule} from 'primeng/primeng';
import {TooltipModule} from 'primeng/primeng';

import { GameRoutingModule } from './game.routing';

import { GameComponent } from './game.component';
import { MenuComponent } from './menu/menu.component';
import { DashboardModule } from './dashboard/dashboard.module';
import { ResourcesModule } from './resources/resources.module';
import { SidebarModule } from './sidebar/sidebar.module';
import { HeaderModule } from './header/header.module';

@NgModule({
  imports: [
    CommonModule,
    GameRoutingModule,
    MenuModule,
    ButtonModule,
    TooltipModule,
    DashboardModule,
    ResourcesModule,
    SidebarModule,
    HeaderModule
  ],
  declarations: [GameComponent, MenuComponent]
})
export class GameModule { }
