import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

class AdminCardHistory extends StatelessWidget {
  const AdminCardHistory({
    super.key,
    required this.jadwalBooking,
    required this.jamMulai,
    required this.jenisLapangan,
    required this.tanggalTransaksi,
    required this.namaPelanggan,
  });

  final String jadwalBooking;
  final String jamMulai;
  final String jenisLapangan;
  final String tanggalTransaksi;
  final String namaPelanggan;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 4,
              right: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggalTransaksi,
                  style:
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, top: 20, right: 12, bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
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
                              height: 20,
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
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jenis Lapangan',
                                  style:
                                      blackTextStyle.copyWith(fontWeight: bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  jenisLapangan,
                                  style: blackTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jam Mulai',
                                  style:
                                      blackTextStyle.copyWith(fontWeight: bold),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
