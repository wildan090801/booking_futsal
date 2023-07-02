import 'package:booking_futsal/model/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<BookingModel>> getFields() async {
  var fields = List<BookingModel>.empty(growable: true);
  var fieldRef = FirebaseFirestore.instance.collection('bookings');
  var snapshot = await fieldRef.get();
  for (var element in snapshot.docs) {
    fields.add(BookingModel.fromJson(element.data()));
  }
  return fields;
}
