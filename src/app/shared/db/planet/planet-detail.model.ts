import { Mine } from '../building/mine/mine.model';
import { Generator } from '../building/generator/generator.model';
import { Player } from '../player/player.model';
import { Stack } from '../shared/stack';

/**
 * PlanetDetail
 */
export class PlanetDetail {
  id: number;
  name: string;
  position: string;
  playerId: number;
  amount: Stack;
  metalmine: Mine;
  crystalmine: Mine;
  deutmine: Mine;
  solarplant: Generator;
  player: Player;
}
