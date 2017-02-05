import { Component, OnInit, Input } from '@angular/core';

import { Building } from '../../../shared/db/planet/models/building/building.model';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.scss']
})
export class OverviewComponent implements OnInit {
  @Input() header: string;
  @Input() img: string;
  @Input() detail: Building;
  constructor() { }

  ngOnInit() {
    console.log('detail', this.detail);
    this.img = '/assets/img/' + this.img;
  }

}
