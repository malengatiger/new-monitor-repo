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
const user_helper_1 = require("../helpers/user_helper");
const util_1 = __importDefault(require("../server/util"));
class UserExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    UserExpressRoutes:  💙  setting up default User Routes ...`);
        app.route("/addUser").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addUser requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield user_helper_1.UserHelper.addUser(req.body.firstName, req.body.lastName, req.body.email, req.body.cellphone, req.body.userType, req.body.gender, req.body.countryID, req.body.countryName);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addUser failed");
            }
        }));
        app.route("/findAllUsers").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findAllUsers requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield user_helper_1.UserHelper.findAllUsers();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findAllUsers failed");
            }
        }));
        app.route("/findByOrganization").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findByOrganization requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield user_helper_1.UserHelper.findByOrganization(req.body.countryId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findByCountry failed");
            }
        }));
    }
}
exports.UserExpressRoutes = UserExpressRoutes;
exports.default = UserExpressRoutes;
//# sourceMappingURL=user_routes.js.map