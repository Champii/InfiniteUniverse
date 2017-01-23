import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.scss']
})
export class OverviewComponent implements OnInit {
  @Input() header: string;
  @Input() img: string;
  constructor() { }

  ngOnInit() {
    this.img = '/assets/img/' + this.img;
  }

}
