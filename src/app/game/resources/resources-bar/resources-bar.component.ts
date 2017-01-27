import { Component, OnInit } from '@angular/core';

import { ResourceService } from '../../../shared/db/resource/resource.service';
import { Resource } from '../../../shared/db/resource/resource.model';

@Component({
  selector: 'app-resources-bar',
  templateUrl: './resources-bar.component.html',
  styleUrls: ['./resources-bar.component.scss']
})
export class ResourcesBarComponent implements OnInit {
  public resources: [Resource];
  constructor(public resourceService: ResourceService) {
    console.log('resource', this.resourceService.resources);
  }

  ngOnInit() {
    // this.resources = [
    //   { id: 1, name: 'metal', quantity: 12300},
    //   { id: 1, name: 'crystal', quantity: 2450},
    //   { id: 1, name: 'deuterium', quantity: 347}
    // ];
  }
  setIcon(icon) {
    return 'fa ' + icon;
  }
}
