import 'package:ntp/ntp.dart';

const timeSlot = {
  '08:00 - 09:00',
  '08:30 - 09:30',
  '09:00 - 10:00',
  '09:30 - 10:30',
  '10:00 - 11:00',
  '10:30 - 11:30',
  '11:00 - 12:00',
  '11:30 - 12:30',
  '12:00 - 13:00',
  '12:30 - 13:30',
  '13:00 - 14:00',
  '13:30 - 14:30',
  '14:00 - 15:00',
  '14:30 - 15:30',
  '15:00 - 16:00',
  '15:30 - 16:30',
  '16:00 - 17:00',
  '16:30 - 17:30',
  '17:00 - 18:00',
  '17:30 - 18:30',
  '18:00 - 19:00',
  '18:30 - 19:30',
  '19:00 - 20:00',
  '19:30 - 20:30',
  '20:00 - 21:00',
  '20:30 - 21:30',
  '21:00 - 22:00',
};

Future<int> getMaxAvailableTimeSlot(DateTime dt) async {
  DateTime now = dt.toLocal();
  int offset = await NTP.getNtpOffset(localTime: now);
  DateTime syncTime = now.add(Duration(milliseconds: offset));
  print('syncTime: $syncTime');
  if (syncTime.isBefore(DateTime(now.year, now.month, now.day, 8, 0))) {
    return 0;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 8, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 9, 0))) {
    return 1;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 8, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 9, 30))) {
    return 2;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 9, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 0))) {
    return 3;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 9, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 30))) {
    return 4;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 0))) {
    return 5;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 30))) {
    return 6;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 0))) {
    return 7;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 30))) {
    return 8;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 0))) {
    return 9;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 30))) {
    return 10;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 14, 0))) {
    return 11;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 14, 30))) {
    return 12;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 14, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 15, 0))) {
    return 13;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 14, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 15, 30))) {
    return 14;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 15, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 0))) {
    return 15;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 15, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 30))) {
    return 16;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 0))) {
    return 17;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 30))) {
    return 18;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 0))) {
    return 19;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 30))) {
    return 20;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 0))) {
    return 21;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 30))) {
    return 22;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 19, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 20, 0))) {
    return 23;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 19, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 20, 30))) {
    return 24;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 20, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 21, 0))) {
    return 25;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 20, 30)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 21, 30))) {
    return 26;
  } else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 21, 0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 22, 0))) {
    return 27;
  } else {
    return 28;
  }
}
