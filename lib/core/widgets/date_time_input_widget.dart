import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../extensions/date_time_extensions.dart';
import '../ui_utils/spacing_utils.dart';

class DateTimeInputWidget extends StatelessWidget {
  const DateTimeInputWidget({
    super.key,
    required this.label,
    required this.pickDateCallback,
    required this.value,
    required this.chooseLabelPrompt,
    required this.valueDisplayText,
  });

  final String label;
  final String chooseLabelPrompt;
  final String Function(DateTime value) valueDisplayText;
  final VoidCallback pickDateCallback;
  final Rx<DateTime?> value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w),
            child: Text(
              label,
            ),
          ),
        ),
        AddVerticalSpacing(value: 15.h),
        Container(
          height: 60.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryContainer,
              width: 2.sp,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            onTap: () => pickDateCallback(),
            child: Center(
              child: Obx(
                () => Text(
                  value.value == null
                      ? chooseLabelPrompt
                      : valueDisplayText(value.value!),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateOfBirthInputWidget extends StatelessWidget {
  const DateOfBirthInputWidget({super.key, required this.dateOfBirth});

  final Rx<DateTime?> dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return DateTimeInputWidget(
      label: 'تاريخ الميلاد',
      pickDateCallback: () => chooseBirthDate(context),
      value: dateOfBirth,
      chooseLabelPrompt: 'اختيار تاريخ الميلاد',
      valueDisplayText: (value) => '${value.getDateOnly()} (إعادة الاختيار)',
    );
  }

  void chooseBirthDate(BuildContext context) async {
    DateTime? result = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ),
    );
    if (result != null) {
      dateOfBirth.value = result;
    }
  }
}
