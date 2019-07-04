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
const settlement_helper_1 = require("../helpers/settlement_helper");
const util_1 = __importDefault(require("../server/util"));
class SettlementExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    SettlementExpressRoutes:  💙  setting up default Settlement Routes ...`);
        app.route("/addSettlement").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addSettlement requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield settlement_helper_1.SettlementHelper.addSettlement(req.body.settlementName, req.body.email, req.body.cellphone, req.body.countryID, req.body.countryName);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addSettlement failed");
            }
        }));
        app.route("/getSettlements").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getSettlements requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield settlement_helper_1.SettlementHelper.getSettlements();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getSettlements failed");
            }
        }));
    }
}
exports.SettlementExpressRoutes = SettlementExpressRoutes;
exports.default = SettlementExpressRoutes;
//# sourceMappingURL=settlement_routes.js.map