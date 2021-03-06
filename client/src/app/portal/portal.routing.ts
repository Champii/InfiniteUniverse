import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PortalComponent } from './portal.component';

const routes: Routes = [
  { path: 'portal', component: PortalComponent },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PortalRoutingModule { }

export const routedComponents = [PortalComponent];