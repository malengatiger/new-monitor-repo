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
class QuestionnaireResponse extends typegoose_1.Typegoose {
    static findByQuestionnaire(questionnaireId) {
        return this.find({ questionnaireId });
    }
    static findBySettlement(settlementId) {
        return this.find({ 'settlements.settlementId': settlementId });
    }
    static findByRespondent(respondentId) {
        return this.find({ respondentId });
    }
    static findByDate(date) {
        return this.find({ created: { $gte: date } });
    }
}
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], QuestionnaireResponse.prototype, "sections", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true }),
    __metadata("design:type", String)
], QuestionnaireResponse.prototype, "userId", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true }),
    __metadata("design:type", String)
], QuestionnaireResponse.prototype, "questionnaireId", void 0);
__decorate([
    typegoose_1.prop({ index: true }),
    __metadata("design:type", String)
], QuestionnaireResponse.prototype, "respondentId", void 0);
__decorate([
    typegoose_1.prop({ index: true }),
    __metadata("design:type", String)
], QuestionnaireResponse.prototype, "questionnaireResponseId", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], QuestionnaireResponse.prototype, "created", void 0);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], QuestionnaireResponse, "findByQuestionnaire", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], QuestionnaireResponse, "findBySettlement", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], QuestionnaireResponse, "findByRespondent", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], QuestionnaireResponse, "findByDate", null);
exports.default = QuestionnaireResponse;
//# sourceMappingURL=questionnaire_response.js.map