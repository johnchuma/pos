import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pos/utils/colors.dart';

Future sendNotification({
    List? tokenIdList, String? contents, String? heading,String? image}) async {
  try {
    await Dio().post('https://onesignal.com/api/v1/notifications',
        options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'}),
        data: {
          "app_id": "b7029800-f6e6-4ce5-a312-438e0d2ea029",
          "include_player_ids": tokenIdList,
          "headings": {"en": heading??"Welcome to the Powered POS"},
          "contents": {"en": contents??"We are excited to have you onboard"},
        });
  } on DioError catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
