import { Request, Response } from "express";
import { SettlementHelper } from "../helpers/settlement_helper";
import Util from "../server/util";

export class SettlementExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    SettlementExpressRoutes:  💙  setting up default Settlement Routes ...`,
    );

    app.route("/addSettlement").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addSettlement requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await SettlementHelper.addSettlement(
          req.body.settlementName,
          req.body.email,
          req.body.cellphone,
          req.body.countryID,
          req.body.countryName,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addSettlement failed");
      }
    });

    app.route("/getSettlements").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getSettlements requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await SettlementHelper.getSettlements();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getSettlements failed");
      }
    });
  }
}
export default SettlementExpressRoutes;
