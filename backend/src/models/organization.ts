import {
  ModelType,
  prop,
  Ref,
  staticMethod,
  Typegoose,
} from "typegoose";
import Settlement from "./settlement";

class Organization extends Typegoose {
  @staticMethod
  public static findByName(
    this: ModelType<Organization> & typeof Organization,
    name: string,
  ) {
    return this.findOne({ name });
  }
  @staticMethod
  public static findByOrganizationId(
    this: ModelType<Organization> & typeof Organization,
    organizationId: string,
  ) {
    return this.findOne({ organizationId });
  }
  public static findByCountry(
    this: ModelType<Organization> & typeof Organization,
    countryId: string,
  ) {
    return this.find({ countryId });
  }
   public static findAll(
    this: ModelType<Organization> & typeof Organization,
  ) {
    return this.find();
  }
  
  //
  @prop({ required: true, index: true, trim: true, unique: true })
  public name?: string;

  @prop({ required: true, index: true, trim: true, unique: true })
  public email?: string;

  @prop({ required: true, default: "ZA" })
  public countryName?: string;

  @prop({ required: true, unique: true, index: true, trim: true })
  public countryId?: string;

  @prop({ unique: true, index: true, trim: true })
  public organizationId?: string;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
}

export default Organization;
