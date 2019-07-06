import {
  instanceMethod,
  InstanceType,
  ModelType,
  prop,
  staticMethod,
  Typegoose,
} from "typegoose";
import City from "./city";
import { Content, RatingContent } from "./interfaces";

class Settlement extends Typegoose {
  @staticMethod
  public static findByName(
    this: ModelType<Settlement> & typeof Settlement,
    settlementName: string,
  ) {
    console.log(
      "#####  🥦  🥦  🥦 Finding Settlement by name:  💦  💦  💦  :: 🥦 " +
        name,
    );
    return this.findOne({ settlementName });
  }
  @staticMethod
  public static findBySettlementId(
    this: ModelType<Settlement> & typeof Settlement,
    settlementId: string,
  ) {
    console.log(
      "#####  🥦  🥦  🥦 Finding Settlement by ID:  💦  💦  💦  :: 🥦 " +
        settlementId,
    );
    return this.findOne({ settlementId });
  }

  @prop({ required: true, unique: true, trim: true })
  public settlementName?: string;
  //
  @prop({ trim: true })
  public email?: string;
  //
  @prop({ trim: true })
  public cellphone?: string;

  @prop({ required: true, trim: true })
  public countryID!: string;
  //
  @prop({ trim: true })
  public settlementId!: string;
  //
  @prop({ required: true, default: [] })
  public polygon!: Position[];
  //
  @prop({ required: true, default: [] })
  public nearestCities!: any[];
  //
  @prop({ required: true })
  public countryName!: string;
  //
   @prop({ required: true, default: 0 })
  public population!: number;
  //
   @prop({ required: true, default: [] })
  public photoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public videoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public ratings!: RatingContent[];
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;

  @instanceMethod
  public updatePopulation(this: InstanceType<Settlement>, population: number) {
    this.population = population;
    this.save();
  }
  @instanceMethod
  public updateEmail(this: InstanceType<Settlement>, email: string) {
    this.email = email;
    this.save();
  }
  @instanceMethod
  public updateCellphone(this: InstanceType<Settlement>, cellphone: string) {
    this.cellphone = cellphone;
    this.save();
  }
}

export default Settlement;
