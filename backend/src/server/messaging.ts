import * as admin from "firebase-admin";

console.log(`\n\n☘️ ☘️ ☘️ Loading service accounts from ☘️ .env ☘️  ...\n\n`);
const sa1 = process.env.MONITOR_CONFIG || "config 1 not found";
const ssa1 = JSON.parse(sa1);
console.log(`📌 📌 📌 📌 📌 📌 📌 📌  `);
console.log(ssa1);
console.log(`📌 📌 📌 📌 📌 📌 📌 📌 `);
console.log(`\n☘️ serviceAccounts listed ☘️ ok: 😍 😍 😍 ...\n\n`);

const appTo = admin.initializeApp(
  {
    credential: admin.credential.cert(ssa1),
    databaseURL: "https://monitor-platform.firebaseio.com",
  },
  "appTo",
);
console.log(
  `🔑🔑🔑 appTo = admin.initializeApp done: 😍 😍 😍 ... ${appTo.name}`,
);

class Messaging {
  public static async sendUser(
    data: any,
  ): Promise<any> {
    const options: any = {
      priority: "normal",
      timeToLive: 60 * 60,
    };
    const payload: any = {
      notification: {
        title: "User Added",
        body: JSON.stringify(data),
      },
      data: {
          json: JSON.stringify(data),
      },
    };
    const topic = "users";
    await appTo.messaging().sendToTopic(topic, payload, options);
    console.log(
      `😍😍😍😍😍😍😍😍 sendUser: user data message sent to topic: 🍎🍎  ${new Date().toISOString()} 🍎🍎 `,
    );
    console.log(payload);
  }
  public static async sendSettlement(
    data: any,
  ): Promise<any> {
    const options: any = {
      priority: "normal",
      timeToLive: 60 * 60,
    };
    const payload: any = {
      notification: {
        title: "Settlement Added or Updated",
        body: JSON.stringify(data),
      },
      data: {
          json: JSON.stringify(data),
      },
    };
    const topic = "settlements_" + data.countryId;
    await appTo.messaging().sendToTopic(topic, payload, options);
    console.log(
      `😍😍😍😍😍😍😍😍 sendSettlement: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `,
    );
    console.log(payload);
  }
  public static async sendProject(
    data: any,
  ): Promise<any> {
    const options: any = {
      priority: "normal",
      timeToLive: 60 * 60,
    };
    const payload: any = {
      notification: {
        title: "Project Added or Updated",
        body: JSON.stringify(data),
      },
      data: {
          json: JSON.stringify(data),
      },
    };
    const topic = "projects";
    await appTo.messaging().sendToTopic(topic, payload, options);
    console.log(
      `😍😍😍😍😍😍😍😍 sendProject: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `,
    );
    console.log(payload);
  }
  public static async sendQuestionnaire(
    data: any,
  ): Promise<any> {
    const options: any = {
      priority: "normal",
      timeToLive: 60 * 60,
    };
    const payload: any = {
      notification: {
        title: "Questionnaire Added or Updated",
        body: JSON.stringify(data),
      },
      data: {
          json: JSON.stringify(data),
      },
    };
    const topic = "questionnaires";
    await appTo.messaging().sendToTopic(topic, payload, options);
    console.log(
      `😍😍😍😍😍😍😍😍 sendQuestionnaire: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `,
    );
    console.log(payload);
  }
  public static async sendOrganization(
    data: any,
  ): Promise<any> {
    const options: any = {
      priority: "normal",
      timeToLive: 60 * 60,
    };
    const payload: any = {
      notification: {
        title: "Organization Added or Updated",
        body: JSON.stringify(data),
      },
      data: {
          json: JSON.stringify(data),
      },
    };
    const topic = "organizations";
    await appTo.messaging().sendToTopic(topic, payload, options);
    console.log(
      `😍😍😍😍😍😍😍😍 sendOrganization: data message sent to topic: 💙 ${topic} 💙 🍎🍎  ${new Date().toISOString()} 🍎🍎 `,
    );
    console.log(payload);
  }
}

export default Messaging;
