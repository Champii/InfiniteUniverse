/**
 * Localization
 */
export class Localization {
  x: number;
  y: number;
  z: number;

  constructor(body: JSON) {
    this.x = body['x'];
    this.y = body['y'];
    this.z = body['z'];
  }

  get() {
    return '[' + this.x + ':'  + this.y + ':' + this.z + ']';
  }
}
