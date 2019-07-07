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
const org_helper_1 = require("../helpers/org_helper");
const util_1 = __importDefault(require("../server/util"));
class OrgExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    OrganizationExpressRoutes:  💙  setting up default Organization Routes ...`);
        app.route("/addOrganization").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield org_helper_1.OrganizationHelper.addOrganization(req.body.name, req.body.email, req.body.countryId, req.body.countryName);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addOrganization failed");
            }
        }));
        app.route("/findAllOrganizations").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findAllOrganizations requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield org_helper_1.OrganizationHelper.findAllOrganizations();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findAllOrganizations failed");
            }
        }));
        app.route("/findByCountry").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findByCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield org_helper_1.OrganizationHelper.findByCountry(req.body.countryId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findByCountry failed");
            }
        }));
        app.route("/findOrgByOrganizationId").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findOrgByOrganizationId requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield org_helper_1.OrganizationHelper.findByOrganization(req.body.organizationId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findOrgByOrganizationId failed");
            }
        }));
    }
}
exports.OrgExpressRoutes = OrgExpressRoutes;
exports.default = OrgExpressRoutes;
//# sourceMappingURL=org_routes.js.map