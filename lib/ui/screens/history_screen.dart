import 'package:booking_futsal/cloud_firestore/user_ref.dart';
import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/utils/time_slot.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Riwayat',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: displayUserHistory(),
      ),
    );
  }

  displayUserHistory() {
    return FutureBuilder(
      future: getUserHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var userBookings = snapshot.data as List<BookingModel>;
          if (userBookings.isEmpty) {
            return const Center(
              child: Text('Tidak memiliki riwayat booking!'),
            );
          } else {
            return ListView.builder(
              itemCount: userBookings.length,
              itemBuilder: (context, index) {
                var history = userBookings[index];
                return Card(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Waktu Transaksi',
                                    style: blackTextStyle.copyWith(
                                        fontWeight: bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    history.transactionTime!,
                                    style: blackTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Jenis Lapangan',
                                    style: blackTextStyle.copyWith(
                                        fontWeight: bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    history.fieldName!,
                                    style: blackTextStyle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Waktu Booking',
                                        style: blackTextStyle.copyWith(
                                            fontWeight: bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${timeSlot.elementAt(history.slot!)} WIB',
                                        style: blackTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Jadwal Booking',
                                        style: blackTextStyle.copyWith(
                                            fontWeight: bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat('EEEE dd-MM-yyyy', 'id')
                                            .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            history.timeStamp!,
                                          ),
                                        ),
                                        style: blackTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
