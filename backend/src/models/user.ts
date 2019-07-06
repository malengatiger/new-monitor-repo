import {
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
  OrgUser = "OrgUser",
}
class User extends Typegoose {

  //
  @staticMethod
  public static findByUserId(
    this: ModelType<User> & typeof User,
    userId: string,
  ) {
    return this.findOne({ userId });
  }
  @staticMethod
  public static findByUid(
    this: ModelType<User> & typeof User,
    uid: string,
  ) {
    return this.findOne({ uid });
  }
  @staticMethod
  public static findByUserType(
    this: ModelType<User> & typeof User,
    userType: string,
  ) {
    return this.find({ userType });
  }
  //
  @staticMethod
  public static findByOrganization(
    this: ModelType<User> & typeof User,
    organizationId: string,
  ) {
    return this.find({ organizationId });
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
  @prop({ trim: true })
  public uid!: string;
  //
  @prop({ required: true, trim: true })
  public lastName!: string;
  //
  @prop({ index: true, trim: true })
  public userId!: string;
  //
  @prop({ required: true, trim: true })
  public organizationId?: string;
  //
  @prop({ trim: true })
  public fcmToken?: string;
  //
  @prop({ trim: true })
  public gender?: string;
  //
  @prop({ trim: true })
  public countryId?: string;
  
  @prop({ required: true })
  public userType!: UserType;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created!: string;
}

export default User;
