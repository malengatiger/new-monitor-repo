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
const geolib_1 = require("geolib");
const moment_1 = __importDefault(require("moment"));
const city_1 = __importDefault(require("../models/city"));
const country_1 = __importDefault(require("../models/country"));
class CountryHelper {
    static onCountryAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`operationType: 👽 👽 👽  ${event.operationType},  Country in stream:   🍀 🍎 `);
        });
    }
    static addCountry(name, countryCode) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n\n🌀  🌀  🌀  CountryHelper: addCountry   🍀   ${name}   🍀 \n`);
            if (!countryCode) {
                countryCode = "TBD";
            }
            const CountryModel = new country_1.default().getModelForClass(country_1.default);
            const u = new CountryModel({
                countryCode,
                name,
            });
            const m = yield u.save();
            m.countryId = m.id;
            yield m.save();
            return m;
        });
    }
    static getCountries() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getCountries ....   🌀  🌀  🌀 `);
            const CountryModel = new country_1.default().getModelForClass(country_1.default);
            const list = yield CountryModel.find();
            return list;
        });
    }
}
exports.CountryHelper = CountryHelper;
// tslint:disable-next-line: max-classes-per-file
class CityHelper {
    static onCityAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`City event has occured ....`);
            console.log(event);
            // tslint:disable-next-line: max-line-length
            console.log(`operationType: 👽 👽 👽  ${event.operationType},  City in stream:   🍀   🍀  ${event.fullDocument.name} 🍎  _id: ${event.fullDocument._id} 🍎 `);
        });
    }
    static addCity(name, provinceName, countryId, countryName, latitude, longitude) {
        return __awaiter(this, void 0, void 0, function* () {
            const cityModel = new city_1.default().getModelForClass(city_1.default);
            const position = {
                coordinates: [longitude, latitude],
                type: "Point",
            };
            const u = new cityModel({
                countryId,
                countryName,
                latitude,
                longitude,
                name,
                position,
                provinceName,
            });
            const m = yield u.save();
            m.cityId = m.id;
            yield m.save();
            console.log(`\n\n🌀  🌀  🌀  CityHelper: city added:   🍀   ${name} \n`);
            return m;
        });
    }
    static getCities(countryID) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n🌀🌀🌀🌀  CountryHelper:  😡  getCities ....   🌀🌀🌀 `);
            const CityModel = new city_1.default().getModelForClass(city_1.default);
            const list = yield CityModel.find({ countryID });
            console.log(`😡  😡  😡  😡  😡  Done reading cities ....found:  ${list.length}`);
            return list;
        });
    }
    static findCitiesByLocation(latitude, longitude, radiusInKM) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(`\n🌳 🌳 🌳  findCitiesByLocation: lat: ${latitude}  lng: ${longitude} 🌀 🌀 🌀`);
            const CityModel = new city_1.default().getModelForClass(city_1.default);
            const start = new Date().getTime();
            const RADIUS = radiusInKM * 1000;
            const mList = yield CityModel.find({
                position: {
                    $near: {
                        $geometry: {
                            coordinates: [longitude, latitude],
                            type: "Point",
                        },
                        $maxDistance: RADIUS,
                    },
                },
            });
            const end = new Date().getTime();
            const elapsed = `${(end - start) / 1000} seconds elapsed`;
            console.log(`\n🍎 🍎 🍎 Cities found within: 🍎 ${radiusInKM *
                1000} metres:  🌳 🌳 🌳 ${mList.length} cities\n`);
            console.log(`🍎 🍎 🍎  geoQuery took:  ☘️  ${elapsed}  ☘️ \n`);
            let cnt = 0;
            mList.forEach((m) => {
                cnt++;
                console.log(`🍏  #${cnt} - ${m.name}  🔆  ${m.provinceName}  💙  ${m.countryName}`);
            });
            const d = moment_1.default().format("YYYY-MM-DDTHH:mm:ss");
            // tslint:disable-next-line: max-line-length
            console.log(`\n🍎 🍎 🍎 Done: radius: 🍎 ${radiusInKM * 1000} metres: 🌳 🌳 🌳 ${mList.length} cities. 💦 💦 💦 ${d}  \n\n`);
            const m = yield this.calculateDistances(mList, latitude, longitude);
            return m;
        });
    }
    static calculateDistances(cities, latitude, longitude) {
        return __awaiter(this, void 0, void 0, function* () {
            const from = {
                latitude,
                longitude,
            };
            for (const m of cities) {
                const to = {
                    latitude: m.position.coordinates[1],
                    longitude: m.position.coordinates[0],
                };
                const dist = geolib_1.getDistance(from, to);
                const f = new Intl.NumberFormat("en-za", {
                    maximumSignificantDigits: 3,
                }).format(dist / 1000);
                m.distance = f + " km (as the crow flies)";
                console.log(`🌺  ${f} km 💛  ${m.name} 🍀 ${m.provinceName} 🌳 `);
            }
            console.log(`\n\n`);
            return cities;
        });
    }
}
exports.CityHelper = CityHelper;
//# sourceMappingURL=country_helper.js.map