import { Request, Response } from "express";
import Util from "../server/util";
import Migrator from "../migration/migrator";

export class AppExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    AppExpressRoutes:  💙  setting up default home routes ...`,
    );
    app.route("/").get((req: Request, res: Response) => {
      const msg = `🧡 💛 Digital Monitoring Platform says 💙 HELLO 💙!!! 🧡 💛  independence is here!!! 💙 IBM Cloud is UP! 💙 GCP is UP!  💙 Azure is UP!   🍎 🌽🌽🌽 ${new Date().toISOString()} 🌽🌽🌽 🍎`;
      console.log(msg);
      res.status(200).json({
        message: msg,
      });
    });
    app.route("/ping").get((req: Request, res: Response) => {
      console.log(
        `\n\n💦  Digital Monitoring Platform has been pinged!! IBM Cloud is UP!💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log("GET /ping", JSON.stringify(req.headers, null, 2));
      res.status(200).json({
        message: `🔆🔆🔆 💙💙💙  🍎 Digital Monitoring Platform 🍎 pinged !!! 💙 IBM Cloud is UP! 💙 GCP is UP! 💙  Azure is UP! 💙 ${new Date()}  💙  ${new Date().toISOString()}  🔆 🍎🔆🍎 🔆🍎 🔆🍎 🔆🍎 `,
      });
    });
    app.route("/migrator").get((req: Request, res: Response) => {
      console.log(
        `\n\n💦  Digital Monitoring Platform Migrator requested! ... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        Migrator.start();
        const msg = `🔆🔆🔆 Migrator started ... 💙💙 check mongo database for data after a bit💙💙 ${new Date().toISOString()}  🔆 🔆 🔆 🔆 🔆 `;
        console.log(msg);
        res.status(200).json({
        message: msg,
      });
      } catch (e) {
        Util.sendError(res, e, 'Migrator failed');
      }
    });
  }
}
