import {
  ModelType,
  prop,
  staticMethod,
  Typegoose,
} from "typegoose";

enum RespondentType {
  Administrator = "Administrator",
  Official = "Official",
  Executive = "Executive",
  Monitor = "Monitor",
  Citizen = "Citizen",
}
class Respondent extends Typegoose {

  //
  @staticMethod
  public static findByUserID(
    this: ModelType<Respondent> & typeof Respondent,
    userID: string,
  ) {
    return this.findOne({ userID });
  }
  @staticMethod
  public static findByUserType(
    this: ModelType<Respondent> & typeof Respondent,
    userType: string,
  ) {
    return this.find({ userType });
  }
  //
  @prop({ required: true, trim: true })
  public firstName!: string;
  //
  @prop({ required: true, trim: true })
  public email!: string;
  //
  @prop({ trim: true })
  public cellphone!: string;
  //
  @prop({ required: true, trim: true })
  public lastName!: string;
  //
  @prop({ index: true, trim: true })
  public respondentID!: string;
  
  @prop({ trim: true })
  public fcmToken?: string;
  //
  @prop({ trim: true })
  public gender?: string;
  //
  
  @prop({ required: true })
  public respondentType!: RespondentType;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created!: string;
}

export default Respondent;
