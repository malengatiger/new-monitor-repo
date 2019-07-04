import {
  instanceMethod,
  InstanceType,
  ModelType,
  prop,
  staticMethod,
  Typegoose,
} from "typegoose";
import City from "./city";

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
  public countryID?: string;
  //
  @prop({ required: true, trim: true })
  public settlementId!: string;
  //
  @prop({ required: true })
  public position!: Position;
  //
  @prop({ required: true, default: [] })
  public nearestCities!: City[];
  //
  @prop({ required: true })
  public countryName?: string;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;

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
