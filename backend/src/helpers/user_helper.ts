
import User from "../models/user";

export class UserHelper {
  public static async onUserAdded(event: any) {
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  User in stream:   🍀🍎 `,
    );
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
    countryName: string,
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
      countryName,
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
