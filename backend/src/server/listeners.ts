import Constants from '../server/constants';
import { SettlementHelper } from '../helpers/settlement_helper';

class MongoListeners {
  public static listen(client: any) {

    console.log(
      `\n🔆🔆🔆  MongoListeners: 🧡🧡🧡  listening to changes in collections ... 👽 👽 👽\n`,
    );

    const users = client.connection.collection(Constants.USERS);
    const settlements = client.connection.collection(Constants.SETTLEMENTS);
    
    //
    const settlementStream = settlements.watch();   
    const usersStream = users.watch({ fullDocument: 'updateLookup' });

    settlementStream.on("change", (event: any) => {
      console.log(
        `\n🔆🔆🔆🔆   🍎  settlementStream onChange fired!  🍎  🔆🔆🔆🔆 ${event}`,
      );
      console.log(event);
      SettlementHelper.onSettlementAdded(event);
    });
    
  }
}

export default MongoListeners;
