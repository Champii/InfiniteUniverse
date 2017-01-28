import { Building } from '../building.model';

/**
 * Mine
 */
export class Mine extends Building {
  amount: number;
  production: number;
  consumption: number;

  constructor(name, url, body) {
    super(name, url, body);
    this.production = body.production;
    this.consumption = body.consumption;
  }
}
