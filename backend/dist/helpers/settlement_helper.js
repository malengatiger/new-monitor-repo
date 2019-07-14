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
const position_1 = __importDefault(require("../models/position"));
const messaging_1 = __importDefault(require("../server/messaging"));
class SettlementHelper {
    static addSettlement(settlementName, email, cellphone, countryId, countryName, polygon, population) {
        return __awaiter(this, void 0, void 0, function* () {
            const positions = [];
            if (polygon) {
                for (const p of polygon) {
                    const pos = new position_1.default();
                    pos.coordinates = [p.longitude, p.latitude];
                    positions.push(pos);
                }
            }
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            const settlement = new settlementModel({
                settlementName,
                cellphone,
                countryId,
                countryName,
                email,
                polygon: positions,
                population,
            });
            const m = yield settlement.save();
            m.settlementId = m.id;
            yield m.save();
            console.log(`\n\n💙💚💛  SettlementHelper: Yebo Gogo!!!! - MongoDB has saved ${settlementName} !!!!!  💙💚💛`);
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
    static findSettlementsByCountry(countryId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findSettlementsByCountry ....   🌀  🌀  🌀 `);
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            const list = yield settlementModel.findSettlementsByCountry(countryId);
            console.log(list);
            return list;
        });
    }
    static addToPolygon(settlementId, latitude, longitude) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`🌀 SettlementHelper: addToPolygon ....   🌀🌀🌀`);
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            // const sett = await settlementModel.findBySettlementId(settlementId).exec();
            const position = {
                type: "Point",
                coordinates: [longitude, latitude],
            };
            settlementModel.findOneAndUpdate({ _id: settlementId }, { $push: { polygon: position } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
            // await sett.addToPolygon(latitude, longitude);
            const msg = `📌 📌 📌 Point added to polygon, maybe: ${new Date().toISOString()} `;
            console.log(msg);
            return {
                message: msg,
            };
            // } else {
            //   throw new Error(`Settlement not  found`);
            // }
        });
    }
    static onSettlementAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`onSettlementAdded event has occured .... 👽 👽 👽`);
            console.log(event);
            console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
            const doc = event.fullDocument;
            const data = {
                settlementId: doc.settlementId,
                id: doc.id,
                settlementName: doc.settlementName,
                countryId: doc.countryId,
                countryName: doc.countryName,
            };
            yield messaging_1.default.sendSettlement(data);
        });
    }
}
exports.SettlementHelper = SettlementHelper;
//# sourceMappingURL=settlement_helper.js.map