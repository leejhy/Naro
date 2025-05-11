import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:naro/utils/utils.dart';

class PermissionManager {
  Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if(!status.isGranted) {
      const duration = 600;
      showAutoDismissDialog(context, '권한을 허용해주세요.', durationMs: duration);
      await Future.delayed(Duration(milliseconds: duration));
      return false;
    }
    return true;
  }
}