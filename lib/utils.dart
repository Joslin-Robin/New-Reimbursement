import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';

class DeviceInfo {
  Future<void> read() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      this.id = BigInt.parse(androidInfo.androidId.toUpperCase(), radix: 16)
          .toRadixString(10)
          .replaceAllMapped(RegExp(".{4}"), (match) => "${match.group(0)} ")
          .replaceAll(' ', '-');
      this.model = androidInfo.model;
      this.os = androidInfo.version.baseOS;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      this.id = BigInt.parse(iosInfo.identifierForVendor.toUpperCase(),
              radix: 16)
          .toRadixString(10)
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
          .replaceAll(' ', '-');
      ;
      this.model = iosInfo.model;
      this.os = iosInfo.systemVersion;
    }
  }

  String model;
  String id;
  String os;
}
var formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
