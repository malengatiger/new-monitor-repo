"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
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
    }
}
exports.AppExpressRoutes = AppExpressRoutes;
//# sourceMappingURL=app_routes.js.map