import { Request, Response } from "express";
import { OrganizationHelper } from "../helpers/org_helper";
import Util from "../server/util";

export class OrgExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    OrganizationExpressRoutes:  💙  setting up default Organization Routes ...`,
    );

    app.route("/addOrganization").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await OrganizationHelper.addOrganization(
          req.body.name,
          req.body.email,
          req.body.countryId,
          req.body.countryName,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addOrganization failed");
      }
    });

    app.route("/findAllOrganizations").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findAllOrganizations requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await OrganizationHelper.findAllOrganizations();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findAllOrganizations failed");
      }
    });
    app.route("/findByCountry").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findByCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await OrganizationHelper.findByCountry(
          req.body.countryId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findByCountry failed");
      }
    });
    app.route("/findOrgByOrganizationId").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findOrgByOrganizationId requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await OrganizationHelper.findByOrganization(
          req.body.organizationId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findOrgByOrganizationId failed");
      }
    });
  }
}
export default OrgExpressRoutes;
