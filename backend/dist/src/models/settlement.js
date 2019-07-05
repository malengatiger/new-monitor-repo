"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
const typegoose_1 = require("typegoose");
class Settlement extends typegoose_1.Typegoose {
    static findByName(settlementName) {
        console.log("#####  🥦  🥦  🥦 Finding Settlement by name:  💦  💦  💦  :: 🥦 " +
            name);
        return this.findOne({ settlementName });
    }
    static findBySettlementId(settlementId) {
        console.log("#####  🥦  🥦  🥦 Finding Settlement by ID:  💦  💦  💦  :: 🥦 " +
            settlementId);
        return this.findOne({ settlementId });
    }
    updatePopulation(population) {
        this.population = population;
        this.save();
    }
    updateEmail(email) {
        this.email = email;
        this.save();
    }
    updateCellphone(cellphone) {
        this.cellphone = cellphone;
        this.save();
    }
}
__decorate([
    typegoose_1.prop({ required: true, unique: true, trim: true }),
    __metadata("design:type", String)
], Settlement.prototype, "settlementName", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Settlement.prototype, "email", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Settlement.prototype, "cellphone", void 0);
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Settlement.prototype, "countryID", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Settlement.prototype, "settlementId", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", Object)
], Settlement.prototype, "position", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Settlement.prototype, "nearestCities", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", String)
], Settlement.prototype, "countryName", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: 0 }),
    __metadata("design:type", Number)
], Settlement.prototype, "population", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Settlement.prototype, "created", void 0);
__decorate([
    typegoose_1.instanceMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], Settlement.prototype, "updatePopulation", null);
__decorate([
    typegoose_1.instanceMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Settlement.prototype, "updateEmail", null);
__decorate([
    typegoose_1.instanceMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Settlement.prototype, "updateCellphone", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Settlement, "findByName", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Settlement, "findBySettlementId", null);
exports.default = Settlement;
//# sourceMappingURL=settlement.js.map