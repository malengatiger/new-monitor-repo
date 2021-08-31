import 'package:meta/meta.dart';

class Respondent {
  String? firstName, lastName, userId, email, cellphone, gender;

  Respondent({required this.firstName, required this.lastName,  this.email, this.cellphone,
    required this.gender,  });

  Respondent.fromJson(Map data) {
    this.firstName = data['firstName'];
    this.lastName = data['lastName'];
    this.userId = data['userId'];
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.gender = data['gender'];
  }
  Map<String, dynamic> toJson() {

    Map<String, dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
      'userId': userId,
      'email': email,
      'cellphone': cellphone,
      'gender': gender,
    };
    return map;
  }

}