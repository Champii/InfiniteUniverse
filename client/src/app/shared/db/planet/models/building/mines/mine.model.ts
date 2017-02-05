import { Building } from '../building.model';
import { Amount } from '../../../../shared/amount.model';

/**
 * Mine
 */
export class Mine extends Building {
  public amount: number;

  constructor(body: {}, amount: Amount) {
    super(body);
    this.amount = amount[this.slug];
    this.setAmount();
  }

  getProduction(): number {
    // console.log('production' + this.slug, formulas[this.slug]['production'](this.level));
    return formulas[this.slug]['production'](this.level);
  }

  getConsumption(): number {
    return formulas[this.slug]['consumption'](this.level);
  }

  getAmount() {
    return this.amount.toLocaleString('de-DE', {minimumFractionDigits: 0});
  }

  setAmount() {
    if (this.getProduction()) {
      const interval = 1 / this.getProduction() * 3600000;
      let decimal = 0;

      setInterval(() => {
        const value = this.getProduction() / 3600 + decimal;
        const floor = Math.floor(value);
        decimal = value - floor;
        this.amount += floor;

      }, 1000);
    }
  }
}
