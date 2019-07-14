
import User from "../models/user";
import Messaging from "../server/messaging";

export class UserHelper {
  public static async onUserAdded(event: any) {
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  User in stream:   🍀🍎 `,
    );
    if (event.operationType != 'insert') {
      console.log('👽👽👽 User updated, no need to send message');
      return;
    }
    const UserModel = new User().getModelForClass(User);
    const doc = event.fullDocument;
    const u = new UserModel({
      firstName: doc.firstName,
      lastName: doc.lastName,
      email: doc.email,
      cellphone: doc.cellphone,
      userType: doc.userType,
      gender: doc.gender,
      countryId: doc.countryId,
      organizationName: doc.organizationName,
      organizationId: doc.organizationId,
    });
    await Messaging.sendUser(u);

  }
  public static async addUser(
    organizationId: string,
    organizationName:  string,
    firstName: string,
    lastName: string,
    email: string,
    cellphone: string,
    userType: string,
    gender: string,
    countryId: string,
  ): Promise<any> {
    const UserModel = new User().getModelForClass(User);
   
    const u = new UserModel({
      firstName,
      lastName,
      email,
      cellphone,
      userType,
      gender,
      countryId,
      organizationName,
      organizationId,
    });
    const m = await u.save();
    m.userId = m.id;
    await m.save();
    return m;
  }

  public static async findAllUsers(): Promise<any> {
    console.log(` 🌀 findAllUsers ....   🌀  🌀  🌀 `);
    const UserModel = new User().getModelForClass(User);
    const list = await UserModel.find();
    return list;
  }
  public static async findByUser(userId: string): Promise<any> {
    console.log(` 🌀 findByUser ....   🌀  🌀  🌀 `);
    const UserModel = new User().getModelForClass(User);
    const list = await UserModel.findByUserId(userId);
    return list;
  }
  public static async findByUid(uid: string): Promise<any> {
    console.log(` 🌀 findByUid ....   🌀  🌀  🌀 `);
    const UserModel = new User().getModelForClass(User);
    const list = await UserModel.findByUid(uid);
    return list;
  }
  public static async findByEmail(email: string): Promise<any> {
    console.log(` 🌀 findByEmail ....   🌀  🌀  🌀 `);
    const UserModel = new User().getModelForClass(User);
    const list = await UserModel.findByEmail(email);
    return list;
  }
  public static async findByOrganization(organizationId: string): Promise<any> {
    console.log(` 🌀 findByOrganization ....   🌀  🌀  🌀 `);
    const UserModel = new User().getModelForClass(User);
    const list = await UserModel.findByOrganization(organizationId);
    return list;
  }
}
