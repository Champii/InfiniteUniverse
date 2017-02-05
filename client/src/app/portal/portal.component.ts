import { Component, OnInit } from '@angular/core';

import { PlayerService } from '../shared/db/player';

@Component({
  selector: 'app-portal',
  templateUrl: './portal.component.html',
  styleUrls: ['./portal.component.scss']
})
export class PortalComponent implements OnInit {
  username: string;
  password: string;

  constructor(public playerService: PlayerService) {}

  ngOnInit() {}

  login() {
    console.log('login');
    this.playerService.login({
      username: this.username,
      password: this.password
    }).subscribe();
  }

}
