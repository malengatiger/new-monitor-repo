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

// tslint:disable-next-line: interface-name
export interface Content {
    url: string,
    created: string,
    position: Position,
    userId: string,
    comment: string,
}
// tslint:disable-next-line: interface-name
export interface RatingContent {
    rating: Rating,
    created: string,
    position: Position,
    userId: string,
    comment: string,
}

enum Rating {
  Excellent = 5,
  Good = 4,
  Average = 3,
  Bad = 2,
  Terrible = 1,
}
export  enum QuestionType {
    SingleAnswer = 'SingleAnswer',
    MultipleChoice = 'MultipleChoice',
    SingleChoice = 'SingleChoice',
    Optional = 'Optional',
}
