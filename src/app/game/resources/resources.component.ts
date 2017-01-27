import { Component, OnInit } from '@angular/core';

import { ResourceService } from '../../shared/db/resource/resource.service';
import { Building } from '../../shared/db/building/building.model';

@Component({
  selector: 'app-resources',
  templateUrl: './resources.component.html',
  styleUrls: ['./resources.component.scss']
})
export class ResourcesComponent implements OnInit {
  buildings: [Building];
  constructor(public resourceService: ResourceService) { }

  ngOnInit() {
    // this.buildings = [
    //   { id: 1, name: 'metal mine', icon: 'metal', level: 1, description: 'Metal mining factory' }
    // ];
  }

}
