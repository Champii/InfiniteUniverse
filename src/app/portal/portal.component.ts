import { Component, OnInit } from '@angular/core';

import { PlayerService, Player } from '../shared/db/player';

@Component({
  selector: 'app-portal',
  templateUrl: './portal.component.html',
  styleUrls: ['./portal.component.scss']
})
export class PortalComponent implements OnInit {
  player: Player;
  constructor(public playerService: PlayerService) {
    this.player = new Player();
  }

  ngOnInit() {
  }

  login() {
    console.log('login');
    this.playerService.login(this.player).subscribe();
  }

}
