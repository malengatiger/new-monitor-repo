import Settlement from "../models/settlement";
import Position from "../models/position";

export class SettlementHelper {
  public static async addSettlement(
    settlementName: string,
    email: string,
    cellphone: string,
    countryID: string,
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
      countryID,
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

  public static async onSettlementAdded(event: any) {
    console.log(`onSettlementAdded event has occured .... 👽 👽 👽`);
    console.log(event);
    console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
  }
}
