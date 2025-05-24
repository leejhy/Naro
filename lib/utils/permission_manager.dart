import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:naro/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class PermissionManager {
  Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.storage.status;
        if (status.isDenied) {
          status = await Permission.storage.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status.isDenied) {
        status = await Permission.photos.request();
      }
    }
    print('status: $status');
    if (status.isLimited) {
      return true;
    }
    if(!status.isGranted) {
      const duration = 700;
      showAutoDismissDialog(context, 'permission_request'.tr(), durationMs: duration);
      await Future.delayed(Duration(milliseconds: duration));
      return false;
    }
    return true;
  }
}