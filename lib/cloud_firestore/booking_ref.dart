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

Future<List<int>> getTimeSlotOfField(
    BookingModel bookingModel, String date) async {
  List<int> result = List<int>.empty(growable: true);
  // Tambahkan Kode
  var bookingRef = FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingModel.fieldName)
      .collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  for (var doc in snapshot.docs) {
    var slot = int.tryParse(doc.id);
    if (slot != null) {
      result.add(slot);
    }
  }

  return result;
}
