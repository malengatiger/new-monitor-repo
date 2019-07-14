"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const constants_1 = __importDefault(require("../server/constants"));
const settlement_helper_1 = require("../helpers/settlement_helper");
const user_helper_1 = require("../helpers/user_helper");
class MongoListeners {
    static listen(client) {
        console.log(`\n🔆🔆🔆  MongoListeners: 🧡🧡🧡  listening to changes in collections ... 👽 👽 👽\n`);
        const users = client.connection.collection(constants_1.default.USERS);
        const settlements = client.connection.collection(constants_1.default.SETTLEMENTS);
        //
        const settlementStream = settlements.watch();
        const usersStream = users.watch({ fullDocument: 'updateLookup' });
        settlementStream.on("change", (event) => {
            console.log(`\n🔆🔆🔆🔆   🍎  settlementStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`);
            console.log(event);
            settlement_helper_1.SettlementHelper.onSettlementAdded(event);
        });
        usersStream.on("change", (event) => {
            console.log(`\n🔆🔆🔆🔆   🍎  usersStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`);
            console.log(event);
            user_helper_1.UserHelper.onUserAdded(event);
        });
    }
}
exports.default = MongoListeners;
//# sourceMappingURL=listeners.js.map