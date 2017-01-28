import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { GameComponent } from './game.component';

import { PlanetResolveService } from '../shared/db/planet/planet-resolver.service';

import { DashboardRoutes } from './dashboard/dashboard.routing';
import { ResourcesRoutes } from './resources/resources.routing';

const childrenRaw = [ResourcesRoutes, DashboardRoutes];
const children: Routes = [];

childrenRaw.map((routes) => {
  routes.map((route) => {
    children.push(route);
  });
});

const routes: Routes = [
  {
    path: '', component: GameComponent,
    children: children,
    resolve: {
      planets: PlanetResolveService
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class GameRoutingModule { }

export const routedComponents = [GameComponent];
