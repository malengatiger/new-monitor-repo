import {
  arrayProp,
  instanceMethod,
  InstanceType,
  ModelType,
  prop,
  Ref,
  staticMethod,
  Typegoose,
} from "typegoose";
import Settlement from "./settlement";

class Country extends Typegoose {
  @staticMethod
  public static findByName(
    this: ModelType<Country> & typeof Country,
    name: string,
  ) {
    console.log(
      "#####  🥦  🥦  🥦 Finding route(s) by name:  💦  💦  💦  :: 🥦 " + name
    );
    return this.findOne({ name });
    // coulf be list, routes can have same or similar names for each association
  }
  @staticMethod
  public static findByCountryId(
    this: ModelType<Country> & typeof Country,
    countryId: string,
  ) {
    return this.findOne({ countryId });
  }
  //
  @prop({ required: true, index: true, trim: true, unique: true })
  public name?: string;

  @prop({ required: true, default: "TBD" })
  public countryCode?: string;

  @prop({ unique: true, index: true, trim: true })
  public countryId?: string;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //

}

export default Country;
