class SuperUserModel{

  String? username;
  String? email;
  String? password;
  String? userType;
  String? uid;


  SuperUserModel({this.username, this.email, this.password,this.userType,this.uid});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'userType': userType,
      'uid': uid,
    };
  }

  factory SuperUserModel.fromMap(Map<String, dynamic> map) {
    return SuperUserModel(
      username: map['username'],
      email: map['email'] ,
      password: map['password'] ,
      userType: map['userType'] ,
      uid: map['uid'] ,
    );
  }
}