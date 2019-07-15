import { Question } from "../models/interfaces";
import Questionnaire from "../models/questionnaire";
import Organization from "../models/organization";
import Country from "../models/country";
import { Section } from "../models/interfaces";
import QuestionnaireResponse from "../models/questionnaire_response";
import Messaging from "../server/messaging";

export class QuestionnaireHelper {
  public static async addQuestionnaireResponse(
    questionnaireId: string,
    respondentId: string,
    userId: string,
    sections: any[],
  ) {
    const questModel = new QuestionnaireResponse().getModelForClass(
      QuestionnaireResponse,
    );
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
      questionnaireId,
      respondentId,
      sections: list,
      userId,
    });
    const m = await quest.save();
    m.questionnaireResponseId = m.id;
    await m.save();
    console.log(
      `\n\n💙💚💛   QuestionnaireHelper: Yebo Gogo!!!! - MongoDB has saved ${questionnaireId} questionnaire response!!!!!  💙💚💛`,
    );
  }
  public static async addQuestionnaire(
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
      title,
      description,
      countryId,
      organizationId,
      organizationName: org.name,
      countryName: cntry.name,
      sections: list,
    });
    const m = await quest.save();
    m.questionnaireId = m.id;
    await m.save();
    console.log(
      `\n\n💙💚💛QuestionnaireHelper: MongoDB questionnaire saved: ${title}!!!!!  💙💚💛`,
    );

    console.log(m);
    return m;
  }
  public static async addQuestionnaireSection(
    questionnaireId: string,
    section: any,
  ): Promise<any> {
    console.log(` 🌀 addQuestionnaireSection ....   🌀  🌀  🌀 `);
    const model = new Questionnaire().getModelForClass(Questionnaire);

    const m = await model.findOneAndUpdate(
      { _id: questionnaireId },
      { $push: { sections: section } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    console.log(`🥦🥦🥦🥦🥦🥦 success has occured, section added? maybe?`);
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
  public static async getQuestionnairesByOrganization(
    organizationId: string,
  ): Promise<any> {
    console.log(` 🌀 getQuestionnairesByOrganization ....   🌀  🌀  🌀 `);
    const QuestionnaireModel = new Questionnaire().getModelForClass(
      Questionnaire,
    );
    const list = await QuestionnaireModel.findByOrganization(organizationId);
    console.log(list);
    return list;
  }

  public static async onQuestionnaireAdded(event: any) {
    console.log(`onQuestionnaireAdded event has occured .... 👽 👽 👽`);
    console.log(event);
    console.log(`operationType: 👽👽👽  ${event.operationType},   🍎 `);
    const doc = event.fullDocument;
    const data = {
      id: doc.id,
      title: doc.title,
      description: doc.description,
      organizationId: doc.organizationId,
      organizationName: doc.organizationName,
    }
    await Messaging.sendQuestionnaire(data);
  }
  public static async onQuestionnaireResponseAdded(event: any) {
    console.log(`onQuestionnaireResponseAdded event has occured .... 👽 👽 👽`);
    console.log(event);
    console.log(`operationType: 👽 👽 👽  ${event.operationType},   🍎 `);
    const doc = event.fullDocument;
    const data = {
      id: doc.id,
      title: doc.title,
      description: doc.description,
      organizationId: doc.organizationId,
      organizationName: doc.organizationName,
    }
    await Messaging.sendQuestionnaire(data);
  }

  public static async getQuestionnaireResponses(
    questionnaireId: string,
  ): Promise<any> {
    console.log(` 🌀 getQuestionnaireResponses ....   🌀  🌀  🌀 `);
    const QuestionnaireModel = new QuestionnaireResponse().getModelForClass(
      QuestionnaireResponse,
    );
    const list = await QuestionnaireModel.findByQuestionnaire(questionnaireId);
    console.log(list);
    return list;
  }
  public static async getQuestionnaireResponsesBySettlement(
    settlementId: string,
  ): Promise<any> {
    console.log(` 🌀 getQuestionnaireResponsesBySettlement ....   🌀  🌀  🌀 `);
    const QuestionnaireModel = new QuestionnaireResponse().getModelForClass(
      QuestionnaireResponse,
    );
    const list = await QuestionnaireModel.findBySettlement(settlementId);
    console.log(list);
    return list;
  }

  private static getQuestions(sec: any) {
    const list: any = [];
    sec.questions.forEach((q: any) => {
      const qm: Question = {
        text: q.text,
        answers: q.answers,
        choices: q.choices,
        questionType: q.questionType,
      };
      list.push(qm);
    });
    return list;
  }
}
