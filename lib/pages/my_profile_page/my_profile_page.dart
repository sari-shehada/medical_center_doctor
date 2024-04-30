import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/models/doctor_info.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final DoctorInfo doctor = AccountManager.instance.user!;
    return SizedBox.expand(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          AddVerticalSpacing(
            value: 20.h,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Icon(
              doctor.isMale ? Icons.male : Icons.female,
              size: 50.sp,
            ),
          ),
          AddVerticalSpacing(value: 15.h),
          Text(
            '${doctor.firstName} ${doctor.lastName}',
            style: TextStyle(fontSize: 22.sp),
          ),
          AddVerticalSpacing(value: 20.h),
          // Row(
          //   children: [
          //     const Text('البريد الالكتروني'),
          //     const Spacer(),
          //     Text(doctor.emailAddress),
          //   ],
          // ),
          // AddVerticalSpacing(value: 10.h),
          // Row(
          //   children: [
          //     const Text('رقم الهاتف'),
          //     const Spacer(),
          //     Text(doctor.phoneNumber)
          //   ],
          // ),
          // AddVerticalSpacing(value: 10.h),
          Row(
            children: [
              const Text('تاريخ بدء المهنة'),
              const Spacer(),
              Text(
                '${doctor.careerStartDate.year}-${doctor.careerStartDate.month}-${doctor.careerStartDate.day}',
              )
            ],
          ),
          AddVerticalSpacing(value: 10.h),
          Row(
            children: [
              const Text('تاريخ الولادة'),
              const Spacer(),
              Text(
                '${doctor.dateOfBirth.getDateOnly()}',
              )
            ],
          ),
          AddVerticalSpacing(value: 35.h),
          Text(
            'الشهادة',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          SizedBox(
            height: 250.h,
            child: Image.network(
              doctor.certificateUrl,
            ),
          ),
          AddVerticalSpacing(value: 20.h),
          Divider(
            indent: 20.w,
            endIndent: 20.w,
          ),
          OutlinedButton(
            onPressed: () => AccountManager.instance.logout(),
            child: const Text(
              'تسجيل الخروج',
            ),
          ),
          AddVerticalSpacing(value: 35.h),
        ],
      ),
    );
  }
}
