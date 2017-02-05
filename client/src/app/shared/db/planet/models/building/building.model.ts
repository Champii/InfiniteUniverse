import { Amount } from '../../../shared/amount.model';

/**
 * Building
 */
export class Building {
  slug: string;
  name: string;
  level: number;
  icon: string;

  constructor(body: {}) {
    this.slug = body['slug'];
    this.name = body['name'];
    this.level = body['level'];
  }

  getPrice(): Amount {
    return formulas[this.slug]['price'](this.level);
  }

  isAvailable(amount: Amount) {
    const values = ['metal', 'crystal', 'deut'];
    let isOk = true;
    let count = 0;
    while (isOk && Object.keys(this.getPrice()).length > count) {
      isOk = this.getPrice()[values[count]] < amount[values[count]];
      count ++;
    }
    return isOk;
  }

  levelUp() {
    this.level++;
  }
}
