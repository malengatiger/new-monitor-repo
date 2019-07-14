
import Organization from "../models/organization";
import Messaging from "../server/messaging";

export class OrganizationHelper {
  public static async onOrganizationAdded(event: any) {
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  Organization in stream:   🍀 🍎 `,
    );
    const doc = event.fullDocument;
    const data = {
      id: doc.id,
      name: doc.name,
      email: doc.email,
      organizationId: doc.organizationId,
      organizationName: doc.organizationName,
    }
    Messaging.sendOrganization(data);
  }
  public static async addOrganization(
    name: string,
    email: string,
    countryId: string,
    countryName: string,
    
  ): Promise<any> {
    const OrganizationModel = new Organization().getModelForClass(Organization);
    const u = new OrganizationModel({
      name,
      email,
      countryId,
      countryName,
    });
    const m = await u.save();
    m.organizationId = m.id;
    await m.save();
    return m;
  }

  public static async findAllOrganizations(): Promise<any> {
    console.log(` 🌀 getOrganizations ....   🌀  🌀  🌀 `);
    const organizationModel = new Organization().getModelForClass(Organization);
    const list = await organizationModel.find();
    return list;
  }
  public static async findByOrganization(organizationId: string): Promise<any> {
    console.log(` 🌀 findByOrganization ....   🌀  🌀  🌀 `);
    const organizationModel = new Organization().getModelForClass(Organization);
    const list = await organizationModel.findByOrganizationId(organizationId);
    return list;
  }
  public static async findByCountry(countryId: string): Promise<any> {
    console.log(` 🌀 findByCountry ....   🌀  🌀  🌀 `);
    const organizationModel = new Organization().getModelForClass(Organization);
    const list = await organizationModel.findByCountry(countryId);
    return list;
  }
}
