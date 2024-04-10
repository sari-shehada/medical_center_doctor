import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/pages/dashboard/widgets/dashboard_top_header_widget.dart';
import 'package:medical_center_doctor/pages/my_medical_cases_page/my_medical_cases_page.dart';
import 'package:medical_center_doctor/pages/my_profile_page/my_profile_page.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/new_medical_cases_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  void changeCurrentPage(int index) {
    tabController.animateTo(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            AddVerticalSpacing(
              value: MediaQuery.paddingOf(context).top + 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: DashboardTopHeaderWidget(
                shouldHideUserChip: tabController.index == 2,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  MyMedicalCasesPage(),
                  NewMedicalCasesPage(),
                  MyProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabController.index,
        onTap: (value) => changeCurrentPage(value),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: FaIcon(
                FontAwesomeIcons.house,
                size: 18.sp,
              ),
            ),
            label: 'حالاتي',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: FaIcon(
                FontAwesomeIcons.fileMedical,
                size: 20.sp,
              ),
            ),
            label: 'حالات طبية جديدة',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 20.sp,
              ),
            ),
            label: 'ملفي الشخصي',
          ),
        ],
      ),
    );
  }
}
