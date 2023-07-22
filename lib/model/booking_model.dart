import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? docId;
  String? fieldName;
  String? customerName;
  String? customerEmail;
  String? status;
  int? slot;
  int? timeStamp;
  String? time;
  String? transactionTime;

  DocumentReference? reference;

  BookingModel({
    this.docId,
    this.fieldName,
    this.customerName,
    this.customerEmail,
    this.status,
    this.slot,
    this.timeStamp,
    this.time,
    this.transactionTime,
  });

  BookingModel.fromJson(Map<String, dynamic> json, this.docId) {
    fieldName = json['fieldName'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    status = json['status'];
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    timeStamp = int.parse(
        json['timeStamp'] == null ? '-1' : json['timeStamp'].toString());
    time = json['time'];
    transactionTime = json['transactionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldName'] = fieldName;
    data['customerName'] = customerName;
    data['customerEmail'] = customerEmail;
    data['status'] = status;
    data['slot'] = slot;
    data['timeStamp'] = timeStamp;
    data['time'] = time;
    data['transactionTime'] = transactionTime;

    return data;
  }
}
