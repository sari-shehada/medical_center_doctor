import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../ui_utils/spacing_utils.dart';

class GenderToggleWidget extends StatelessWidget {
  const GenderToggleWidget({
    super.key,
    required this.isMale,
  });

  final Rx<bool> isMale;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD7F5EE),
        borderRadius: BorderRadius.circular(14.r),
      ),
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Obx(
        () => Row(
          children: [
            Text(
              'الجنس:',
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            AddHorizontalSpacing(value: 10.w),
            Text(
              isMale.value ? 'ذكر' : 'أنثى',
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isMale.value ? Colors.blue.withOpacity(0.2) : null,
              ),
              child: IconButton(
                onPressed: () => isMale.value = true,
                icon: Icon(
                  Icons.male,
                  color: isMale.value ? Colors.blue : null,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !isMale.value ? Colors.pink.withOpacity(0.2) : null,
              ),
              child: IconButton(
                onPressed: () => isMale.value = false,
                icon: Icon(
                  Icons.female,
                  color: !isMale.value ? Colors.pink : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
