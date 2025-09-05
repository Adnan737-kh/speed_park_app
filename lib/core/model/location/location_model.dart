
class LocationModel {
 final String? code;
  String? desc;
  String? staff;
  String? location;
  String? selectLocation;
  String? selectCharges;
  String? amount;
  String? perHour;
  String? totalAmountPerHour;
  String? taxCharge;
  String? totalAmountWithTax;
  String? uid;

  LocationModel({
      this.code,
      this.desc,
      this.staff,
      this.location,
      this.selectLocation,
      this.selectCharges,
      this.amount,
      this.perHour,
      this.totalAmountPerHour,
      this.taxCharge,
      this.totalAmountWithTax,this.uid});

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'desc': desc,
      'staff': staff,
      'location': location,
      'selectLocation': selectLocation,
      'selectCharges': selectCharges,
      'amount': amount,
      'perhour': perHour,
      'totalamountperhour': totalAmountPerHour,
      'taxCharge': taxCharge,
      'totoalamountwithtax': totalAmountWithTax,
      'uid':uid,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
        code: map['code'] ?? '',
      desc: map['desc'] as String,
      staff: map['staff'] as String,
      location: map['location'] as String,
      selectLocation: map['selectLocation'] as String,
      selectCharges: map['selectCharges'] as String,

      amount: map['amount'] as String,
      perHour: map['perhour'] as String,
      totalAmountPerHour: map['totalamountperhour'] as String,
      taxCharge: map['taxCharge'] as String,
      totalAmountWithTax: map['totoalamountwithtax'] as String,
      uid:map['uid']
    );
  }

}
