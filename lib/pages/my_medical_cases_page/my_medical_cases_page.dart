import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/core/widgets/custom_future_builder.dart';
import 'package:medical_center_doctor/managers/medical_cases_manager.dart';
import 'package:medical_center_doctor/pages/my_medical_cases_page/widgets/medical_case_list_widget_widget.dart';

class MyMedicalCasesPage extends StatefulWidget {
  const MyMedicalCasesPage({super.key});

  @override
  State<MyMedicalCasesPage> createState() => _MyMedicalCasesPageState();
}

class _MyMedicalCasesPageState extends State<MyMedicalCasesPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    MedicalCasesManager.instance.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddVerticalSpacing(
          value: 15.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.monitor_heart,
                size: 25.sp,
              ),
              AddHorizontalSpacing(value: 10.h),
              Text(
                'الحالات التي اشرف عليها',
                style: TextStyle(
                  fontSize: 19.sp,
                ),
              ),
            ],
          ),
        ),
        AddVerticalSpacing(value: 5.h),
        Expanded(
          child: CustomFutureBuilder(
            future: MedicalCasesManager.instance.medicalCases,
            builder: (context, snapshot) => Column(
              children: [
                TabBar(
                  controller: tabController,
                  indicatorWeight: .5.h,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'الحالات الحالية',
                        style: TextStyle(
                          fontSize: 16.h,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'الحالات المنتهية',
                        style: TextStyle(
                          fontSize: 16.h,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MedicalCaseListViewWidget(
                        cases: snapshot.currentCases,
                        isEnded: false,
                      ),
                      MedicalCaseListViewWidget(
                        cases: snapshot.endedCases,
                        isEnded: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
