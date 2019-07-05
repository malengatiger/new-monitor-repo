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
const country_helper_1 = require("../helpers/country_helper");
const util_1 = __importDefault(require("../server/util"));
class CountryExpressRoutes {
    routes(app) {
        console.log(`\n🏓🏓🏓🏓🏓    CountryExpressRoutes:  💙  setting up default Country/City Routes ...`);
        app.route("/addCountry").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /addCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            console.log(req.body);
            try {
                const result = yield country_helper_1.CountryHelper.addCountry(req.body.name, req.body.countryCode);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "addCountry failed");
            }
        }));
        app.route("/getCountries").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getCountries requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield country_helper_1.CountryHelper.getCountries();
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getCountries failed");
            }
        }));
        app.route("/addCity").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findByCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield country_helper_1.CityHelper.addCity(req.body.name, req.body.provinceName, req.body.countryId, req.body.countryName, parseFloat(req.body.latitude), parseFloat(req.body.longitude));
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findByCountry failed");
            }
        }));
        app.route("/getCities").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /getCities requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield country_helper_1.CityHelper.getCities(req.body.countryId);
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "getCities failed");
            }
        }));
        app.route("/findCitiesByLocation").post((req, res) => __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n💦  POST: /findCitiesByLocation requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`);
            try {
                const result = yield country_helper_1.CityHelper.findCitiesByLocation(parseFloat(req.body.latitude), parseFloat(req.body.longitude), parseFloat(req.body.radiusInKM));
                res.status(200).json(result);
            }
            catch (err) {
                util_1.default.sendError(res, err, "findCitiesByLocation failed");
            }
        }));
    }
}
exports.CountryExpressRoutes = CountryExpressRoutes;
exports.default = CountryExpressRoutes;
//# sourceMappingURL=country_routes.js.map