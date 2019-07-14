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
const organization_1 = __importDefault(require("../models/organization"));
const messaging_1 = __importDefault(require("../server/messaging"));
class OrganizationHelper {
    static onOrganizationAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`operationType: 👽 👽 👽  ${event.operationType},  Organization in stream:   🍀 🍎 `);
            const doc = event.fullDocument;
            const data = {
                id: doc.id,
                name: doc.name,
                email: doc.email,
                organizationId: doc.organizationId,
                organizationName: doc.organizationName,
            };
            messaging_1.default.sendOrganization(data);
        });
    }
    static addOrganization(name, email, countryId, countryName) {
        return __awaiter(this, void 0, void 0, function* () {
            const OrganizationModel = new organization_1.default().getModelForClass(organization_1.default);
            const u = new OrganizationModel({
                name,
                email,
                countryId,
                countryName,
            });
            const m = yield u.save();
            m.organizationId = m.id;
            yield m.save();
            return m;
        });
    }
    static findAllOrganizations() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getOrganizations ....   🌀  🌀  🌀 `);
            const organizationModel = new organization_1.default().getModelForClass(organization_1.default);
            const list = yield organizationModel.find();
            return list;
        });
    }
    static findByOrganization(organizationId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByOrganization ....   🌀  🌀  🌀 `);
            const organizationModel = new organization_1.default().getModelForClass(organization_1.default);
            const list = yield organizationModel.findByOrganizationId(organizationId);
            return list;
        });
    }
    static findByCountry(countryId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByCountry ....   🌀  🌀  🌀 `);
            const organizationModel = new organization_1.default().getModelForClass(organization_1.default);
            const list = yield organizationModel.findByCountry(countryId);
            return list;
        });
    }
}
exports.OrganizationHelper = OrganizationHelper;
//# sourceMappingURL=org_helper.js.map