import { Building, Mine, MineStatic, Generator, GeneratorStatic } from './building';
import { Amount } from '../../shared/amount.model';

/**
 * Resource
 */
export class Resources {
  mines: Array<Mine>;
  generators: Array<Generator>;

  constructor(body: JSON, amount: Amount) {
    this.mines = [];
    this.generators = [];
    this.setMines(body, amount);
    this.setGenerators(body);
  }

  setMines(body, amount) {
    MineStatic.forEach((mine) => {
      mine['level'] = body[mine['slug']];
      this.mines.push(new Mine(mine, amount));
    });
  }

  setGenerators(body) {
    GeneratorStatic.forEach((generator) => {
      generator['level'] = body[generator['slug']];
      this.generators.push(new Generator(generator));
    });
  }

  getBuilding(slug): Building {
    return this.getMine(slug) || this.getGenerator(slug);
  }

  getMine(slug): Mine {
    return this.mines.find((mine) => mine.slug === slug);
  }

  getGenerator(slug): Generator {
    return this.generators.find((generator) => generator.slug === slug);
  }
}
