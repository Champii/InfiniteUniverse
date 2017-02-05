import { Localization } from './models';
import { Queue } from '../shared/queue.model';

/**
 * Planet
 */
export class Planet {
  id: number;
  name: string;
  playerId: number;
  queues: Array<Queue>;
  // public position: Localization;

  constructor(body: JSON) {
    this.id = body['id'];
    this.name = body['name'];
    this.playerId = body['playerId'];
    // this.position = new Localization(body['position']);
  }
}
