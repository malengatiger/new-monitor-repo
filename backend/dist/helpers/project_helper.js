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
    static addSettlementToProject(projectId, settlementId, settlementName) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const m = {
                settlementId,
                settlementName,
            };
            projectModel.findOneAndUpdate({ _id: projectId }, { $push: { settlements: m } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
            const u = yield projectModel.findByProjectId(projectId).exec();
            return u;
        });
    }
    static addPositionToProject(projectId, latitude, longitude) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            projectModel.findOneAndUpdate({ _id: projectId }, { $push: { positions: position } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
            const u = yield projectModel.findByProjectId(projectId).exec();
            return u;
            return u;
        });
    }
    static addProjectPhoto(projectId, url, latitude, longitude, userId) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            const m = {
                url,
                position,
                created: new Date().toISOString(),
                userId,
            };
            projectModel.findOneAndUpdate({ _id: projectId }, { $push: { photoUrls: m } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
            const u = yield projectModel.findByProjectId(projectId).exec();
            return u;
        });
    }
    static addProjectVideo(projectId, url, comment, latitude, longitude, userId) {
        return __awaiter(this, void 0, void 0, function* () {
            const projectModel = new project_1.default().getModelForClass(project_1.default);
            const u = yield projectModel.findByProjectId(projectId).exec();
            const position = new position_1.default();
            position.coordinates = [longitude, latitude];
            const m = {
                url,
                position,
                userId,
                comment,
            };
            projectModel.findOneAndUpdate({ _id: projectId }, { $push: { videoUrls: m } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
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
            const m = {
                rating,
                created: new Date().toISOString(),
                position,
                userId,
                comment,
            };
            projectModel.findOneAndUpdate({ _id: projectId }, { $push: { ratings: m } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
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