// import { AppExpressRoutes } from "./../routes/app_routes";

const appName = "bfnwebapinode";
import express from "express";
import dotenv from "dotenv";
dotenv.config();
import { Request, Response, NextFunction, Application } from "express";
import bodyParser from "body-parser";
import http from "http";
import MonitorApp from "./app";

export const app: Application = express();
const server = http.createServer(app);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use((req: Request, res: Response, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With-Content-Type, Accept",
  );
  next();
});

const port = process.env.PORT || 3000;
server.listen(port, () => {
  console.info(
    `\n🔵🔵🔵  MonitorWebAPI started and listening on 🧡 💛  http://localhost:${port} 🧡 💛`,
  );
  console.info(
    `💕 💕 💕 💕 MonitorWebAPI  running at:: 🧡💛  ${new Date().toISOString() +
      "  🙄 🙄 🙄"}`,
  );
});

const myApp = new MonitorApp();
console.log(
  `🔆 🔆 MonitorWebAPI has been created and stood up! 🔆 🔆 🍎🍎 ${new Date().toUTCString()} 🍎🍎`,
);

module.exports = server;
