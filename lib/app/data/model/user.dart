import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? userid;
  @HiveField(3)
  String? username;
  @HiveField(4)
  String? profileUrl;

  UserModel(
      {this.name, this.email, this.userid, this.username, this.profileUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    userid = json['userid'];
    username = json['username'];
    profileUrl = json['profileUrl'];
  }
  Map<String, dynamic> toJson(UserModel user) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = user.name;
    data['email'] = user.email;
    data['userid'] = user.userid;
    data['username'] = user.username;
    data['profileUrl'] = user.profileUrl;
    return data;
  }
}

UserModel myUser = UserModel(
    name: 'amas',
    email: 'amas123@gmail.com',
    profileUrl:
        'https://images.unsplash.com/photo-1581348464577-9018bfcc22da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8aGFuc29tZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60',
    userid: 'aispdufhbp45',
    username: 'amas12345');
