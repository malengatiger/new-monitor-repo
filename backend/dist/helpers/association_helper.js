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
const settlement_1 = __importDefault(require("../models/settlement"));
class SettlementHelper {
    static addSettlement(settlementName, email, cellphone, countryID, countryName) {
        return __awaiter(this, void 0, void 0, function* () {
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            const settlement = new settlementModel({
                settlementName,
                cellphone,
                countryID,
                countryName,
                email,
            });
            const m = yield settlement.save();
            m.settlementId = m.id;
            yield m.save();
            console.log(`\n\n💙💚💛   SettlementHelper: Yebo Gogo!!!! - MongoDB has saved ${settlementName} !!!!!  💙💚💛`);
            console.log(m);
            return m;
        });
    }
    static getSettlements() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getSettlements ....   🌀  🌀  🌀 `);
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            const list = yield settlementModel.find();
            console.log(list);
            return list;
        });
    }
    static onSettlementAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`onSettlementAdded event has occured .... 👽 👽 👽`);
            console.log(event);
            console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
        });
    }
}
exports.SettlementHelper = SettlementHelper;
//# sourceMappingURL=association_helper.js.map