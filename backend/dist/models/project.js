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
const typegoose_1 = require("typegoose");
const position_1 = __importDefault(require("./position"));
const settlement_1 = __importDefault(require("./settlement"));
var ProjectType;
(function (ProjectType) {
    ProjectType["Infrastructure"] = "Infrastructure";
    ProjectType["Social"] = "Social";
    ProjectType["Educational"] = "Educational";
    ProjectType["Health"] = "Health";
    ProjectType["Other"] = "Other";
})(ProjectType || (ProjectType = {}));
class Project extends typegoose_1.Typegoose {
    static findByOrganization(organizationId) {
        return this.find({ organizationId });
    }
    static findByProjectId(projectId) {
        return this.findOne({ projectId });
    }
    //
    addSettlement(projectId, settlementId) {
        return __awaiter(this, void 0, void 0, function* () {
            const proj = this.findOne({ projectId }).exec();
            const settlementModel = new settlement_1.default().getModelForClass(settlement_1.default);
            const stlmt = settlementModel.findBySettlementId(settlementId);
            if (proj && stlmt) {
                proj.settlements.push({
                    settlementId: stlmt.settlementId,
                    settlementName: stlmt.settlementName,
                });
                yield proj.save();
                const msg = `settlement ${stlmt.settlementName} added to project ${proj.name}`;
                console.log(msg);
                return {
                    message: msg,
                };
            }
            else {
                const msg = `missing or invalid data`;
                console.error(msg);
                throw new Error(msg);
            }
        });
    }
    addPositions(projectId, positions) {
        return __awaiter(this, void 0, void 0, function* () {
            const proj = this.findOne({ projectId }).exec();
            if (proj) {
                const list = [];
                positions.forEach((p) => {
                    const pos = new position_1.default();
                    pos.coordinates = [p.longitude, p.latitude];
                    list.push(pos);
                });
                yield proj.save();
                const msg = `${list.length} positions added to project ${proj.name}`;
                console.log(msg);
                return {
                    message: msg,
                };
            }
            else {
                const msg = `missing or invalid data`;
                console.error(msg);
                throw new Error(msg);
            }
        });
    }
}
__decorate([
    typegoose_1.prop({ index: true, trim: true }),
    __metadata("design:type", String)
], Project.prototype, "projectId", void 0);
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
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "settlements", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "nearestCities", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: [] }),
    __metadata("design:type", Array)
], Project.prototype, "positions", void 0);
__decorate([
    typegoose_1.prop({ required: true }),
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
], Project.prototype, "ratings", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Project.prototype, "created", void 0);
__decorate([
    typegoose_1.instanceMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", Promise)
], Project.prototype, "addSettlement", null);
__decorate([
    typegoose_1.instanceMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Array]),
    __metadata("design:returntype", Promise)
], Project.prototype, "addPositions", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Project, "findByOrganization", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Project, "findByProjectId", null);
exports.default = Project;
//# sourceMappingURL=project.js.map