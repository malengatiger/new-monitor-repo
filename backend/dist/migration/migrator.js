"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const country_helper_1 = require("./../helpers/country_helper");
const z = "\n";
// tslint:disable-next-line: no-var-requires
const citiesJson = require("../../cities.json");
const mData = citiesJson;
console.log(mData);
class Migrator {
    static start() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n......Migrator is starting up ... ❤️  ❤️  ❤️  ....\n`);
            const start = new Date().getTime();
            // await this.migrateMzantsi();
            yield this.migrateCities();
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
        });
    }
    static migrateCities() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n🍎 🍎 🍎  Migrating cities, 🍎 countryID: 5d1f4e0d41ec6bc61c3c3189 ....... 🍎 🍎 🍎 `);
            const start = new Date().getTime();
            let cnt = 0;
            // tslint:disable-next-line: forin
            for (const m in citiesJson) {
                const city = citiesJson[m];
                const x = yield country_helper_1.CityHelper.addCity(city.name, city.provinceName, "5d1f4e0d41ec6bc61c3c3189", "South Africa", city.latitude, city.longitude);
                cnt++;
                console.log(`🌳 🌳 🌳  city #${cnt}  added to Mongo: 🍎 id: ${x.countryId}  🍎 ${city.name}  💛  ${city.provinceName}  📍 📍 ${city.latitude}  📍  ${city.longitude}`);
            }
            const end = new Date().getTime();
            console.log(`\n\n💛 💛 💛 💛 💛 💛   Cities migrated: ${end -
                start / 1000} seconds elapsed`);
        });
    }
}
exports.default = Migrator;
//# sourceMappingURL=migrator.js.map