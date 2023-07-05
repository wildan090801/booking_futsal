import 'package:booking_futsal/cloud_firestore/booking_ref.dart';
import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/utils/time_slot.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateWatch = ref.watch(selectedDate);
    var timeWatch = ref.watch(selectedTime);
    var userWatch = ref.watch(userInformation);
    var fieldWatch = ref.watch(selectedField);
    var timeSlotWatch = ref.watch(selectedTimeSlot);
    BookingModel bookingModel = BookingModel();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              DateFormat.MMM('id').format(dateWatch),
                              style: whiteTextStyle.copyWith(fontSize: 18),
                            ),
                            Text(
                              '${dateWatch.day}',
                              style: whiteTextStyle.copyWith(
                                  fontSize: 28, fontWeight: bold),
                            ),
                            Text(
                              DateFormat.EEEE('id').format(dateWatch),
                              style: whiteTextStyle.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: dateWatch,
                          maxTime: dateWatch.add(const Duration(days: 31)),
                          onConfirm: (date) {
                        ref.read(selectedDate.notifier).state = date;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ScrollConfiguration(
              behavior: ScrollBehaviorWithoutGlow(),
              child: Expanded(
                child: FutureBuilder(
                  future: getTimeSlotOfField(
                    bookingModel,
                    DateFormat('dd_MM_yyyy').format(
                      ref.read(selectedDate),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var listTimeSlot = snapshot.data as List<int>;
                      return GridView.builder(
                        itemCount: timeSlot.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            ref.read(selectedTime.notifier).state =
                                timeSlot.elementAt(index);
                            ref.read(selectedTimeSlot.notifier).state = index;
                          },
                          child: Card(
                            color: ref.read(selectedTime.notifier).state ==
                                    timeSlot.elementAt(index)
                                ? Colors.white54
                                : Colors.white,
                            child: GridTile(
                              header: ref.read(selectedTime.notifier).state ==
                                      timeSlot.elementAt(index)
                                  ? const Icon(Icons.check)
                                  : null,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      timeSlot.elementAt(index),
                                      style:
                                          blackTextStyle.copyWith(fontSize: 16),
                                    ),
                                    Text(
                                      'Tersedia',
                                      style:
                                          blackTextStyle.copyWith(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: greyColor,
                      width: 2.5,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: InkWell(
                  onTap: () {
                    ref.read(selectedTime.notifier).state == ''
                        ? null
                        : showReviewBookingDialog(
                            context,
                            userWatch.name,
                            DateFormat('EEEE dd-MM-yyyy', 'id')
                                .format(dateWatch),
                            fieldWatch.fieldName,
                            '$timeWatch WIB',
                            userWatch.role, () {
                            confirmBooking(ref);
                          });
                  },
                  child: Container(
                    width: 150,
                    height: 38,
                    decoration: BoxDecoration(
                      color: ref.read(selectedTime.notifier).state == ''
                          ? greyColor
                          : blueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Booking',
                        style: whiteTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  confirmBooking(WidgetRef ref) async {
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
          '${ref.read(selectedTime.notifier).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.notifier).state)}'
    };

    //Code Submit on Firestore
    try {
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
      // Reset
      ref.read(selectedDate.notifier).state = DateTime.now();
      ref.read(selectedField.notifier).state = BookingModel();
      ref.read(selectedTime.notifier).state = '';
      ref.read(selectedTimeSlot.notifier).state = -1;
    } catch (error) {
      // Tambahkan logika penanganan kesalahan
      Text('$error');
    }
  }

  Future<void> showReviewBookingDialog(
    BuildContext context,
    String? namaPelanggan,
    String? jadwalBooking,
    String? jenisLapangan,
    String? jamMulai,
    String? role,
    VoidCallback? onTap,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.all(5),
        contentPadding: const EdgeInsets.all(25),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Review Booking',
                style: blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Pelanggan',
                          style: blackTextStyle.copyWith(fontWeight: bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          namaPelanggan!,
                          style: blackTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Jadwal Booking',
                          style: blackTextStyle.copyWith(fontWeight: bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          jadwalBooking!,
                          style: blackTextStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Text(
                          'Jenis Lapangan',
                          style: blackTextStyle.copyWith(fontWeight: bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          jenisLapangan!,
                          style: blackTextStyle,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Jam Mulai',
                          style: blackTextStyle.copyWith(fontWeight: bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          jamMulai!,
                          style: blackTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: onTap,
                // onTap: () {
                //   role == "admin"
                //       ? Navigator.pushNamed(context, '/admin-booking-success')
                //       : Navigator.pushNamed(
                //           context, '/customer-booking-success');
                // },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Booking',
                      style: whiteTextStyle.copyWith(fontWeight: semiBold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Batal',
                      style: blackTextStyle.copyWith(fontWeight: semiBold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
