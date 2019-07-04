import { Question } from "../models/interfaces";
import Questionnaire from "../models/questionnaire";
import Organization from "../models/organization";
import Country from "../models/country";
import { Section } from "../models/interfaces";

export class QuestionnaireHelper {
  public static async addQuestionnaire(
    name: string,
    title: string,
    description: string,
    countryId: string,
    organizationId: string,
    sections: any[],
  ): Promise<any> {
    const questModel = new Questionnaire().getModelForClass(Questionnaire);
    const orgModel = new Organization().getModelForClass(Organization);
    const org = await orgModel.findByOrganizationId(organizationId);
    if (!org) {
      const msg = `Organization ${organizationId} not found`;
      console.error(msg);
      throw new Error(msg);
    }
    const cntryModel = new Country().getModelForClass(Country);
    const cntry = await cntryModel.findByCountryId(countryId).exec();
    if (!cntry) {
      const msg = `Country ${countryId} not found`;
      console.error(msg);
      throw new Error(msg);
    }
    const list: Section[] = [];
    for (const sec of sections) {
      const mSec: Section = {
        sectionNumber: sec.sectionNumber,
        title: sec.title,
        description: sec.description,
        questions: this.getQuestions(sec),
      };
      list.push(mSec);
    }
    const quest = new questModel({
      name,
      title,
      description,
      countryId,
      organizationId,
      countryName: cntry.name,
      sections: list,
    });
    const m = await quest.save();
    m.questionnaireId = m.id;
    await m.save();
    console.log(
      `\n\n💙💚💛   QuestionnaireHelper: Yebo Gogo!!!! - MongoDB has saved ${name} ${title}!!!!!  💙💚💛`,
    );

    console.log(m);
    return m;
  }
  public static async getQuestionnaires(): Promise<any> {
    console.log(` 🌀 getQuestionnaires ....   🌀  🌀  🌀 `);
    const QuestionnaireModel = new Questionnaire().getModelForClass(
      Questionnaire,
    );
    const list = await QuestionnaireModel.find();
    console.log(list);
    return list;
  }

  public static async onQuestionnaireAdded(event: any) {
    console.log(`onQuestionnaireAdded event has occured .... 👽 👽 👽`);
    console.log(event);
    console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
  }

  private static getQuestions(sec: any) {
    const list: any = [];
    sec.questions.forEach((q: any) => {
      const qm: Question = {
        text: q.text,
        answers: [],
        choices: q.choices,
        questionType: q.questionType,
      };
      list.push(qm);
    });
    return list;
  }
}
