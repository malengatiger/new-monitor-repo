class Photo {
  public url?: string;
  public created?: string;
  constructor() {
    this.created = new Date().toISOString();
  }
}

export default Photo;
