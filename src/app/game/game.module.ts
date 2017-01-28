import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SharedModule } from '../shared/shared.module';
import { MenuModule } from 'primeng/primeng';
import { ButtonModule} from 'primeng/primeng';
import { TooltipModule } from 'primeng/primeng';

import { GameRoutingModule } from './game.routing';

import { GameComponent } from './game.component';
import { MenuComponent } from './menu/menu.component';
import { DashboardModule } from './dashboard/dashboard.module';
import { ResourcesModule } from './resources/resources.module';
import { SidebarModule } from './sidebar/sidebar.module';
import { HeaderModule } from './header/header.module';
import { SearchModule } from './search/search.module';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    GameRoutingModule,
    MenuModule,
    ButtonModule,
    TooltipModule,
    DashboardModule,
    ResourcesModule,
    SidebarModule,
    HeaderModule,
    SearchModule
  ],
  declarations: [GameComponent, MenuComponent]
})
export class GameModule { }
