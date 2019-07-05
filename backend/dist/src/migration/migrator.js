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
const country_helper_1 = require("./../helpers/country_helper");
const z = "\n";
const cities_json_1 = __importDefault(require("../../cities.json"));
console.log(cities_json_1.default);
class Migrator {
    static start() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n......Migrator is starting up ... ❤️  ❤️  ❤️  ....\n`);
            const start = new Date().getTime();
            yield this.migrateMzantsi();
            const end = new Date().getTime();
            const msg = `❤️️ ❤️ ❤️   Migrator has finished the job!  ❤️  ${(end -
                start) /
                1000} seconds elapsed  ❤️ ❤️ ❤️`;
            console.log(msg);
            return {
                migrator: msg,
                xdate: new Date().toISOString(),
            };
        });
    }
    static migrateMzantsi() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n🍎  Migrating mzantsi ........................`);
            const country = yield country_helper_1.CountryHelper.addCountry("South Africa", "ZA");
            console.log(`\n🔑 🔑 🔑   country migrated: ${country.name}`);
            yield this.migrateCities(country);
        });
    }
    static migrateCities(country) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n🍎 🍎 🍎  Migrating mZantsi  cities, 🍎 countryID: ${country.countryId} ....... 🍎 🍎 🍎 `);
            if (!country.countryId) {
                throw new Error('countryId is BUST .. quittin');
            }
            if (!cities_json_1.default) {
                throw new Error('no cities found .. quittin before migratin');
            }
            const start = new Date().getTime();
            let cnt = 0;
            for (const m of cities_json_1.default) {
                const city = cities_json_1.default[m];
                const x = yield country_helper_1.CityHelper.addCity(city.name, city.provinceName, country.countryId, country.name, city.latitude, city.longitude);
                cnt++;
                console.log(`🌳 🌳 🌳  city #${cnt}  added to Mongo: 🍎 id: ${x.countryId}  🍎 ${city.name}  💛  ${city.provinceName}  📍 📍 ${city.latitude}  📍  ${city.longitude}`);
            }
            const end = new Date().getTime();
            console.log(`\n\n💛 💛 💛 💛 💛 💛   mZantsi Cities migrated: ${end -
                start / 1000} seconds elapsed`);
        });
    }
}
exports.default = Migrator;
//# sourceMappingURL=migrator.js.map