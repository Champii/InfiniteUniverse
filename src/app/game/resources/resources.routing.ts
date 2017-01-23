import { Routes } from '@angular/router';

import { ResourcesComponent } from './resources.component';

export const ResourcesRoutes: Routes = [
  { path: 'resources', component: ResourcesComponent },
];

export const routedComponents = [ResourcesComponent];