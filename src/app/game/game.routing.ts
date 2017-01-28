import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { GameComponent } from './game.component';

import { PlanetResolveService } from '../shared/db/planet/planet-resolver.service';

import { DashboardRoutes } from './dashboard/dashboard.routing';
import { FactoriesRoutes } from './factories/factories.routing';

const childrenRaw = [
  FactoriesRoutes,
  DashboardRoutes
];

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

console.log('routes', routes);

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class GameRoutingModule { }

export const routedComponents = [GameComponent];
