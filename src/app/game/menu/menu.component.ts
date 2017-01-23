import { Component, OnInit } from '@angular/core';

import { MenuItem } from 'primeng/primeng';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {
  public items: [MenuItem];
  constructor() { }

  ngOnInit() {
    this.items = [
      {label: 'Dashboard', icon: 'fa-tachometer', routerLink: ['/']},
      {label: 'Resources', icon: 'fa-industry', routerLink: ['/resources']},
      {label: 'Research', icon: 'fa-flask'},
      {label: 'Shipyard', icon: 'fa-space-shuttle'}
    ];
  }
}
