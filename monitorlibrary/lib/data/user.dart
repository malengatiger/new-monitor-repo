import 'package:meta/meta.dart';

class User {
  String firstName, lastName, userId, email, cellphone, gender, userType, organizationId;

  User({@required this.firstName, @required this.lastName,  @required this.email, this.cellphone,
    @required this.gender, @required this.userType, @required this.organizationId});

  User.fromJson(Map data) {
    this.firstName = data['firstName'];
    this.lastName = data['lastName'];
    this.userId = data['userId'];
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.gender = data['gender'];
    this.userType = data['userType'];
    this.organizationId = data['organizationId'];
  }
  Map<String, dynamic> toJson() {

    Map<String, dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
      'userId': userId,
      'email': email,
      'cellphone': cellphone,
      'gender': gender,
      'userType': userType,
      'organizationId': organizationId,
    };
    return map;
  }

}