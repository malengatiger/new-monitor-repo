// import { LandmarkHelper } from "./../helpers/landmark_helper";
// import * as admin from "firebase-admin";
// import CommuterArrivalLandmark from "../models/commuter_arrival_landmark";
// import DispatchRecord from "../models/dispatch_record";
// import User from "../models/user";
// import CommuterPanic from "../models/commuter_panic";
// import Landmark from "../models/landmark";

// console.log(`\n\n☘️ ☘️ ☘️ Loading service accounts from ☘️ .env ☘️  ...\n\n`);
// const sa1 = process.env.DANCER_CONFIG || "config 1 not found";
// const ssa1 = JSON.parse(sa1);
// console.log(`📌 📌 📌 📌 📌 📌 📌 📌  `);
// console.log(ssa1);
// console.log(`📌 📌 📌 📌 📌 📌 📌 📌 `);
// console.log(`\n☘️ serviceAccounts listed ☘️ ok: 😍 😍 😍 ...\n\n`);

// const appTo = admin.initializeApp(
//   {
//     credential: admin.credential.cert(ssa1),
//     databaseURL: "https://dancer-3303.firebaseio.com",
//   },
//   "appTo",
// );
// console.log(
//   `🔑🔑🔑 appTo = admin.initializeApp done: 😍 😍 😍 ... ${appTo.name}`,
// );

// class Messaging {
//   public static async sendCommuterArrivalLandmark(
//     data: CommuterArrivalLandmark,
//   ): Promise<any> {
//     const options: any = {
//       priority: "normal",
//       timeToLive: 60 * 60,
//     };
//     const payload: any = {
//       notification: {
//         title: "Commuter Arrival",
//         body: data.createdAt,
//       },
//       data: {
//         createdAt: data.createdAt,
//         userId: data.userId,
//         routeId: data.routeId,
//         fromLandmarkId: data.fromLandmarkId,
//         toLandmarkId: data.toLandmarkId,
//       },
//     };
//     const topic = "commuterArrivalLandmark_" + data.fromLandmarkId;
//     await appTo.messaging().sendToTopic(topic, payload, options);
//     console.log(
//       `😍 sendCommuterArrivalLandmark: message sent: 😍 ${
//         data.fromLandmarkName
//       } ${data.fromLandmarkId}`,
//     );
//   }
//   public static async sendDispatchRecord(data: DispatchRecord): Promise<any> {
//     const options: any = {
//       priority: "normal",
//       timeToLive: 60 * 60,
//     };
//     const payload: any = {
//       notification: {
//         title: "Dispatch Record",
//         body: data.dispatchedAt,
//       },
//       data: {
//         dispatchedAt: data.dispatchedAt,
//         userId: data.userId,
//         routeId: data.routeId,
//         landmarkId: data.landmarkId,
//         vehicleId: data.vehicleId,
//         vehicleReg: data.vehicleReg,
//       },
//     };
//     const topic = "sendDispatchRecord_" + data.landmarkId;
//     await appTo.messaging().sendToTopic(topic, payload, options);
//     console.log(
//       `😍 sendDispatchRecord: message sent: 😍 ${data.landmarkId} ${
//         data.dispatchedAt
//       }`,
//     );
//   }
//   public static async sendUser(data: User): Promise<any> {
//     const options: any = {
//       priority: "normal",
//       timeToLive: 60 * 60,
//     };
//     const payload: any = {
//       notification: {
//         title: "User Added",
//         body: data.firstName + " " + data.lastName + " created:" + data.created,
//       },
//       data: {
//         firstName: data.firstName,
//         lastName: data.lastName,
//         associationID: data.associationID,
//         email: data.email,
//       },
//     };
//     const topic1 = "users";
//     const topic2 = "users_" + data.associationID;
//     const con = `${topic1} in topics || ${topic2} in topics`;
//     await appTo.messaging().sendToCondition(con, payload, options);
//     console.log(
//       `😍😍 sendUser: message sent: 😍😍 ${data.firstName} ${
//         data.lastName
//       } 👽👽👽`,
//     );
//   }

//   public static async sendPanic(data: CommuterPanic): Promise<any> {
//     const options: any = {
//       priority: "high",
//       timeToLive: 60 * 60,
//     };
//     const payload: any = {
//       notification: {
//         title: "Commuter Panic",
//         body: data.type + " " + data.createdAt + " userId:" + data.userId,
//       },
//       data: {
//         type: data.type,
//         createdAt: data.createdAt,
//         userId: data.userId,
//         vehicleId: data.vehicleId,
//         vehicleReg: data.vehicleReg,
//         active: data.active,
//         locations: data.locations,
//       },
//     };
//     // todo - find nearest landmarks to find routes - send panic to routes found

//     const list: any[] = await LandmarkHelper.findByLocation(
//       data.locations[0].coordinates[1],
//       data.locations[0].coordinates[0],
//       30,
//     );
//     console.log(`landmarks found near panic: ${list.length}`);
//     const mTopic = "panic";
//     await appTo.messaging().sendToTopic(mTopic, payload, options);
//     // send messages to routes and landmarks

//     for (const landmark of list) {
//       const topic1 = "panic_" + landmark.landmarkId;
//       await appTo.messaging().sendToTopic(topic1, payload, options);
//       console.log(
//         `😍😍 sendPanic: message sent: 😍😍 ${data.type} ${
//           data.createdAt
//         } 👽👽 landmark topic: ${topic1}👽`,
//       );
//       for (const routeId of landmark.routeIDs) {
//         const routeTopic = "panic_" + routeId;
//         await appTo.messaging().sendToTopic(routeTopic, payload, options);
//         console.log(
//           `😍😍 sendPanic: message sent: 😍😍 ${data.type} ${
//             data.createdAt
//           } 👽👽 route topic: ${routeTopic}👽`,
//         );
//       }
//     }
//   }
// }

// export default Messaging;
