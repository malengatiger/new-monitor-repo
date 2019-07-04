import * as bodyParser from "body-parser";
import cors from "cors";
import express from "express";
import mongoose from "mongoose";
import { AppExpressRoutes } from "../routes/app_routes";
const port = process.env.PORT || "8000";
const password = process.env.MONGODB_PASSWORD || "aubrey3";
const user = process.env.MONGODB_USER || "aubs";
const appName = "Monitor MongoDB API";
const mongoConnection = `mongodb+srv://${user}:${password}@ar001-1xhdt.mongodb.net/monitordb?retryWrites=true`;
// import MongoListeners from "./listeners";

console.log(
  `\n🧡 💛   Monitor MongoDB API ... ☘️  starting  ☘️  ${new Date().toISOString()}   🧡 💛\n`,
);
mongoose
  .connect(mongoConnection, {
    useNewUrlParser: true,
  })
  .then((client) => {
    console.log(
      `\n🔆🔆🔆🔆🔆🔆  Mongo connected ... 🔆🔆🔆  💛  ${new Date()}  💛 💛`,
    );
    console.log(
      `\n🍎🍎  ${appName} :: database:  ☘️  client version: ${
        client.version
      }  ☘️  is OK   🍎🍎 `,
    );
    console.log(
      `🍎🍎🍎  MongoDB config ...${JSON.stringify(
        mongoose.connection.config,
      )}`,
    );
    
    MongoListeners.listen(client);
    console.log(`🍎🍎🍎  MongoDB collections listened to ...`);
    console.log(mongoose.connection.collections);
  })
  .catch((err) => {
    console.error(err);
  });
//
import { app } from "./server";
import MongoListeners from "./listeners";

class MonitorApp {
  public app: express.Application;
  public port: string;
  public appRoutes: AppExpressRoutes = new AppExpressRoutes();
  
  constructor() {
    console.log(`\n🦀 🦀  🥦 Inside MonitorWebAPI constructor ...`);
    this.app = app;
    this.port = port;
    this.initializeMiddleware();
    
    this.appRoutes.routes(this.app);
    

    console.log(
      `\n🦀 🦀  🥦  MonitorWebAPI constructor : 🥦🥦🥦 Completed setting up express routes `,
    );
  }

  private initializeMiddleware() {
    console.log(`\n🥦 🥦  initializeMiddleware .... `);
    this.app.use(bodyParser.json());
    this.app.use(bodyParser.urlencoded({ extended: false }));
    this.app.use(cors());
    console.log(`\n🥦 🥦  bodyParser, cors initialized OK .... 🥦 🥦`);
  }
}

export default MonitorApp;
