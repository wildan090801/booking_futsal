import 'package:booking_futsal/controller/booking_controller.dart';
import 'package:booking_futsal/model/booking_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/utils/time_slot.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isAdmin = ref.read(userInformation.notifier).state.isAdmin;
    return isAdmin ? displayAdmin(ref) : displayUser();
  }

  Widget displayAdmin(WidgetRef ref) {
    final isSearching = ref.watch(isSearchingHistoryProvider.notifier).state;
    final searchHistoryController = TextEditingController();

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    bottom: 0,
                    child: Icon(
                      Icons.search,
                      color: greyColor,
                    ),
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 14),
                    controller: searchHistoryController,
                    onChanged: (value) {
                      ref.read(searchHistoryTextProvider.notifier).state =
                          value;
                      ref.read(isSearchingHistoryProvider.notifier).state =
                          value.isNotEmpty;
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nama pelanggan...',
                      hintStyle: greyTextStyle,
                      contentPadding: const EdgeInsets.only(
                        top: 15,
                        bottom: 6,
                        left: 35,
                        right: 15,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: FutureBuilder(
          future: getAllBookingHistory(),
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
                var searchHistoryText = ref
                    .read(searchHistoryTextProvider.notifier)
                    .state
                    .toLowerCase();

                var filteredBookings = userBookings.where((history) {
                  return history.customerName!
                          .toLowerCase()
                          .contains(searchHistoryText) ||
                      history.fieldName!
                          .toLowerCase()
                          .contains(searchHistoryText) ||
                      DateFormat('EEEE dd-MM-yyyy', 'id')
                          .format(
                            DateTime.fromMillisecondsSinceEpoch(
                              history.timeStamp!,
                            ),
                          )
                          .toLowerCase()
                          .contains(searchHistoryText) ||
                      history.transactionTime!
                          .toLowerCase()
                          .contains(searchHistoryText);
                }).toList();

                if (filteredBookings.isEmpty && isSearching) {
                  return const Center(
                    child: Text('Tidak ada riwayat booking yang sesuai.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      var history = filteredBookings[index];
                      return Card(
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 10,
                          right: 10,
                        ),
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Nama Pelanggan',
                                    style: blackTextStyle.copyWith(
                                        fontWeight: bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    history.customerName!,
                                    style: blackTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    flex: 4,
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
                                              DateFormat(
                                                      'EEEE dd-MM-yyyy', 'id')
                                                  .format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
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
            }
          },
        ),
      ),
    );
  }

  displayUser() {
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
        child: FutureBuilder(
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
                      margin:
                          const EdgeInsets.only(top: 15, left: 10, right: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  flex: 4,
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
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
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
        ),
      ),
    );
  }
}
