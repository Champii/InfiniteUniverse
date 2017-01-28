import { Component, OnInit } from '@angular/core';

import { Resource } from '../../../shared/db/resource/resource.model';
import { PlanetService } from '../../../shared/db/planet';

@Component({
  selector: 'app-resources-bar',
  templateUrl: './resources-bar.component.html',
  styleUrls: ['./resources-bar.component.scss']
})
export class ResourcesBarComponent implements OnInit {
  constructor(public planetService: PlanetService) {
  }

  ngOnInit() {}

  setIcon(icon) {
    return 'fa ' + icon;
  }
}
