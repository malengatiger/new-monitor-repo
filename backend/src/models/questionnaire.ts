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
import { Section } from "./interfaces";

class Questionnaire extends Typegoose {
  @staticMethod
  public static findByName(
    this: ModelType<Questionnaire> & typeof Questionnaire,
    name: string,
  ) {
    return this.find({ name });
  }
  @staticMethod
  public static findByOrganization(
    this: ModelType<Questionnaire> & typeof Questionnaire,
    organizationId: string,
  ) {
    return this.find({ organizationId });
  }
  @staticMethod
  public static findByCountry(
    this: ModelType<Questionnaire> & typeof Questionnaire,
    countryId: string,
  ) {
    return this.find({ countryId });
  }
  @staticMethod
  public static findBySettlement(
    this: ModelType<Questionnaire> & typeof Questionnaire,
    settlementId: string,
  ) {
    return this.find({ settlementId });
  }
  @staticMethod
  public static findByDate(
    this: ModelType<Questionnaire> & typeof Questionnaire,
    date: string,
  ) {
    return this.find({ created: { $gte: date } });
  }
  //
  @prop({ required: true, default: [] })
  public sections!: Section[];
  //
  @prop({ required: true, index: true, trim: true, unique: true })
  public title?: string;
  //
  @prop({ required: true })
  public description?: string;

  @prop({ required: true })
  public countryName?: string;

  @prop({ required: true, index: true, trim: true })
  public countryId?: string;
  //
  @prop({ index: true, trim: true })
  public questionnaireId?: string;
  //
  @prop({ required: true, index: true, trim: true })
  public organizationId?: string;
  //
  @prop({ required: true, index: true, trim: true })
  public organizationName?: string;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
}

export default Questionnaire;
