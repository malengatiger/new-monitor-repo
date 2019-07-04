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
const port = process.env.PORT || "8000";
const password = process.env.MONGODB_PASSWORD || "aubrey3";
const user = process.env.MONGODB_USER || "aubs";
const appName = "Monitor MongoDB API";
const mongoConnection = `mongodb+srv://${user}:${password}@ar001-1xhdt.mongodb.net/monitordb?retryWrites=true`;
// import MongoListeners from "./listeners";
console.log(`\n🧡 💛   Monitor MongoDB API ... ☘️  starting  ☘️  ${new Date().toISOString()}   🧡 💛\n`);
mongoose_1.default
    .connect(mongoConnection, {
    useNewUrlParser: true,
})
    .then((client) => {
    console.log(`\n🔆🔆🔆🔆🔆🔆  Mongo connected ... 🔆🔆🔆  💛  ${new Date()}  💛 💛`);
    console.log(`\n🍎🍎  ${appName} :: database:  ☘️  client version: ${client.version}  ☘️  is OK   🍎🍎 `);
    console.log(`🍎🍎🍎  MongoDB config ...${JSON.stringify(mongoose_1.default.connection.config)}`);
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
class MonitorApp {
    constructor() {
        this.appRoutes = new app_routes_1.AppExpressRoutes();
        console.log(`\n🦀 🦀  🥦 Inside MonitorWebAPI constructor ...`);
        this.app = server_1.app;
        this.port = port;
        this.initializeMiddleware();
        this.appRoutes.routes(this.app);
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