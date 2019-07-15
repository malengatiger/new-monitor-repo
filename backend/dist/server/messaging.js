"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const admin = __importStar(require("firebase-admin"));
const constants_1 = __importDefault(require("./constants"));
console.log(`\n\n☘️ ☘️ ☘️ Loading service accounts from ☘️ .env ☘️  ...\n\n`);
const sa1 = process.env.MONITOR_CONFIG || "config 1 not found";
const ssa1 = JSON.parse(sa1);
console.log(`\n☘️ serviceAccounts listed ☘️ ok: 😍 😍 😍 ...\n\n`);
const appTo = admin.initializeApp({
    credential: admin.credential.cert(ssa1),
    databaseURL: "https://monitor-platform.firebaseio.com",
}, "appTo");
console.log(`🔑🔑🔑 appTo = admin.initializeApp done: 😍 😍 😍 ... ${appTo.name}`);
class Messaging {
    static sendUser(data) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                priority: "normal",
                timeToLive: 60 * 60,
            };
            const payload = {
                notification: {
                    title: "User Added",
                    body: JSON.stringify(data),
                },
                data: {
                    type: constants_1.default.USERS,
                    json: JSON.stringify(data),
                },
            };
            const topic = constants_1.default.USERS;
            yield appTo.messaging().sendToTopic(topic, payload, options);
            console.log(`😍😍😍😍😍😍😍😍 sendUser: user data message sent to topic: 🍎🍎 ${topic}: 🍎🍎  ${new Date().toISOString()} 🍎🍎 `);
            console.log(payload);
        });
    }
    static sendSettlement(data) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                priority: "normal",
                timeToLive: 60 * 60,
            };
            const payload = {
                notification: {
                    title: "Settlement Added or Updated",
                    body: JSON.stringify(data),
                },
                data: {
                    type: constants_1.default.SETTLEMENTS,
                    json: JSON.stringify(data),
                },
            };
            const topic = constants_1.default.SETTLEMENTS;
            yield appTo.messaging().sendToTopic(topic, payload, options);
            console.log(`😍😍😍😍😍😍😍😍 sendSettlement: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `);
            console.log(payload);
        });
    }
    static sendProject(data) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                priority: "normal",
                timeToLive: 60 * 60,
            };
            const payload = {
                notification: {
                    title: "Project Added or Updated",
                    body: JSON.stringify(data),
                },
                data: {
                    type: constants_1.default.PROJECTS,
                    json: JSON.stringify(data),
                },
            };
            const topic = constants_1.default.PROJECTS;
            yield appTo.messaging().sendToTopic(topic, payload, options);
            console.log(`😍😍😍😍😍😍😍😍 sendProject: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `);
            console.log(payload);
        });
    }
    static sendQuestionnaire(data) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                priority: "normal",
                timeToLive: 60 * 60,
            };
            const payload = {
                notification: {
                    title: "Questionnaire Added or Updated",
                    body: JSON.stringify(data),
                },
                data: {
                    type: constants_1.default.QUESTIONNAIRES,
                    json: JSON.stringify(data),
                },
            };
            const topic = constants_1.default.QUESTIONNAIRES;
            yield appTo.messaging().sendToTopic(topic, payload, options);
            console.log(`😍😍😍😍😍😍😍😍 sendQuestionnaire: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `);
            console.log(payload);
        });
    }
    static sendOrganization(data) {
        return __awaiter(this, void 0, void 0, function* () {
            const options = {
                priority: "normal",
                timeToLive: 60 * 60,
            };
            const payload = {
                notification: {
                    title: "Organization Added or Updated",
                    body: JSON.stringify(data),
                },
                data: {
                    type: constants_1.default.ORGANIZATIONS,
                    json: JSON.stringify(data),
                },
            };
            const topic = constants_1.default.ORGANIZATIONS;
            yield appTo.messaging().sendToTopic(topic, payload, options);
            console.log(`😍😍😍😍😍😍😍😍 sendOrganization: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `);
            console.log(payload);
        });
    }
}
exports.default = Messaging;
//# sourceMappingURL=messaging.js.map