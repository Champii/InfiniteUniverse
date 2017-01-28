import { Component, OnInit } from '@angular/core';

import { PlanetService } from '../../shared/db/planet/planet.service';
import { MenuItem } from 'primeng/primeng';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {
  public items: [MenuItem];
  constructor(public planetService: PlanetService) { }

  ngOnInit() {
    this.items = [
      {
        label: 'Empire',
        items: [
          {label: 'Dashboard', icon: 'fa-tachometer', routerLink: ['/']},
          {label: 'Galaxy', icon: 'fa-globe'}
        ]
      },
      {
        label: this.planetService.current.name,
        items: [
          {label: 'Factories', icon: 'fa-industry', routerLink: ['/factories']},
          {label: 'Shipyard', icon: 'fa-space-shuttle'},
          {label: 'Research', icon: 'fa-flask'}
        ]
      }
    ];
  }
}
