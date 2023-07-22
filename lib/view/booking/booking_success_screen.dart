import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            width: MediaQuery.of(context).size.width,
            height: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: greenColor,
                  size: 180,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Berhasil Booking Lapangan!',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Silahkan datang tepat waktu sesuai\njadwal yang telah dibooking!',
                  style: greyTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Terlambat lebih dari 15 menit\nakandianggap batal!',
                  style: greyTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/main-screen');
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: whiteTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
