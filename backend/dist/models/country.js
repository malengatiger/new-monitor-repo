"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
const typegoose_1 = require("typegoose");
class Country extends typegoose_1.Typegoose {
    static findByName(name) {
        console.log("#####  🥦  🥦  🥦 Finding route(s) by name:  💦  💦  💦  :: 🥦 " + name);
        return this.findOne({ name });
        // coulf be list, routes can have same or similar names for each association
    }
    static findByCountryId(countryId) {
        return this.findOne({ countryId });
    }
}
__decorate([
    typegoose_1.prop({ required: true, index: true, trim: true, unique: true }),
    __metadata("design:type", String)
], Country.prototype, "name", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: "ZA" }),
    __metadata("design:type", String)
], Country.prototype, "countryCode", void 0);
__decorate([
    typegoose_1.prop({ required: true, unique: true, index: true, trim: true }),
    __metadata("design:type", String)
], Country.prototype, "countryID", void 0);
__decorate([
    typegoose_1.prop({ required: true, default: new Date().toISOString() }),
    __metadata("design:type", String)
], Country.prototype, "created", void 0);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Country, "findByName", null);
__decorate([
    typegoose_1.staticMethod,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], Country, "findByCountryId", null);
exports.default = Country;
//# sourceMappingURL=country.js.map