import { getDistance } from "geolib";
import Moment from "moment";
import City from "../models/city";
import Country from "../models/country";

export class CountryHelper {
  public static async onCountryAdded(event: any) {
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  Country in stream:   🍀 🍎 `,
    );
  }
  public static async addCountry(
    name: string,
    countryCode: string,
  ): Promise<any> {
    console.log(
      `\n\n🌀  🌀  🌀  CountryHelper: addCountry   🍀   ${name}   🍀 \n`,
    );

    if (!countryCode) {
      countryCode = "TBD";
    }
   
    const CountryModel = new Country().getModelForClass(Country);
    const u = new CountryModel({
      countryCode,
      name,
    });
    const m = await u.save();
    m.countryId = m.id;
    await m.save();
    return m;
  }

  public static async getCountries(): Promise<any> {
    console.log(` 🌀 getCountries ....   🌀  🌀  🌀 `);
    const CountryModel = new Country().getModelForClass(Country);
    const list = await CountryModel.find();
    return list;
  }
}

// tslint:disable-next-line: max-classes-per-file
export class CityHelper {
  public static async onCityAdded(event: any) {
    console.log(`City event has occured ....`);
    console.log(event);
    // tslint:disable-next-line: max-line-length
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  City in stream:   🍀   🍀  ${event.fullDocument.name} 🍎  _id: ${
        event.fullDocument._id
      } 🍎 `,
    );
  }
  public static async addCity(
    name: string,
    provinceName: string,
    countryId: string,
    countryName: string,
    latitude: number,
    longitude: number,
  ): Promise<any> {

    const cityModel = new City().getModelForClass(City);
    const position = {
      coordinates: [longitude, latitude],
      type: "Point",
      createdAt: new Date().toISOString(),
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
    const m = await u.save();
    m.cityId = m.id;
    const z = await m.save();
    console.log(`\n\n🌀🌀🌀  CityHelper: city added:   🍀   ${name} \n`);

    return z;
  }

  public static async getCities(countryId: string): Promise<any> {
    console.log(`\n🌀🌀🌀🌀  CountryHelper:  😡  getCities ....   🌀🌀🌀 `);
    const CityModel = new City().getModelForClass(City);
    const list = await CityModel.find({ countryId });
    console.log(
      `😡  😡  😡  😡  😡  Done reading cities ....found:  ${list.length}`,
    );
    return list;
  }
  public static async findCitiesByLocation(
    latitude: number,
    longitude: number,
    radiusInKM: number,
  ): Promise<any> {
    console.log(
      `\n🌳 🌳 🌳  findCitiesByLocation: lat: ${latitude}  lng: ${longitude} 🌀 🌀 🌀`,
    );
    const CityModel = new City().getModelForClass(City);

    const start = new Date().getTime();
    const RADIUS = radiusInKM * 1000;
    const mList = await CityModel.find({
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
    console.log(
      `\n🍎 🍎 🍎 Cities found within: 🍎 ${radiusInKM *
        1000} metres:  🌳 🌳 🌳 ${mList.length} cities\n`,
    );
    console.log(`🍎 🍎 🍎  geoQuery took:  ☘️  ${elapsed}  ☘️ \n`);
    let cnt = 0;
    mList.forEach((m: any) => {
      cnt++;
      console.log(
        `🍏  #${cnt} - ${m.name}  🔆  ${m.provinceName}  💙  ${m.countryName}`,
      );
    });
    const d = Moment().format("YYYY-MM-DDTHH:mm:ss");
    // tslint:disable-next-line: max-line-length
    console.log(
      `\n🍎 🍎 🍎 Done: radius: 🍎 ${radiusInKM * 1000} metres: 🌳 🌳 🌳 ${
        mList.length
      } cities. 💦 💦 💦 ${d}  \n\n`,
    );
    const m = await this.calculateDistances(mList, latitude, longitude);
    return m;
  }
  private static async calculateDistances(
    cities: any[],
    latitude: number,
    longitude: number,
  ): Promise<any> {
    const from = {
      latitude,
      longitude,
    };

    for (const m of cities) {
      const to = {
        latitude: m.position.coordinates[1],
        longitude: m.position.coordinates[0],
      };
      const dist = getDistance(from, to);
      const f = new Intl.NumberFormat("en-za", {
        maximumSignificantDigits: 3,
      }).format(dist / 1000);
      m.distance = f + " km (as the crow flies)";
      console.log(`🌺  ${f} km 💛  ${m.name} 🍀 ${m.provinceName} 🌳 `);
    }
    console.log(`\n\n`);
    return cities;
  }
}
