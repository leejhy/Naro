import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:naro/utils/utils.dart';

class PermissionManager {
  Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status; // 카메라 권한 요청
    // 결과 확인
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      print('iOS');
      status = await Permission.photos.request();
      print('ios status: $status');
    }

    if(!status.isGranted) { // 허용이 안된 경우
      const duration = 600;
      showAutoDismissDialog(context, '권한을 허용해주세요.', durationMs: duration);
      await Future.delayed(Duration(milliseconds: duration));
      return false;
    }
    return true;
  }
}