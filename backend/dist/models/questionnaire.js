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
class Questionnaire extends typegoose_1.Typegoose {
    static findByName(name) {
        return this.find({ name });
    }
    static findByOrganization(organizationId) {
        return this.find({ organizationId });
    }
    static findByCountry(countryId) {
        return this.find({ countryId });
    }
    static findBySettlement(settlementId) {
        return this.find({ settlementId });
    }
    static findByDate(date) {
        return this.find({ created: { $gte: date } });
    }
}
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Questionnaire.prototype, "questions", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true, unique: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "name", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "title", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "description", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "countryName", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "countryId", void 0);
__decorate([
    typegoose_1.prop({ index: true, trim: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "questionnaireId", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "organizationId", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true }),
    __metadata("design:type", String)
], Questionnaire.prototype, "organizationName", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Questionnaire.prototype, "created", void 0);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Questionnaire, "findByName", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Questionnaire, "findByOrganization", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Questionnaire, "findByCountry", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Questionnaire, "findBySettlement", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Questionnaire, "findByDate", null);
exports.default = Questionnaire;
//# sourceMappingURL=questionnaire.js.map