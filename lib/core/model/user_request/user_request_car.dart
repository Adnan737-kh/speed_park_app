class UserCarRequest{
  String? uid;
  String? platnumber;
  String? owner_name;

  UserCarRequest({this.uid, this.platnumber, this.owner_name});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'platnumber': this.platnumber,
      'owner_name': this.owner_name,
    };
  }

  factory UserCarRequest.fromMap(Map<String, dynamic> map) {
    return UserCarRequest(
      uid: map['uid'] as String,
      platnumber: map['platnumber'] as String,
      owner_name: map['owner_name'] as String,
    );
  }
}