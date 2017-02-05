import { Component, OnInit, Input } from '@angular/core';
import { PlanetService } from '../../../shared/db/planet/planet.service';
import { Building } from '../../../shared/db/planet/models/building/building.model';
@Component({
  selector: 'app-buildings',
  templateUrl: './buildings.component.html',
  styleUrls: ['./buildings.component.scss']
})
export class BuildingsComponent implements OnInit {
  @Input() header: string;
  @Input() buildings: any[];
  isDetailSet = false;
  constructor(public planetService: PlanetService) { }

  ngOnInit() {}

  setDetail(building: Building) {
    if (!this.isDetailSet) {
      this.planetService.setDetail(building);
      this.isDetailSet = true;
    } else {
      this.planetService.setDetail(null);
      this.isDetailSet = false;
    }

  }

  setIcon(icon) {
    return 'col-xs-12 ' + icon;
  }
}
