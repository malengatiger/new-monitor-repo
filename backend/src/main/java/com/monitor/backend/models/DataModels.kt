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

data class Community(var _partitionKey: String?, @Id var _id: String?, var name: String, var communityId: String?, var countryId: String, var population: Int = 0,
                     var countryName: String,
                     var polygon: List<Position>?, var photos: List<Photo> = ArrayList(), var videos: List<Video> = ArrayList(),
                     var nearestCities: List<City> = ArrayList()) {
}

data class User(var _partitionKey: String?, @Id var _id: String?, var name: String, var email: String, var cellphone: String, var userId: String?,
                var organizationId: String?, var organizationName: String, var created: String, var userType: String, var password:String?) {
}

data class Organization(var _partitionKey: String?, @Id var _id: String?, var name: String, var countryName: String, var countryId: String,
                        var organizationId: String?, var created: String) {}

data class Project(var _partitionKey: String?, @Id var _id: String?,
                   var projectId: String?,
                   var name: String,
                   var organizationId: String,
                   var description: String?,
                   var organizationName: String,
                   var monitorMaxDistanceInMetres: Double? = 50.0,
                   var created: String,
                   var nearestCities: List<City>?,
                   var position: Position) {}

data class Photo(var _partitionKey: String?, @Id var _id: String?,
                 var projectId: String,
                 var projectName: String,
                 var projectPosition: Position,
                 var distanceFromProjectPosition: Double,
                 var url: String,
                 var thumbnailUrl: String,
                 var caption: String?,
                 var userId: String,
                 var userName: String,
                 var created: String) {}

data class Video(var _partitionKey: String?, @Id var _id: String?,
                 var projectId: String,
                 var projectName: String,
                 var projectPosition: Position,
                 var distanceFromProjectPosition: Double,
                 var url: String,
                 var thumbnailUrl: String,
                 var caption: String?,
                 var userId: String,
                 var userName: String,
                 var created: String) {}

data class Condition(var _partitionKey: String?, @Id var _id: String?,
                     var projectId: String,
                     var projectName: String,
                     var projectPosition: Position,
                     var rating: Int,
                     var caption: String?,
                     var userId: String,
                     var userName: String,
                     var created: String) {}


@QueryEntity
@Document
data class City(var _partitionKey: String?, @Id var _id: String?, var name: String, var cityId: String?, var country: Country,
                var provinceName: String, var position: Position) {
}

data class Questionnaire(var _partitionKey: String?, @Id var _id: String?, var organizationId: String,
                         var created: String,
                         var questionnaireId: String?,
                         var title: String, var projectId: String,
                         var description: String?, var sections: List<Section>) {}

//data class Position(var latitude: Double, var longitude: Double, var geohash: String?) {
//}
data class Position(var type: String, var coordinates: List<Double>) {
}

data class UserCount(var userId: String,  var photos: Int = 0, var videos: Int = 0, var projects:Int = 0) {
}

data class ProjectCount(var projectId: String, var photos: Int = 0, var videos: Int = 0) {
}


data class ProjectPosition(var projectId: String, var position: Position,
                           var projectName: String, var caption: String?, var created: String) {

}

data class Country(var _partitionKey: String?, @Id var _id: String?, var countryId: String?, var name: String, var countryCode: String,
                   var position: Position) {
}

data class Answer(var _partitionKey: String?, @Id var _id: String?, var text: String, var number: Double, var photoUrls: List<String>?,
                  var videoUrls: List<String>?) {
}

data class Question(var _partitionKey: String?, @Id var _id: String?, var text: String, var answers: List<Answer>?, var questionType: QuestionType,
                    var choices: List<String>?) {
}

data class Section(var sectionNumber: Int, var title: String, var description: String,
                   var questions: List<Question>) {
}


data class MonitorReport(var _partitionKey: String?, @Id var _id: String?, var monitorReportId: String?, var projectId: String,
                         var user: User, var rating: Rating, var photos: List<Photo>,
                         var videos: List<Video>, var description: String, var created: String, var position: Position) {}

data class QuestionnaireResponse(var _partitionKey: String?, @Id var _id: String?, var questionnaireResponseId: String?, var questionnaireId: String,
                                 var user: User, var sections: List<Section>) {}

const val FIELD_MONITOR = "FIELD_MONITOR";
const val ORG_ADMINISTRATOR = "ORG_ADMINISTRATOR";
const val ORG_EXECUTIVE = "FIELD_MONITOR";
const val NETWORK_ADMINISTRATOR = "NETWORK_ADMINISTRATOR";
