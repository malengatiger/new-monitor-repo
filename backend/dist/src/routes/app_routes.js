"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const util_1 = __importDefault(require("../server/util"));
const migrator_1 = __importDefault(require("../migration/migrator"));
class AppExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    AppExpressRoutes:  💙  setting up default home routes ...`);
        app.route("/").get((req, res) => {
            const msg = `🧡 💛  Hello World from HDA Monitor,🧡 💛  independence is here!!! 💙 IBM Cloud is UP! 💙 GCP is UP!  💙 Azure is UP!   🌽🌽🌽 ${new Date().toISOString()} 🌽🌽🌽`;
            console.log(msg);
            res.status(200).json({
                message: msg,
            });
        });
        app.route("/ping").get((req, res) => {
            console.log(`\n\n💦  HDA Monitor has been pinged!! IBM Cloud is UP!💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log("GET /ping", JSON.stringify(req.headers, null, 2));
            res.status(200).json({
                message: `🔆🔆🔆 SoldierBoy, aka HDA Monitor pinged !!! 💙 IBM Cloud is UP! 💙 GCP is UP! 💙  Azure is UP! 💙 ${new Date()}  💙  ${new Date().toISOString()}  🔆 🔆 🔆 🔆 🔆 `,
            });
        });
        app.route("/migrator").get((req, res) => {
            console.log(`\n\n💦  HDA Monitor Migrator requested! ... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                migrator_1.default.start();
                const msg = `🔆🔆🔆 Migrator started ... 💙💙 check mongo database for data after a bit💙💙 ${new Date().toISOString()}  🔆 🔆 🔆 🔆 🔆 `;
                console.log(msg);
                res.status(200).json({
                    message: msg,
                });
            }
            catch (e) {
                util_1.default.sendError(res, e, 'Migrator failed');
            }
        });
    }
}
exports.AppExpressRoutes = AppExpressRoutes;
//# sourceMappingURL=app_routes.js.map