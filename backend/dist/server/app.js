"use strict";
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
const bodyParser = __importStar(require("body-parser"));
const cors_1 = __importDefault(require("cors"));
const mongoose_1 = __importDefault(require("mongoose"));
const app_routes_1 = require("../routes/app_routes");
require('dotenv').config();
const port = process.env.PORT || "8000";
const password = process.env.MONGODB_PASSWORD || "xyz";
const user = process.env.MONGODB_USER || "abc";
console.log(`password: ${password} user: ${user}`);
const appName = "Monitor MongoDB API";
const mongoConnection = `mongodb+srv://${user}:${password}@ar001-1xhdt.mongodb.net/monitordb?retryWrites=true`;
console.log(`\n🧡 💛   Monitor MongoDB API ... ☘️  starting  ☘️  ${new Date().toISOString()}   🧡 💛\n`);
mongoose_1.default
    .connect(mongoConnection, {
    useNewUrlParser: true,
})
    .then((client) => {
    console.log(`\n🔆🔆🔆🔆🔆🔆  Monitor Mongo connected ... 🔆🔆🔆  💛  ${new Date()}  💛 💛`);
    console.log(`\n🍎🍎  ${appName} :: database:  ☘️  client version: ${client.version}  ☘️  is OK   🍎🍎 `);
    console.log(`🍎🍎🍎  Monitor MongoDB config ...${JSON.stringify(mongoose_1.default.connection.config)}`);
    listeners_1.default.listen(client);
    console.log(`🍎🍎🍎  MongoDB collections listened to ...`);
    console.log(mongoose_1.default.connection.collections);
})
    .catch((err) => {
    console.error(err);
});
//
const server_1 = require("./server");
const listeners_1 = __importDefault(require("./listeners"));
const org_routes_1 = __importDefault(require("../routes/org_routes"));
const settlement_routes_1 = __importDefault(require("../routes/settlement_routes"));
const user_routes_1 = __importDefault(require("../routes/user_routes"));
const country_routes_1 = __importDefault(require("../routes/country_routes"));
const questionnaire_routes_1 = __importDefault(require("../routes/questionnaire_routes"));
const project_routes_1 = __importDefault(require("../routes/project_routes"));
class MonitorApp {
    constructor() {
        this.appRoutes = new app_routes_1.AppExpressRoutes();
        this.orgRoutes = new org_routes_1.default();
        this.stlmRoutes = new settlement_routes_1.default();
        this.userRoutes = new user_routes_1.default();
        this.countryRoutes = new country_routes_1.default();
        this.questRoutes = new questionnaire_routes_1.default();
        this.projectRoutes = new project_routes_1.default();
        console.log(`\n🦀 🦀  🥦 Inside MonitorWebAPI constructor ...`);
        this.app = server_1.app;
        this.port = port;
        this.initializeMiddleware();
        this.appRoutes.routes(this.app);
        this.orgRoutes.routes(this.app);
        this.stlmRoutes.routes(this.app);
        this.userRoutes.routes(this.app);
        this.countryRoutes.routes(this.app);
        this.questRoutes.routes(this.app);
        this.projectRoutes.routes(this.app);
        console.log(`\n🦀 🦀  🥦  MonitorWebAPI constructor : 🥦🥦🥦 Completed setting up express routes `);
    }
    initializeMiddleware() {
        console.log(`\n🥦 🥦  initializeMiddleware .... `);
        this.app.use(bodyParser.json());
        this.app.use(bodyParser.urlencoded({ extended: false }));
        this.app.use(cors_1.default());
        console.log(`\n🥦 🥦  bodyParser, cors initialized OK .... 🥦 🥦`);
    }
}
exports.default = MonitorApp;
//# sourceMappingURL=app.js.map