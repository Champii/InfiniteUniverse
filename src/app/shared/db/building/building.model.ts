import { Stack } from '../shared/stack';

/**
 * Building
 */
export class Building {
  id: number;
  level: number;
  buildingFinish: number;
  icon: string;
  description: string;
  lastUpdate: string;
  planetId: number;
  price: Stack;

  constructor(public name: string, public slug: string, body) {
    this.id = body.id;
    this.level = body.level;
    this.buildingFinish = body.buildingFinish;
    this.price = body.price;
  }
}
