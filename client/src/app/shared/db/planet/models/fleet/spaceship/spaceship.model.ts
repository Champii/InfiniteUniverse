/**
 * Spaceship
 */
export class Spaceship {
  armor: number;
  attack: number;
  shield: number;
  speed: number;

  constructor(body: JSON) {
    this.armor = body['armor'];
    this.attack = body['attack']
  }

  getArmor() {

  }
}
