import 'package:booking_futsal/controller/booking_controller.dart';
import 'package:booking_futsal/controller/field_controller.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/utils/time_slot.dart';
import 'package:booking_futsal/widgets/custom_dialog.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
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
    ref.watch(selectedTimeSlot);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            displayDate(context, ref),
            const SizedBox(
              height: 5,
            ),
            displayTimeSlot(ref),
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
                    ref.read(userInformation.notifier).state.email == null
                        ? Navigator.pushNamed(context, '/sign-in')
                        : ref.read(selectedTime.notifier).state == ''
                            ? null
                            : showReviewBookingDialog(
                                context,
                                userWatch.name,
                                DateFormat('EEEE dd-MM-yy', 'id')
                                    .format(dateWatch),
                                fieldWatch.fieldName,
                                '$timeWatch WIB', () {
                                BookingController.addBooking(context, ref);
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

  displayDate(BuildContext context, WidgetRef ref) {
    var dateWatch = ref.watch(selectedDate);
    return Container(
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
                  minTime: DateTime.now(),
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
    );
  }

  displayTimeSlot(WidgetRef ref) {
    var fieldWatch = ref.watch(selectedField);
    return ScrollConfiguration(
      behavior: ScrollBehaviorWithoutGlow(),
      child: Expanded(
        child: FutureBuilder(
          future: getMaxAvailableTimeSlot(
            ref.read(selectedDate.notifier).state,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var maxTimeSlot = snapshot.data as int;
              return FutureBuilder(
                future: FieldController.getTimeSlotOfField(
                  fieldWatch,
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
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: maxTimeSlot > index ||
                                  listTimeSlot.contains(index)
                              ? null
                              : () {
                                  ref.read(selectedTime.notifier).state =
                                      timeSlot.elementAt(index);
                                  ref.read(selectedTimeSlot.notifier).state =
                                      index;
                                },
                          child: Card(
                            color: maxTimeSlot > index ||
                                    listTimeSlot.contains(index)
                                ? Colors.white10
                                : ref.read(selectedTime.notifier).state ==
                                        timeSlot.elementAt(index)
                                    ? Colors.white60
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
                                      maxTimeSlot > index ||
                                              listTimeSlot.contains(index)
                                          ? 'Tidak Tersedia'
                                          : 'Tersedia',
                                      style:
                                          blackTextStyle.copyWith(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Text(
                  'Terdapat kesalahan saat mengakses\nslot jadwal booking',
                  style: blackTextStyle,
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
