import { Injectable } from '@angular/core';
import { Http } from '@angular/http';

import { Rest } from '../rest.service';
import { Resource } from './resource.model';

@Injectable()
export class ResourceService extends Rest {
  public metal: Resource;
  public crystal: Resource;
  public deuterium: Resource;
  public resources: Resource[];
  public resourcesLink: {[name: string]: Resource};
    constructor(http: Http) {
    super(http);
    this.set('resource');
    this.resources = [];
    this.resourcesLink = {};
    const resourcesTab = ['metal', 'crystal', 'deuterium'];
    resourcesTab.forEach((resource, key) => {
      let resourceItem = new Resource(key, resource);
      this.resources.push(resourceItem);
      this.resourcesLink[resource] = this.resources[key];
    });
  }

}
