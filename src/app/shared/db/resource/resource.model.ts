/**
 * Resource
 */
export class Resource {
  public quantity: number;
  constructor(
    public id: number,
    public name: string
  ) {
    this.quantity = 0;
  }
}
