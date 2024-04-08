import 'package:get/get.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/pages/dashboard/dashboard.dart';
import 'package:medical_center_doctor/pages/login_page/login_page.dart';
import 'package:medical_center_doctor/pages/pending_approval_page/pending_approval_page.dart';
import 'package:medical_center_doctor/pages/sign_up_page/sign_up_page.dart';

import 'loader_page/loader_page.dart';

abstract class NavigationController {
  static void navigateLoggedInUser() {
    if (AccountManager.instance.user!.isApproved) {
      toDashboard();
      return;
    }
    toPendingApprovalPage();
  }

  static void toPendingApprovalPage() {
    Get.offAll(
      () => const PendingApprovalPage(),
    );
  }

  static Future<void> toLoginPage({
    bool offAll = true,
    bool isUserRejected = false,
  }) async {
    if (offAll) {
      Get.offAll(
        () => LoginPage(
          isUserRejected: isUserRejected,
        ),
      );
      return;
    }
    Get.to(() => const LoginPage());
  }

  static Future<void> toSignUpPage() async {
    Get.offAll(() => const SignUpPage());
  }

  static Future<void> toLoaderPage() async {
    Get.offAll(
      () => const LoaderPage(),
    );
  }

  static Future<void> toDashboard() async {
    Get.offAll(
      () => const Dashboard(),
    );
  }
}
