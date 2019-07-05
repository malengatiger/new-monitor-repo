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
const project_1 = __importDefault(require("../models/project"));
const position_1 = __importDefault(require("../models/position"));
class ProjectHelper {
    static onProjectAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`operationType: 👽 👽 👽  ${event.operationType},  Project in stream:   🍀 🍎 `);
        });
    }
    static addProject(name, description, organizationId, organizationName, settlements, positions) {
        return __awaiter(this, void 0, void 0, function* () {
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const u = new ProjectModel({
                name,
                description,
                organizationId,
                organizationName,
                settlements,
                positions,
            });
            const m = yield u.save();
            m.projectId = m.id;
            yield m.save();
            return m;
        });
    }
    static addSettlementToProject(projectId, settlementId) {
        return __awaiter(this, void 0, void 0, function* () {
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield ProjectModel.findByProjectId(projectId).exec();
            yield u.addSettlement(projectId, settlementId);
            return u;
        });
    }
    static addPositionsToProject(projectId, positions) {
        return __awaiter(this, void 0, void 0, function* () {
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield ProjectModel.findByProjectId(projectId).exec();
            yield u.addPositions(projectId, positions);
            return u;
        });
    }
    static addProjectPhoto(projectId, url, comment, latitude, longitude, userId) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield projectModel.findByProjectId(projectId).exec();
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            yield u.photoUrls.push({
                url,
                comment,
                position,
                userId,
            });
            yield u.save();
            return {
                message: `Photo added to project`,
            };
        });
    }
    static addProjectVideo(projectId, url, comment, latitude, longitude, userId) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield projectModel.findByProjectId(projectId).exec();
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            yield u.videoUrls.push({
                url,
                comment,
                position,
                userId,
            });
            yield u.save();
            return {
                message: `Video added to project`,
            };
        });
    }
    static addProjectRating(projectId, rating, comment, latitude, longitude, userId) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield projectModel.findByProjectId(projectId).exec();
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            yield u.ratings.push({
                rating,
                comment,
                position,
                userId,
            });
            yield u.save();
            return {
                message: `Rating added to project`,
            };
        });
    }
    static findAllProjects() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getProjects ....   🌀  🌀  🌀 `);
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const list = yield ProjectModel.find();
            return list;
        });
    }
    static findByProject(ProjectId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByProject ....   🌀  🌀  🌀 `);
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const list = yield ProjectModel.findByProjectId(ProjectId);
            return list;
        });
    }
    static findByOrganization(organizationId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByCountry ....   🌀  🌀  🌀 `);
            const ProjectModel = new project_1.default().getModelForClass(project_1.default);
            const list = yield ProjectModel.findByOrganization(organizationId);
            return list;
        });
    }
}
exports.ProjectHelper = ProjectHelper;
//# sourceMappingURL=project_helper.js.map