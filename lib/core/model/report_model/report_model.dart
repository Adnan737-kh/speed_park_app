class ReportModel{
  String? description;
  String? uid;
  String? time;
  String? date;

  ReportModel({this.description, this.uid, this.time,this.date});



  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'uid': uid,
      'time': time,
      'date':date,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      description: map['description'],
      uid: map['uid'] ,
      time: map['time'] ,
      date: map['date'],
    );
  }
}