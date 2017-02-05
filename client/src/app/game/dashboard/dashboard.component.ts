import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  resources: any;
  constructor() {
    this.resources = {
      labels: ['Metal', 'Crystal', 'Deuterium'],
      datasets: [
        {
          label: 'Available',
          backgroundColor: '#42A5F5',
          borderColor: '#1E88E5',
          data: [26505, 15965, 872]
        },
        {
          label: 'Storage capacity',
          backgroundColor: '#9CCC65',
          borderColor: '#7CB342',
          data: [14000, 14000, 75000]
        },
        {
          label: 'Unit/hours',
          backgroundColor: '#9CCC65',
          borderColor: '#7CB342',
          data: [12500, 8000, 2000]
        }
      ]
    };
  }

  ngOnInit() {
  }

}
