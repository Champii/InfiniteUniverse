/* tslint:disable:no-unused-variable */

import { TestBed, async, inject } from '@angular/core/testing';
import { HttpModule } from '@angular/http';
import { ResourceService } from './resource.service';

describe('Service: Resource', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpModule],
      providers: [ResourceService]
    });
  });

  it('should be truthy', inject([ResourceService], (service: ResourceService) => {
    expect(service).toBeTruthy();
  }));
});
