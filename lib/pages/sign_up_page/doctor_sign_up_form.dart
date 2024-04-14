import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medical_center_doctor/pages/sign_up_page/doctor_sign_up_request.dart';

class DoctorSignUpForm {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  Rx<DateTime?> careerStartDate = Rx<DateTime?>(null);

  File? certificateImage;
  String? certificateImageExtension;
  Rx<bool> isMale = true.obs;

  String? validateForm() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty ||
        dateOfBirth.value == null ||
        careerStartDate.value == null ||
        certificateImage == null) {
      return 'يرجى ملئ جميع الحقول للمتابعة';
    }
    if (passwordConfirmationController.text != passwordController.text) {
      return 'كلمة المرور المدخلة لا تطابق حقل تأكيد كلمة المرور';
    }
    if (dateOfBirth.value!.isAfter(careerStartDate.value!)) {
      return 'لا يمكن لتاريخ مزاولة المهنة ان تكون قبل تاريخ الميلاد';
    }
    return null;
  }

  Future<dio.FormData> toDioFormData() async {
    DoctorSignUpRequest requestObject = DoctorSignUpRequest(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      password: passwordController.text,
      dateOfBirth: dateOfBirth.value!,
      careerStartDate: careerStartDate.value!,
      isMale: isMale.value,
    );
    var imageName = RandomStringGen.generateRandomNumberCombination();

    return dio.FormData.fromMap(
      {
        'certificateUrl': dio.MultipartFile.fromBytes(
          await certificateImage!.readAsBytes(),
          filename: '$imageName.$certificateImageExtension',
        ),
      }..addAll(
          requestObject.toMap(),
        ),
    );
  }

  void chooseCareerStartDate(BuildContext context) async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: dateOfBirth.value ?? DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      careerStartDate.value = result;
    }
  }

  Future<bool> pickCertificateImage() async {
    XFile? filePickerResult = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (filePickerResult == null) {
      return false;
    }
    certificateImage = File(filePickerResult.path);
    certificateImageExtension = filePickerResult.path.split('.').last;
    return true;
  }
}

class RandomStringGen {
  static String generateRandomNumberCombination({int length = 10}) {
    return List.generate(
      15,
      (index) => (Random().nextInt(10) + 48),
    ).join();
  }
}
