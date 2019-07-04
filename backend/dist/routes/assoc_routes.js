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
const association_helper_1 = require("../helpers/association_helper");
const util_1 = __importDefault(require("../util"));
class AssociationExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    AssociationExpressRoutes:  💙  setting up default Association Routes ...`);
        app.route("/addAssociation").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /associations requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield association_helper_1.AssociationHelper.addAssociation(req.body.associationName, req.body.email, req.body.cellphone, req.body.countryID, req.body.countryName);
                console.log("about to return result from Helper ............");
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addAssociation failed");
            }
        }));
        app.route("/getAssociations").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getAssociations requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield association_helper_1.AssociationHelper.getAssociations();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getAssociations failed");
            }
        }));
    }
}
exports.AssociationExpressRoutes = AssociationExpressRoutes;
exports.default = AssociationExpressRoutes;
//# sourceMappingURL=assoc_routes.js.map