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

enum UserType {
  Administrator = "Administrator",
  Official = "Official",
  Executive = "Executive",
  Monitor = "Monitor",
  Citizen = "Citizen",
}
class User extends Typegoose {

  //
  @staticMethod
  public static findByUserID(
    this: ModelType<User> & typeof User,
    userID: string,
  ) {
    return this.findOne({ userID });
  }
  @staticMethod
  public static findByUserType(
    this: ModelType<User> & typeof User,
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
  public userID!: string;
  //
  @prop({ trim: true })
  public associationID?: string;
  //
  @prop({ trim: true })
  public fcmToken?: string;
  //
  @prop({ trim: true })
  public gender?: string;
  //
  @prop({ trim: true })
  public countryID?: string;
  //
  @prop({ trim: true })
  public associationName?: string;
  //
  @prop({ required: true })
  public userType!: UserType;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created!: string;
}

export default User;
