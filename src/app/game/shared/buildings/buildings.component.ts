import { Component, OnInit, Input } from '@angular/core';

import { Building } from '../../../shared/db/building/building.model';

@Component({
  selector: 'app-buildings',
  templateUrl: './buildings.component.html',
  styleUrls: ['./buildings.component.scss']
})
export class BuildingsComponent implements OnInit {
  @Input() header: string;
  @Input() buildings: [Building];
  constructor() { }

  ngOnInit() {
    console.log('buildings', this.buildings);
  }

  setIcon(icon) {
    return 'col-xs-12 ' + icon;
  }
}
