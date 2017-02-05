/**
 * Amount
 */
export class Amount {
  crystal: number;
  deut: number;
  energy: number;
  metal: number;

  constructor(body: JSON) {
    this.metal = body['metal'];
    this.crystal = body['crystal'];
    this.deut = body['deut'];
    this.energy = body['energy'];
  }
}
