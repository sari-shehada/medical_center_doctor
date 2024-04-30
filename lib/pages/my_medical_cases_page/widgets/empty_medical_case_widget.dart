import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/ui_utils/spacing_utils.dart';

class EmptyMedicalCasesWidget extends StatelessWidget {
  const EmptyMedicalCasesWidget({
    super.key,
    required this.isEnded,
  });

  final bool isEnded;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              size: 75.sp,
              color: Colors.grey.shade700,
            ),
            AddVerticalSpacing(value: 25.h),
            Text(
              'لم يتم العثور على حالات طبية ${isEnded ? 'منتهية' : 'حالية'}',
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.grey.shade700,
              ),
            ),
            AddVerticalSpacing(value: 250.h),
          ],
        ),
      ),
    );
  }
}
