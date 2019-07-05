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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const typegoose_1 = require("typegoose");
const position_1 = __importDefault(require("./position"));
var ProjectType;
(function (ProjectType) {
    ProjectType["Infrastructure"] = "Infrastructure";
    ProjectType["Social"] = "Social";
    ProjectType["Educational"] = "Educational";
    ProjectType["Health"] = "Health";
    ProjectType["Other"] = "Other";
})(ProjectType || (ProjectType = {}));
class Project extends typegoose_1.Typegoose {
}
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true }),
    __metadata("design:type", String)
], Project.prototype, "name", void 0);
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true }),
    __metadata("design:type", String)
], Project.prototype, "description", void 0);
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Project.prototype, "organizationId", void 0);
__decorate([
    typegoose_1.prop({ required: true, trim: true }),
    __metadata("design:type", String)
], Project.prototype, "organizationName", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Project.prototype, "settlementId", void 0);
__decorate([
    typegoose_1.prop({ trim: true }),
    __metadata("design:type", String)
], Project.prototype, "settlementName", void 0);
__decorate([
    typegoose_1.prop({ required: false }),
    __metadata("design:type", position_1.default)
], Project.prototype, "position", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "photoUrls", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "videoUrls", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "comments", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "ratings", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Project.prototype, "created", void 0);
exports.default = Project;
//# sourceMappingURL=project.js.map