import Settlement from "../models/settlement";
import Position from "../models/position";

export class SettlementHelper {
  public static async addSettlement(
    settlementName: string,
    email: string,
    cellphone: string,
    countryId: string,
    countryName: string,
    polygon: any[],
    population: number,
  ): Promise<any> {
    const positions: Position[] = [];
    for (const p of polygon) {
      const pos = new Position();
      pos.coordinates = [p.longitude, p.latitude];
      positions.push(pos);
    }
    const settlementModel = new Settlement().getModelForClass(Settlement);
    const settlement = new settlementModel({
      settlementName,
      cellphone,
      countryId,
      countryName,
      email,
      polygon: positions,
      population,
    });
    const m = await settlement.save();
    m.settlementId = m.id;
    await m.save();
    console.log(
      `\n\n💙💚💛  SettlementHelper: Yebo Gogo!!!! - MongoDB has saved ${settlementName} !!!!!  💙💚💛`,
    );

    console.log(m);
    return m;
  }

  public static async getSettlements(): Promise<any> {
    console.log(` 🌀 getSettlements ....   🌀  🌀  🌀 `);
    const settlementModel = new Settlement().getModelForClass(Settlement);
    const list = await settlementModel.find();
    console.log(list);
    return list;
  }
  public static async findSettlementsByCountry(
    countryId: string,
  ): Promise<any> {
    console.log(` 🌀 findSettlementsByCountry ....   🌀  🌀  🌀 `);
    const settlementModel = new Settlement().getModelForClass(Settlement);
    const list = await settlementModel.findSettlementsByCountry(countryId);
    console.log(list);
    return list;
  }
  public static async addToPolygon(
    settlementId: string,
    latitude: number,
    longitude: number,
  ): Promise<any> {
    console.log(`🌀 SettlementHelper: addToPolygon ....   🌀🌀🌀`);
    const settlementModel = new Settlement().getModelForClass(Settlement);
    // const sett = await settlementModel.findBySettlementId(settlementId).exec();

    const position = {
        type: "Point",
        coordinates: [longitude, latitude],
      };
    settlementModel.findOneAndUpdate(
        { _id: settlementId },
        { $push: { polygon: position } },
        () => (error: any, success: any) => {
          if (error) {
            console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
            console.error(error);
          } else {
            console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
            console.log(success);
          }
        },
      );
      // await sett.addToPolygon(latitude, longitude);
    const msg = `📌 📌 📌 Point added to polygon, maybe: ${new Date().toISOString()} `;
    console.log(msg);
    return {
        message: msg,
      };
    // } else {
    //   throw new Error(`Settlement not  found`);
    // }
  }

  public static async onSettlementAdded(event: any) {
    console.log(`onSettlementAdded event has occured .... 👽 👽 👽`);
    console.log(event);
    console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
  }
}
