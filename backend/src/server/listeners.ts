import Constants from '../server/constants';
import { SettlementHelper } from '../helpers/settlement_helper';
import { UserHelper } from '../helpers/user_helper';
import { ProjectHelper } from '../helpers/project_helper';
import { QuestionnaireHelper } from '../helpers/questionnaire_helper';

class MongoListeners {
  public static listen(client: any) {

    console.log(
      `\n🔆🔆🔆  MongoListeners: 🧡🧡🧡  listening to changes in collections ... 👽 👽 👽\n`,
    );

    const users = client.connection.collection(Constants.USERS);
    const settlements = client.connection.collection(Constants.SETTLEMENTS);
    const projects = client.connection.collection(Constants.PROJECTS);
    const quests = client.connection.collection(Constants.QUESTIONNAIRES);
    
    //
    const settlementStream = settlements.watch({ fullDocument: 'updateLookup' });   
    const usersStream = users.watch({ fullDocument: 'updateLookup' });
    const projectStream = projects.watch({ fullDocument: 'updateLookup' });  
    const questStream = quests.watch({ fullDocument: 'updateLookup' });
    questStream.on("change", (event: any) => {
      console.log(
        `\n🔆🔆🔆🔆   🍎  questStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`,
      );
      console.log(event);
      QuestionnaireHelper.onQuestionnaireAdded(event);
    });
    projectStream.on("change", (event: any) => {
      console.log(
        `\n🔆🔆🔆🔆   🍎  projectStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`,
      );
      console.log(event);
      ProjectHelper.onProjectAdded(event);
    });
    settlementStream.on("change", (event: any) => {
      console.log(
        `\n🔆🔆🔆🔆   🍎  settlementStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`,
      );
      console.log(event);
      SettlementHelper.onSettlementAdded(event);
    });
    usersStream.on("change", (event: any) => {
      console.log(
        `\n🔆🔆🔆🔆   🍎  usersStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`,
      );
      console.log(event);
      UserHelper.onUserAdded(event);
    });
    
  }
}

export default MongoListeners;
