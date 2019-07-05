import { Request, Response } from "express";
import { CountryHelper, CityHelper } from "../helpers/country_helper";

import Util from "../server/util";

export class CountryExpressRoutes {
  public routes(app: any): void {
    console.log(
      `\n🏓🏓🏓🏓🏓    CountryExpressRoutes:  💙  setting up default Country/City Routes ...`,
    );

    app.route("/addCountry").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /addCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      console.log(req.body);
      try {
        const result = await CountryHelper.addCountry(
          req.body.name,
          req.body.countryCode,
         
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "addCountry failed");
      }
    });

    app.route("/getCountries").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getCountries requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await CountryHelper.getCountries();
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getCountries failed");
      }
    });
    app.route("/addCity").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findByCountry requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await CityHelper.addCity(
          req.body.name,
          req.body.provinceName,
          req.body.countryId,
          req.body.countryName,
          parseFloat(req.body.latitude),
          parseFloat(req.body.longitude),
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findByCountry failed");
      }
    });
    app.route("/getCities").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /getCities requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await CityHelper.getCities(
          req.body.countryId,
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "getCities failed");
      }
    });
    app.route("/findCitiesByLocation").post(async (req: Request, res: Response) => {
      console.log(
        `\n\n💦  POST: /findCitiesByLocation requested .... 💦 💦 💦 💦 💦 💦  ${new Date().toISOString()}`,
      );
      try {
        const result = await CityHelper.findCitiesByLocation(
          parseFloat(req.body.latitude),
          parseFloat(req.body.longitude),
          parseFloat(req.body.radiusInKM),
        );
        res.status(200).json(result);
      } catch (err) {
        Util.sendError(res, err, "findCitiesByLocation failed");
      }
    });
  }
}
export default CountryExpressRoutes;
