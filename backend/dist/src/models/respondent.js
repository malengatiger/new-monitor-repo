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
var RespondentType;
(function (RespondentType) {
    RespondentType["Administrator"] = "Administrator";
    RespondentType["Official"] = "Official";
    RespondentType["Executive"] = "Executive";
    RespondentType["Monitor"] = "Monitor";
    RespondentType["Citizen"] = "Citizen";
})(RespondentType || (RespondentType = {}));
class Respondent extends typegoose_1.Typegoose {
    //
    static findByUserID(userID) {
        return this.findOne({ userID });
    }
    static findByUserType(userType) {
        return this.find({ userType });
    }
}
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "firstName", void 0);
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "email", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "cellphone", void 0);
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "lastName", void 0);
__decorate([
    typegoose_1.prop({ index: true, trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "respondentID", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "fcmToken", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Respondent.prototype, "gender", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
    __metadata("design:type", String)
], Respondent.prototype, "respondentType", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Respondent.prototype, "created", void 0);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Respondent, "findByUserID", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Respondent, "findByUserType", null);
exports.default = Respondent;
//# sourceMappingURL=respondent.js.map