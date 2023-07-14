import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> addBookingHistory(
    String userEmail, BookingModel bookingModel) async {
  try {
    // Mendapatkan referensi ke koleksi 'users' berdasarkan email pengguna
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Mendapatkan referensi dokumen pengguna berdasarkan email
    final userDoc = await usersCollection.doc(userEmail).get();

    // Jika dokumen pengguna sudah ada
    if (userDoc.exists) {
      // Membuat koleksi 'booking_history' jika belum ada di dalam dokumen pengguna
      final bookingHistoryRef = userDoc.reference.collection('booking_history');

      // Menambahkan data riwayat booking ke koleksi 'booking_history' dengan ID dokumen yang di-generate oleh Firestore
      await bookingHistoryRef.add(bookingModel.toJson());
    } else {
      const Text('Tidak dapat menemukan document User');
    }
  } catch (error) {
    Text('Terjadi kesalahan saat menambahkan riwayat booking: $error');
    // Lakukan penanganan kesalahan sesuai kebutuhan aplikasi Anda
  }
}

confirmBooking(BuildContext context, WidgetRef ref) async {
  var timeStamp = DateTime(
    ref.read(selectedDate.notifier).state.year,
    ref.read(selectedDate.notifier).state.month,
    ref.read(selectedDate.notifier).state.day,
    int.parse(
        ref.read(selectedTime.notifier).state.split(':')[0].substring(0, 2)),
    int.parse(
        ref.read(selectedTime.notifier).state.split(':')[1].substring(0, 2)),
  ).millisecondsSinceEpoch;
  var submitData = {
    'fieldName': ref.read(selectedField.notifier).state.fieldName,
    'customerName': ref.read(userInformation.notifier).state.name,
    'customerEmail': FirebaseAuth.instance.currentUser!.email,
    'done': false,
    'slot': ref.read(selectedTimeSlot.notifier).state,
    'timeStamp': timeStamp,
    'time':
        '${ref.read(selectedTime.notifier).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.notifier).state)}',
  };

  //Code Submit on Firestore
  try {
    final navigator = Navigator.of(context);
    final user = FirebaseAuth.instance.currentUser;

    // Dapatkan waktu saat ini saat melakukan booking
    var currentDateTime = DateTime.now();
    var transactionTime = DateFormat('dd-MM-yyyy').format(currentDateTime);

    // Tambahkan waktu transaksi ke data booking
    submitData['transactionTime'] = transactionTime;

    if (user != null) {
      final userEmail = user.email;
      final bookingModel = BookingModel.fromJson(submitData, userEmail);
      await addBookingHistory(userEmail!, bookingModel);
    }
    // Buat referensi koleksi "bookings"
    final bookingsCollection =
        FirebaseFirestore.instance.collection('bookings');

    // Dapatkan field name dari state notifier selectedField
    final fieldName = ref.read(selectedField.notifier).state.fieldName;

    // Buat referensi dokumen berdasarkan field name
    final fieldDoc = await bookingsCollection
        .where('fieldName', isEqualTo: fieldName)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first.reference);

    // Dapatkan tanggal booking dari state notifier selectedDate
    final DateTime dateWatch = ref.watch(selectedDate.notifier).state;

    // Buat referensi dokumen berdasarkan tanggal booking
    final dateDoc =
        fieldDoc.collection(DateFormat('dd_MM_yyyy').format(dateWatch));

    // Buat referensi dokumen berdasarkan slot waktu
    final slotDoc =
        dateDoc.doc(ref.read(selectedTimeSlot.notifier).state.toString());

    // Tambahkan data ke dokumen slot
    await slotDoc.set(submitData);

    // Tambahkan logika setelah berhasil mengirim data
    navigator.pushReplacementNamed('/booking-success');

    // Reset
    ref.read(selectedDate.notifier).state = DateTime.now();
    ref.read(selectedField.notifier).state = FieldModel();
    ref.read(selectedTime.notifier).state = '';
    ref.read(selectedTimeSlot.notifier).state = -1;
  } catch (error) {
    // Tambahkan logika penanganan kesalahan
    Text('$error');
  }
}

Stream<List<FieldModel>> getFieldsStream() {
  return FirebaseFirestore.instance
      .collection('bookings')
      .orderBy('fieldName', descending: false)
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => FieldModel.fromJson(doc.data()))
            .toList(),
      );
}

Future<void> deleteField(BuildContext context, String documentId) async {
  try {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(documentId)
        .delete();
    // ignore: use_build_context_synchronously
    showSuccessPopupFlushbar(context, 'Berhasil menghapus data lapangan');
  } catch (e) {
    showErrorPopupFlushbar(
        context, 'Terjadi kesalahan dalam menghapus lapangan');
  }
}

Future<List<int>> getTimeSlotOfField(FieldModel fieldModel, String date) async {
  List<int> result = [];
  try {
    var bookingRef = FirebaseFirestore.instance
        .collection('bookings')
        .where('fieldName', isEqualTo: fieldModel.fieldName)
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
  } catch (error) {
    Text('Gagal mengambil data time slots: $error');
  }

  return result;
}
