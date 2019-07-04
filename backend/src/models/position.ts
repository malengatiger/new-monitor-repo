class Position {
  public type: string;
  public coordinates: number[];
  public createdAt: string;

  constructor() {
    this.type = "Point";
    this.coordinates = [0.0, 0.0];
    this.createdAt = new Date().toISOString();
  }
}

export default Position;
