import { Building } from '../building.model';

/**
 * Generator
 */
export class Generator extends Building {
  energy: number;

  constructor(body: {}) {
    super(body);
    this.energy = body['energy'];
  }
}
