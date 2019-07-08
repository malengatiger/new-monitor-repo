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
const project_helper_1 = require("../helpers/project_helper");
const util_1 = __importDefault(require("../server/util"));
class ProjectExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    ProjectExpressRoutes:  💙  setting up default Project Routes ...`);
        app.route("/addProject").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addProject(req.body.name, req.body.description, req.body.organizationId, req.body.organizationName, req.body.settlements, req.body.positions);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addProject failed");
            }
        }));
        app.route("/addSettlementToProject").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addSettlementToProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addSettlementToProject(req.body.projectId, req.body.settlementId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addSettlementToProject failed");
            }
        }));
        app.route("/addPositionsToProject").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addPositionsToProject requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addPositionsToProject(req.body.projectId, req.body.positions);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addPositionsToProject failed");
            }
        }));
        app.route("/addProjectPhoto").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addProjectPhoto requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addProjectPhoto(req.body.projectId, req.body.url, req.body.comment, req.body.latitude, req.body.longitude, req.body.userId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addProjectPhoto failed");
            }
        }));
        app.route("/addProjectVideo").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addProjectVideo requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addProjectVideo(req.body.projectId, req.body.url, req.body.comment, req.body.latitude, req.body.longitude, req.body.userId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addProjectVideo failed");
            }
        }));
        app.route("/addProjectRating").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addProjectRating requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield project_helper_1.ProjectHelper.addProjectRating(req.body.projectId, req.body.rating, req.body.comment, req.body.latitude, req.body.longitude, req.body.userId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addProjectRating failed");
            }
        }));
        app.route("/findAllProjects").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findAllProjects requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield project_helper_1.ProjectHelper.findAllProjects();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findAllProjects failed");
            }
        }));
        app.route("/findProjectsByOrganization").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findProjectsByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield project_helper_1.ProjectHelper.findByOrganization(req.body.organizationId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findByOrganization failed");
            }
        }));
    }
}
exports.ProjectExpressRoutes = ProjectExpressRoutes;
exports.default = ProjectExpressRoutes;
//# sourceMappingURL=project_routes.js.map