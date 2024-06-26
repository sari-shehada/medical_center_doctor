import 'package:flutter/material.dart';
import 'package:medical_center_doctor/models/doctor_info.dart';
import 'package:medical_center_doctor/pages/navigation_controller.dart';

import '../core/exceptions/not_found_exception.dart';
import '../core/services/http_service.dart';
import '../core/services/shared_prefs_service.dart';

class AccountManager with ChangeNotifier {
  AccountManager._({
    this.user,
    required this.isLoggedIn,
  });

  DoctorInfo? user;
  bool isLoggedIn;

  static late AccountManager instance;

  static Future<AccountManager> init() async {
    try {
      final int? userId = _getUserIdFromLocalStorage();
      if (userId == null) {
        instance = AccountManager._(user: null, isLoggedIn: false);
        return instance;
      }
      final DoctorInfo user = await _getDoctorInfo(userId);
      instance = AccountManager._(user: user, isLoggedIn: true);
      return instance;
    } on NotFoundException catch (_) {
      instance = AccountManager._(user: null, isLoggedIn: false);
      NavigationController.toLoginPage(
        isUserRejected: true,
      );
      return instance;
    }
  }

  Future<void> login(DoctorInfo userInfo) async {
    await _saveUserIdToLocalStorage(userInfo.id);
    user = userInfo;
    isLoggedIn = true;
    notifyListeners();
  }

  static Future<DoctorInfo> _getDoctorInfo(int id) async {
    return await HttpService.parsedGet(
      endPoint: 'doctors/$id/',
      mapper: DoctorInfo.fromJson,
    );
  }

  static int? _getUserIdFromLocalStorage() {
    return SharedPreferencesService.instance.getInt('userId');
  }

  static Future<void> _saveUserIdToLocalStorage(int id) async {
    SharedPreferencesService.instance.setInt(
      key: 'userId',
      value: id,
    );
  }

  Future<void> logout() async {
    await SharedPreferencesService.instance.plugin.remove('userId');
    user = null;
    isLoggedIn = false;
    NavigationController.toLoginPage();
    notifyListeners();
  }
}
