/**
 * Queue
 */
export class Queue {
  active: boolean;
  end: Date;
  slug: string;

  constructor(body: JSON) {
    this.active = body['active'];
    this.end = body['end'];
    this.slug = body['slug'];
    this.trigger();
  }

  setActive() {
    this.active = true;
    this.trigger();
  }

  trigger() {
    if (this.active) {
      let delay = this.end.getTime() - Date.now();
      const interval = setInterval(() => {
        delay -= 1000;
        this.active = !delay;
        if (!this.active) {
          clearInterval(interval);
        }
      }, 1000);
    }
  }
}
