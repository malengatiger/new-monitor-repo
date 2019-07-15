"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const questionnaire_1 = __importDefault(require("../models/questionnaire"));
const organization_1 = __importDefault(require("../models/organization"));
const country_1 = __importDefault(require("../models/country"));
const questionnaire_response_1 = __importDefault(require("../models/questionnaire_response"));
const messaging_1 = __importDefault(require("../server/messaging"));
class QuestionnaireHelper {
    static addQuestionnaireResponse(questionnaireId, respondentId, userId, sections) {
        return __awaiter(this, void 0, void 0, function* () {
            const questModel = new questionnaire_response_1.default().getModelForClass(questionnaire_response_1.default);
            const list = [];
            for (const sec of sections) {
                const mSec = {
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
            const m = yield quest.save();
            m.questionnaireResponseId = m.id;
            yield m.save();
            console.log(`\n\n💙💚💛   QuestionnaireHelper: Yebo Gogo!!!! - MongoDB has saved ${questionnaireId} questionnaire response!!!!!  💙💚💛`);
        });
    }
    static addQuestionnaire(title, description, countryId, organizationId, sections) {
        return __awaiter(this, void 0, void 0, function* () {
            const questModel = new questionnaire_1.default().getModelForClass(questionnaire_1.default);
            const orgModel = new organization_1.default().getModelForClass(organization_1.default);
            const org = yield orgModel.findByOrganizationId(organizationId);
            if (!org) {
                const msg = `Organization ${organizationId} not found`;
                console.error(msg);
                throw new Error(msg);
            }
            const cntryModel = new country_1.default().getModelForClass(country_1.default);
            const cntry = yield cntryModel.findByCountryId(countryId).exec();
            if (!cntry) {
                const msg = `Country ${countryId} not found`;
                console.error(msg);
                throw new Error(msg);
            }
            const list = [];
            for (const sec of sections) {
                const mSec = {
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
            const m = yield quest.save();
            m.questionnaireId = m.id;
            yield m.save();
            console.log(`\n\n💙💚💛QuestionnaireHelper: MongoDB questionnaire saved: ${title}!!!!!  💙💚💛`);
            console.log(m);
            return m;
        });
    }
    static addQuestionnaireSection(questionnaireId, section) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 addQuestionnaireSection ....   🌀  🌀  🌀 `);
            const model = new questionnaire_1.default().getModelForClass(questionnaire_1.default);
            const m = yield model.findOneAndUpdate({ _id: questionnaireId }, { $push: { sections: section } }, () => (error, success) => {
                if (error) {
                    console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
                    console.error(error);
                }
                else {
                    console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
                    console.log(success);
                }
            });
            console.log(`🥦🥦🥦🥦🥦🥦 success has occured, section added? maybe?`);
            console.log(m);
            return m;
        });
    }
    static getQuestionnaires() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getQuestionnaires ....   🌀  🌀  🌀 `);
            const QuestionnaireModel = new questionnaire_1.default().getModelForClass(questionnaire_1.default);
            const list = yield QuestionnaireModel.find();
            console.log(list);
            return list;
        });
    }
    static getQuestionnairesByOrganization(organizationId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getQuestionnairesByOrganization ....   🌀  🌀  🌀 `);
            const QuestionnaireModel = new questionnaire_1.default().getModelForClass(questionnaire_1.default);
            const list = yield QuestionnaireModel.findByOrganization(organizationId);
            console.log(list);
            return list;
        });
    }
    static onQuestionnaireAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
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
            };
            yield messaging_1.default.sendQuestionnaire(data);
        });
    }
    static onQuestionnaireResponseAdded(event) {
        return __awaiter(this, void 0, void 0, function* () {
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
            };
            yield messaging_1.default.sendQuestionnaire(data);
        });
    }
    static getQuestionnaireResponses(questionnaireId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getQuestionnaireResponses ....   🌀  🌀  🌀 `);
            const QuestionnaireModel = new questionnaire_response_1.default().getModelForClass(questionnaire_response_1.default);
            const list = yield QuestionnaireModel.findByQuestionnaire(questionnaireId);
            console.log(list);
            return list;
        });
    }
    static getQuestionnaireResponsesBySettlement(settlementId) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log(` 🌀 getQuestionnaireResponsesBySettlement ....   🌀  🌀  🌀 `);
            const QuestionnaireModel = new questionnaire_response_1.default().getModelForClass(questionnaire_response_1.default);
            const list = yield QuestionnaireModel.findBySettlement(settlementId);
            console.log(list);
            return list;
        });
    }
    static getQuestions(sec) {
        const list = [];
        sec.questions.forEach((q) => {
            const qm = {
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
exports.QuestionnaireHelper = QuestionnaireHelper;
//# sourceMappingURL=questionnaire_helper.js.map