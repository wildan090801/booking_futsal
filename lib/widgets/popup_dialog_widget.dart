import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

Future<void> showReviewBookingDialog(
  BuildContext context,
  String namaPelanggan,
  String jadwalBooking,
  String jenisLapangan,
  String jamMulai,
  String role,
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
                  flex: 4,
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
                        namaPelanggan,
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
                        jadwalBooking,
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
                  flex: 3,
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
                        jenisLapangan,
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
                        jamMulai,
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
              onTap: () {
                role == "Admin"
                    ? Navigator.pushNamed(context, '/admin-booking-success')
                    : Navigator.pushNamed(context, '/customer-booking-success');
              },
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
