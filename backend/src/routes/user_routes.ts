import { Request, Response } from "express";
import { UserHelper } from "../helpers/user_helper";
import Util from "../server/util";

export class UserExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    UserExpressRoutes:  💙  setting up default User Routes ...`,
    );

    app.route("/addUser").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addUser requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await UserHelper.addUser(
          req.body.firstName,
          req.body.lastName,
          req.body.email,
          req.body.cellphone,
          req.body.userType,
          req.body.gender,
          req.body.countryID,
          req.body.countryName,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addUser failed");
      }
    });

    app.route("/findAllUsers").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findAllUsers requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await UserHelper.findAllUsers();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findAllUsers failed");
      }
    });
    app.route("/findUsersByOrganization").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findUsersByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await UserHelper.findByOrganization(
          req.body.countryId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findUsersByOrganization failed");
      }
    });
    app.route("/findUserByUid").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findUserByUid requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await UserHelper.findByUid(
          req.body.uid,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findUserByUid failed");
      }
    });
  }
}
export default UserExpressRoutes;
