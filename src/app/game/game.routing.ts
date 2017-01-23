import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { GameComponent } from './game.component';

import { DashboardRoutes } from './dashboard/dashboard.routing';
import { ResourcesRoutes } from './resources/resources.routing';

let childrenRaw = [ResourcesRoutes, DashboardRoutes];
let children: Routes = [];

childrenRaw.map((routes) => {
  routes.map((route) => {
    children.push(route);
  });
});

console.log('children', children);
const routes: Routes = [
  {
    path: '', component: GameComponent,
    children: children
  }
];
console.log('routes', routes);
@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class GameRoutingModule { }

export const routedComponents = [GameComponent];
