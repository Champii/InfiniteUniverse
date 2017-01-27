import { Mine } from '../building/mine/mine.model';
import { Generator } from '../building/generator/generator.model';
import { Player } from '../player/player.model';

/**
 * Planet
 */
export class Planet {
  id: number;
  position: string;
  playerId: number;
  amount: {};
  Metalmine: Mine;
  Crystalmine: Mine;
  Deutmine: Mine;
  Solarplant: Generator;
  Player: Player;
}
