import 'dart:io';

import 'package:adwaitha_sangamam/services/helpers.dart';
import 'package:flutter/scheduler.dart';

class CommonFunctions {
  static void afterInit(Function function) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      function();
    });
  }

  static bool connect = false;
  static Future<bool> checkInternetConnection({bool enableToast = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        if (enableToast) Helpers.successToast('No internet');
        return false;
      }
    } on SocketException catch (_) {
      if (enableToast) if (enableToast) Helpers.successToast('No internet');
      return false;
    }
  }
}
