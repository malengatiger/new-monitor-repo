"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Rating;
(function (Rating) {
    Rating[Rating["Excellent"] = 5] = "Excellent";
    Rating[Rating["Good"] = 4] = "Good";
    Rating[Rating["Average"] = 3] = "Average";
    Rating[Rating["Bad"] = 2] = "Bad";
    Rating[Rating["Terrible"] = 1] = "Terrible";
})(Rating || (Rating = {}));
var QuestionType;
(function (QuestionType) {
    QuestionType["SingleAnswer"] = "SingleAnswer";
    QuestionType["MultipleChoice"] = "MultipleChoice";
    QuestionType["SingleChoice"] = "SingleChoice";
    QuestionType["Optional"] = "Optional";
})(QuestionType = exports.QuestionType || (exports.QuestionType = {}));
//# sourceMappingURL=interfaces.js.map