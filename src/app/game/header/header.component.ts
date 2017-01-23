import { Component, OnInit } from '@angular/core';

import { MenuItem } from 'primeng/primeng';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {
  private items: MenuItem[];
  constructor() { }

  ngOnInit() {
    this.items = [{
      label: 'Home',
      items: [
        {
          label: 'New',
          icon: 'fa-plus',
            items: [
              {label: 'Project'},
              {label: 'Other'},
            ]
          },
          {label: 'Open'},
          {label: 'Quit'}
        ]
      },
      {
        label: 'Friends',
        icon: 'fa-edit'
      }
    ];
  }
}
