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
  List<int> result = [];
  try {
    var bookingRef = FirebaseFirestore.instance
        .collection('bookings')
        .where('fieldName', isEqualTo: bookingModel.fieldName)
        .limit(1)
        .get()
        .then(
            (snapshot) => snapshot.docs.first.reference.collection(date).get());

    QuerySnapshot snapshot = await bookingRef;
    for (var doc in snapshot.docs) {
      var slot = int.tryParse(doc.id);
      if (slot != null) {
        result.add(slot);
      }
    }
    print('hasilnya: $result');
  } catch (error) {
    print('Error fetching time slots: $error');
  }

  return result;
}
