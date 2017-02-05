import { Planet } from './planet.model';
import { Amount } from '../shared/amount.model';
import { Resources } from './models/resources.model';
/**
 * PlanetDetail
 */
export class PlanetDetail extends Planet {
  type: string;
  amount: Amount;
  resources: Resources;

  constructor(body: JSON) {
    super(body);
    this.amount = body['amount'];
    this.resources = new Resources(body['buildings'], this.amount);
  }
}
