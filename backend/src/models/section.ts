// tslint:disable-next-line: interface-name
export interface Section {
    sectionNumber: number,
    description: string,
    title: string,
    questions: Question[]
}
// tslint:disable-next-line: interface-name
export interface Answer {
    text: string,
    aNumber: number,
    photoUrls: [],
    videoUrls: [],
}

// tslint:disable-next-line: interface-name
export interface Question {
    text: string,
    answers: Answer[],
    questionType: QuestionType,
    choices: string[];

}

export  enum QuestionType {
    SingleAnswer = 'SingleAnswer',
    MultipleChoice = 'MultipleChoice',
    SingleChoice = 'SingleChoice',
    Optional = 'Optional',
}
