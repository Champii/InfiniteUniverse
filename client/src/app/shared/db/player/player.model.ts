import { Research } from './models';
import { Planet } from '../planet/planet.model';
import { Queue } from '../shared/queue.model';

/**
 * Player
 */
export class Player {
  username: string;
  researches: Array<Research>;
  planets: Array<Planet>;
  queues: Array<Queue>;

  constructor(body: JSON) {
    this.researches = [];
    this.planets = [];
    this.username = body['username'];

    this.setResearches(body['researches']);
    this.setPlanets(body['planets']);
  }

  public getResearchBySlug(name: string) {
    return this.researches.find((research) => research.name === name);
  }

  public getPlanetById(id): Planet {
    return this.planets.find((planet) => planet.id === id);
  };

  private setResearches(research: JSON) {
    this.setResearch('combustion-drive', 'Combustion Drive', research['combustionDrive']);
  }

  private setPlanets(planets: Array<any>) {
    planets.forEach((planet) => {
      this.planets.push(new Planet(planet));
    });
  }

  private setResearch(slug, name, level) {
    this.researches.push(new Research(slug, name, level));
  }
}
