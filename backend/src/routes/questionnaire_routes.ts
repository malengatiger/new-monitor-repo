import { Request, Response } from "express";
import { QuestionnaireHelper } from "../helpers/questionnaire_helper";
import Util from "../server/util";

export class QuestionnaireExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    QuestionnaireExpressRoutes:  💙  setting up default Questionnaire Routes ...`,
    );

    app.route("/addQuestionnaire").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addQuestionnaire requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await QuestionnaireHelper.addQuestionnaire(
          req.body.title,
          req.body.description,
          req.body.countryId,
          req.body.organizationId,
          req.body.sections,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addQuestionnaire failed");
      }
    });
    app.route("/addQuestionnaireSection").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addQuestionnaireSection requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await QuestionnaireHelper.addQuestionnaireSection(
          req.body.questionnaireId,
          req.body.section,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addQuestionnaireSection failed");
      }
    });
    app.route("/addQuestionnaireResponse").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addQuestionnaireResponse requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await QuestionnaireHelper.addQuestionnaireResponse(
          req.body.questionnaireId,
          req.body.respondentId,
          req.body.userId,
          req.body.sections,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addQuestionnaireResponse failed");
      }
    });

    app.route("/getQuestionnaires").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getQuestionnaires requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await QuestionnaireHelper.getQuestionnaires();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getQuestionnaires failed");
      }
    });
    app.route("/getQuestionnaireResponses").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getQuestionnaireResponses requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await QuestionnaireHelper.getQuestionnaireResponses(
          req.body.questionnaireId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getQuestionnaireResponses failed");
      }
    });
    app.route("/getQuestionnaireResponsesBySettlement").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getQuestionnaireResponsesBySettlement requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await QuestionnaireHelper.getQuestionnaireResponsesBySettlement(
          req.body.settlementId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getQuestionnaireResponsesBySettlement failed");
      }
    });
    app.route("/getQuestionnairesByOrganization").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getQuestionnairesByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await QuestionnaireHelper.getQuestionnairesByOrganization(
          req.body.organizationId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getQuestionnairesByOrganization failed");
      }
    });
  }
}
export default QuestionnaireExpressRoutes;
