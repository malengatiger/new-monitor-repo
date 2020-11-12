package com.monitor.backend.models

import com.querydsl.core.annotations.QueryEntity
import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document


enum class QuestionType {
    SINGLE_ANSWER, MULTIPLE_CHOICE, SINGLE_CHOICE, OPTIONAL
}

enum class UserType {
    ADMINISTRATOR, OFFICIAL, EXECUTIVE, MONITOR, ORGANIZATION_USER
}

enum class Rating {
    EXCELLENT, GOOD, AVERAGE, BAD, TERRIBLE
}

data class Community(var name: String, var communityId: String?, var countryId: String, var population: Int = 0,
                     var countryName: String,
                     var polygon:  List<Position>?, var photos: List<Photo> = ArrayList(), var videos: List<Video> = ArrayList(),
                     var nearestCities: List<City> = ArrayList()) {
}
data class User(var name: String, var email: String, var cellphone: String, var userId: String?,
                var organizationId: String, var organizationName: String, var created: String, var userType: UserType) {
}

data class Organization(var name: String, var countryName: String, var countryId: String,
                        var organizationId: String?, var created: String) {}

data class Project(var projectId: String?, var name: String, var organization: Organization,
                   var description: String?,
                   var created: String, var nearestCities: List<City>?, var position: Position) {}

@QueryEntity
@Document
data class City(@Id var _id:String?, var name: String, var cityId: String?, var country: Country,
                var provinceName: String, var position: Position) {
}

data class Questionnaire(var organization: Organization, var created: String, var questionnaireId: String?,
                         var title: String,
                         var description: String?, var sections: List<Section>) {}

//data class Position(var latitude: Double, var longitude: Double, var geohash: String?) {
//}
data class Position(var type: String, var coordinates: List<Double>) {
}

data class Country(@Id var _id:String?, var countryId: String?, var name: String, var countryCode: String,
                   var position: Position) {
}

data class Answer(var text: String, var number: Double, var photoUrls: List<String>?,
                  var videoUrls: List<String>?) {
}

data class Question(var text: String, var answers: List<Answer>?, var questionType: QuestionType,
                    var choices: List<String>?) {
}

data class Section(var sectionNumber: Int, var title: String, var description: String,
                   var questions: List<Question>) {
}


data class Photo(var url: String, var caption: String?, var created: String) {}

data class Video(var url: String, var caption: String?, var created: String) {}

data class MonitorReport(var monitorReportId: String?, var projectId: String,
                         var user: User, var rating: Rating, var photos: List<Photo>,
                         var videos: List<Video>, var description: String, var created: String) {}

data class QuestionnaireResponse(var questionnaireResponseId: String?, var questionnaireId: String,
                                 var user: User, var sections: List<Section>) {}
