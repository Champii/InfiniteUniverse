import { Stack } from '../shared/stack';

/**
 * Building
 */
export class Building {
  id: number;
  name: string;
  level: number;
  buildingFinish: number;
  icon: string;
  description: string;
  lastUpdate: string;
  planetId: number;
  price: Stack;
}
