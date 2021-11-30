import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id = "", name = "", email = "";
  Timestamp? createdTime;


  UserModel({this.id, this.name, this.createdTime, this.email});


  static UserModel fromMap(Map<String,dynamic> map){
    String? id = "", name = "", email = "";
    Timestamp? createdTime;

    id = map['id'] != null ? map['id'] : "";
    name = map['name'] != null ? map['name'] : "";
    email = map['email'] != null ? map['email'] : "";
    createdTime = map['createdTime'];


    return UserModel(
      id: id,
      name: name,
      createdTime: createdTime,
      email: email
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "id": id ?? '',
      "name": name ?? '',
      "email": email ?? '',
      "createdtime": createdTime,
    };
  }
}
