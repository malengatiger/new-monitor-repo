"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const questionnaire_helper_1 = require("../helpers/questionnaire_helper");
const util_1 = __importDefault(require("../server/util"));
class QuestionnaireExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    QuestionnaireExpressRoutes:  💙  setting up default Questionnaire Routes ...`);
        app.route("/addQuestionnaire").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addQuestionnaire requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.addQuestionnaire(req.body.title, req.body.description, req.body.countryId, req.body.organizationId, req.body.sections);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addQuestionnaire failed");
            }
        }));
        app.route("/addQuestionnaireSection").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addQuestionnaireSection requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.addQuestionnaireSection(req.body.questionnaireId, req.body.section);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addQuestionnaireSection failed");
            }
        }));
        app.route("/addQuestionnaireResponse").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addQuestionnaireResponse requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.addQuestionnaireResponse(req.body.questionnaireId, req.body.respondentId, req.body.userId, req.body.sections);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addQuestionnaireResponse failed");
            }
        }));
        app.route("/getQuestionnaires").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getQuestionnaires requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.getQuestionnaires();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getQuestionnaires failed");
            }
        }));
        app.route("/getQuestionnaireResponses").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getQuestionnaireResponses requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.getQuestionnaireResponses(req.body.questionnaireId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getQuestionnaireResponses failed");
            }
        }));
        app.route("/getQuestionnaireResponsesBySettlement").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getQuestionnaireResponsesBySettlement requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.getQuestionnaireResponsesBySettlement(req.body.settlementId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getQuestionnaireResponsesBySettlement failed");
            }
        }));
        app.route("/getQuestionnairesByOrganization").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getQuestionnairesByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield questionnaire_helper_1.QuestionnaireHelper.getQuestionnairesByOrganization(req.body.organizationId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getQuestionnairesByOrganization failed");
            }
        }));
    }
}
exports.QuestionnaireExpressRoutes = QuestionnaireExpressRoutes;
exports.default = QuestionnaireExpressRoutes;
//# sourceMappingURL=questionnaire_routes.js.map