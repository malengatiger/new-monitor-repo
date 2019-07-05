import {
  ModelType,
  prop,
  staticMethod,
  Typegoose,
  instanceMethod,
} from "typegoose";
import Settlement from "./settlement";
import { Question, Section } from "./interfaces";

class QuestionnaireResponse extends Typegoose {
  @staticMethod
  public static findByQuestionnaire(
    this: ModelType<QuestionnaireResponse> & typeof QuestionnaireResponse,
    questionnaireId: string,
  ) {
    return this.find({ questionnaireId });
  }
  @staticMethod
  public static findBySettlement(
    this: ModelType<QuestionnaireResponse> & typeof QuestionnaireResponse,
    settlementId: string,
  ) {
    return this.find({ 'settlements.settlementId': settlementId });
  }
  @staticMethod
  public static findByRespondent(
    this: ModelType<QuestionnaireResponse> & typeof QuestionnaireResponse,
    respondentId: string,
  ) {
    return this.find({ respondentId });
  }
  @staticMethod
  public static findByDate(
    this: ModelType<QuestionnaireResponse> & typeof QuestionnaireResponse,
    date: string,
  ) {
    return this.find({ created: { $gte: date } });
  }
  //
  @prop({ required: true, default: [] })
  public sections!: Section[];
  //
  @prop({ required: true, index: true })
  public userId?: string;
  //
  @prop({ required: true, index: true })
  public questionnaireId?: string;

  @prop({ index: true })
  public respondentId?: string;
  //
  @prop({ index: true })
  public questionnaireResponseId?: string;
  //
  @prop({ required: true, default: [] })
  public settlements!: any[];
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
}

export default QuestionnaireResponse;
