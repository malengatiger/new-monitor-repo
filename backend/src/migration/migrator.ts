import { CityHelper, CountryHelper } from "./../helpers/country_helper";
const z = "\n";
// tslint:disable-next-line: no-var-requires
const citiesJson = require("../../cities.json");
const mData: Map<string, any> = citiesJson;
console.log(mData);

class Migrator {
  public static async start() {
    console.log(`\n\n......Migrator is starting up ... ❤️  ❤️  ❤️  ....\n`);
    const start = new Date().getTime();

    

    // await this.migrateMzantsi();
    await this.migrateCities();

    const end = new Date().getTime();
    const msg = `❤️️ ❤️ ❤️   Migrator has finished the job!  ❤️  ${(end -
      start) /
      1000} seconds elapsed  ❤️ ❤️ ❤️`;
    console.log(msg);
    return {
      migrator: msg,
      xdate: new Date().toISOString(),
    };
  }

  public static async migrateMzantsi(): Promise<any> {
    console.log(`\n\n🍎  Migrating mzantsi ........................`);

    const country = await CountryHelper.addCountry("South Africa", "ZA");
    console.log(`\n🔑 🔑 🔑   country migrated: ${country.name}`);
  }
 
  public static async migrateCities(): Promise<any> {
    console.log(
      `\n\n🍎 🍎 🍎  Migrating cities, 🍎 countryID: 5d1f4e0d41ec6bc61c3c3189 ....... 🍎 🍎 🍎 `,
    );
    const start = new Date().getTime();
    let cnt = 0;
    // tslint:disable-next-line: forin
    for (const m in citiesJson) {
      const city: any = citiesJson[m];
      const x = await CityHelper.addCity(
        city.name,
        city.provinceName,
        "5d1f4e0d41ec6bc61c3c3189",
        "South Africa",
        city.latitude,
        city.longitude,
      );
      cnt++;
      console.log(
        `🌳 🌳 🌳  city #${cnt}  added to Mongo: 🍎 id: ${x.countryId}  🍎 ${
          city.name
        }  💛  ${city.provinceName}  📍 📍 ${city.latitude}  📍  ${
          city.longitude
        }`,
      );
    }
    const end = new Date().getTime();
    console.log(
      `\n\n💛 💛 💛 💛 💛 💛   Cities migrated: ${end -
        start / 1000} seconds elapsed`,
    );
  }
}

export default Migrator;
