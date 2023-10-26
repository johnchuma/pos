import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pos/utils/colors.dart';

Future sendNotification({
    List<String>? tokenIdList, String? contents, String? heading}) async {

  var status = await OneSignal.shared.getDeviceState();


 print(status?.userId);
  try {
    await Dio().post('https://onesignal.com/api/v1/notifications',
        options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'}),
        data: {
          "app_id": "b7029800-f6e6-4ce5-a312-438e0d2ea029",
          "include_player_ids": [status?.userId],
          "headings": {"en": "Welcome to the Trade Point"},
          "contents": {"en": "We are excited to have you onboard"},
        });
  } on DioError catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
