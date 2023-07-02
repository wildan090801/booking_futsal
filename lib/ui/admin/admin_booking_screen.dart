import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/utils/time_slot.dart';
import 'package:booking_futsal/widgets/popup_dialog_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AdminBookingScreen extends StatelessWidget {
  const AdminBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
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
                              'Agustus',
                              style: whiteTextStyle.copyWith(fontSize: 18),
                            ),
                            Text(
                              '09',
                              style: whiteTextStyle.copyWith(
                                  fontSize: 28, fontWeight: bold),
                            ),
                            Text(
                              'Kamis',
                              style: whiteTextStyle.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: now,
                        maxTime: now.add(
                          const Duration(days: 31),
                        ),
                      );
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
                child: GridView.builder(
                  itemCount: timeSlot.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => Card(
                    child: GridTile(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeSlot.elementAt(index),
                              style: blackTextStyle.copyWith(fontSize: 16),
                            ),
                            Text(
                              'Tersedia',
                              style: blackTextStyle.copyWith(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
                    showReviewBookingDialog(
                      context,
                      'Admin Hap Hap Sports',
                      'Kamis 09-08-2023',
                      'Lapangan Futsal 1',
                      '10:00 WIB',
                      'Admin',
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 38,
                    decoration: BoxDecoration(
                      color: blueColor,
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
}
