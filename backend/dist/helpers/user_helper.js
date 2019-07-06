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
const user_1 = __importDefault(require("../models/user"));
class UserHelper {
    static onUserAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`operationType: 👽 👽 👽  ${event.operationType},  User in stream:   🍀🍎 `);
        });
    }
    static addUser(organizationId, organizationName, firstName, lastName, email, cellphone, userType, gender, countryId, countryName) {
        return __awaiter(this, void 0, void 0, function* () {
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const u = new UserModel({
                firstName,
                lastName,
                email,
                cellphone,
                userType,
                gender,
                countryId,
                countryName,
                organizationName,
                organizationId,
            });
            const m = yield u.save();
            m.userId = m.id;
            yield m.save();
            return m;
        });
    }
    static findAllUsers() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findAllUsers ....   🌀  🌀  🌀 `);
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const list = yield UserModel.find();
            return list;
        });
    }
    static findByUser(userId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByUser ....   🌀  🌀  🌀 `);
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const list = yield UserModel.findByUserId(userId);
            return list;
        });
    }
    static findByUid(uid) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByUid ....   🌀  🌀  🌀 `);
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const list = yield UserModel.findByUid(uid);
            return list;
        });
    }
    static findByEmail(email) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByEmail ....   🌀  🌀  🌀 `);
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const list = yield UserModel.findByEmail(email);
            return list;
        });
    }
    static findByOrganization(organizationId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 findByOrganization ....   🌀  🌀  🌀 `);
            const UserModel = new user_1.default().getModelForClass(user_1.default);
            const list = yield UserModel.findByOrganization(organizationId);
            return list;
        });
    }
}
exports.UserHelper = UserHelper;
//# sourceMappingURL=user_helper.js.map