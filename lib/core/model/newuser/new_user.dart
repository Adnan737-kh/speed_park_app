class NewUserModel{
  String? username;
  String? email;
  String? password;
  String? uid;
  String? location;
  String? userTyoe;

  NewUserModel({this.username, this.email, this.password,this.uid,this.location,this.userTyoe,});



  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'uid':uid,
      'location':location,
      'usertyoe':userTyoe,

    };
  }

  factory NewUserModel.fromMap(Map<String, dynamic> map) {
    return NewUserModel(
      username: map['username'],
      email: map['email'] ,
      password: map['password'] ,
      uid: map['uid'],
      location: map['location'],
      userTyoe: map['usertyoe'],

    );
  }
}