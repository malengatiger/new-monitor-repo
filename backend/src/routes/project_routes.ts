import { Request, Response } from "express";
import { ProjectHelper } from "../helpers/project_helper";
import Util from "../server/util";

export class ProjectExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    ProjectExpressRoutes:  💙  setting up default Project Routes ...`,
    );

    app.route("/addProject").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await ProjectHelper.addProject(
          req.body.name,
          req.body.description,
          req.body.organizationId,
          req.body.organizationName,
          req.body.settlements,
          req.body.positions,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addProject failed");
      }
    });
    app.route("/addSettlementToProject").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addSettlementToProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await ProjectHelper.addSettlementToProject(
          req.body.projectId,
          req.body.settlementId,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addSettlementToProject failed");
      }
    });
    app.route("/addPositionsToProject").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addPositionsToProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await ProjectHelper.addPositionsToProject(
          req.body.projectId,
          req.body.positions,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addPositionsToProject failed");
      }
    });

    app.route("/findAllProjects").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findAllProjects requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await ProjectHelper.findAllProjects();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findAllProjects failed");
      }
    });
    app.route("/findByOrganization").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await ProjectHelper.findByOrganization(
          req.body.organizationId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findByOrganization failed");
      }
    });
  }
}
export default ProjectExpressRoutes;
