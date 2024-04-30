import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:medical_center_doctor/models/doctor_info.dart';
import 'package:medical_center_doctor/pages/medical_case_messages_page/bottom_sheets/medical_case_options_bottom_sheet.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';

import '../../config/theme/app_colors.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/widgets/custom_future_builder.dart';
import '../../managers/account_manager.dart';
import '../../managers/medical_cases_manager.dart';

import 'models/case_message.dart';
import 'models/medical_case_messages.dart';
import 'widgets/message_bottom_input_widget.dart';

class MedicalCaseChatPage extends StatefulWidget {
  const MedicalCaseChatPage({
    super.key,
    required this.medicalCaseDetails,
  });

  final MedicalCaseDetails medicalCaseDetails;
  @override
  State<MedicalCaseChatPage> createState() => _MedicalCaseChatPageState();
}

class _MedicalCaseChatPageState extends State<MedicalCaseChatPage> {
  late Future<List<types.Message>> messagesFuture;
  late types.User user;
  late types.User patient;

  List<types.Message> _messages = [];

  bool isSendingMessage = false;
  bool isFetchingMessages = false;
  late Timer updateMessagesTimer;
  late bool hasEnded;
  @override
  void dispose() {
    updateMessagesTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    hasEnded = widget.medicalCaseDetails.medicalCase.status == 'ended';
    messagesFuture = getInitialMessages();
    createAndAssignUsers();
    initializeTimer();
    super.initState();
  }

  double get endedIndicatorContainerHight => 50.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'رسائل الحالة',
        ),
        actions: [
          IconButton(
            onPressed: () => showOptionsSheet(),
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            AnimatedPadding(
              duration: 400.milliseconds,
              curve: Curves.fastLinearToSlowEaseIn,
              padding: EdgeInsets.only(
                top: hasEnded ? endedIndicatorContainerHight : 0,
              ),
              child: CustomFutureBuilder(
                future: messagesFuture,
                builder: (context, snapshot) => Chat(
                  messages: _messages,
                  onSendPressed: (_) {},
                  customBottomWidget: MessageBottomInputWidget(
                    onSendPressed: _handleSendPressed,
                  ),
                  user: user,
                  theme: DefaultChatTheme(
                    userAvatarNameColors: const [
                      secondaryColor,
                    ],
                    primaryColor: primaryColor,
                    inputBorderRadius: BorderRadius.zero,
                    inputBackgroundColor: Colors.white,
                    inputElevation: 2,
                    inputTextColor: Colors.black,
                    messageBorderRadius: 14.r,
                    messageInsetsVertical: 10.h,
                    messageInsetsHorizontal: 15.w,
                  ),
                  l10n: const ChatL10nAr(
                    emptyChatPlaceholder: 'ما من رسائل حتى الان',
                    inputPlaceholder: 'الرسالة',
                  ),
                  inputOptions: const InputOptions(
                    sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                  ),
                  scrollPhysics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  showUserNames: true,
                  showUserAvatars: true,
                ),
              ),
            ),
            AnimatedContainer(
              duration: 400.milliseconds,
              curve: Curves.fastLinearToSlowEaseIn,
              height: hasEnded ? endedIndicatorContainerHight : 0,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5.h),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.15),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'هذه الحالة منتهية, لا يمكنك إرسال رسائل',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<types.Message>> getMessages() async {
    try {
      isFetchingMessages = true;
      int caseId = widget.medicalCaseDetails.medicalCase.id;
      MedicalCaseMessages caseMessages = await HttpService.parsedGet(
        endPoint: 'medicalCases/$caseId/',
        mapper: MedicalCaseMessages.fromJson,
      );
      if (caseMessages.hasEnded) {
        markCaseAsEnded();
      }
      return convertMessageObjects(caseMessages.messages);
    } finally {
      isFetchingMessages = false;
    }
  }

  List<types.Message> convertMessageObjects(
      List<CaseMessage> oldFormatMessages) {
    oldFormatMessages.sort((a, b) => a.id.compareTo(b.id));
    return oldFormatMessages
        .map<types.Message>(
          (e) => types.TextMessage(
            id: e.id.toString(),
            author: e.senderIsDoctor ? user : patient,
            text: e.message,
            createdAt: e.sentAt.millisecondsSinceEpoch,
            status: e.urgencyLevel == 'critical' ? types.Status.error : null,
            type: types.MessageType.text,
          ),
        )
        .toList();
  }

  Future<List<types.Message>> getInitialMessages() async {
    var result = await getMessages();
    _messages = result.reversed.toList();
    return _messages;
  }

  void _addMessage(types.Message message) {
    _messages.insert(0, message);
  }

  void _handleSendPressed(types.PartialText message, bool isCritical) async {
    if (hasEnded) {
      SnackBarService.showNeutralSnackbar('المحادثة منتهية');
      return;
    }
    isSendingMessage = true;
    try {
      var result = await HttpService.rawFullResponsePost(
        endPoint:
            'medicalCases/${widget.medicalCaseDetails.medicalCase.id}/sendMessage/',
        body: {
          'message': message.text,
          'senderIsDoctor': true,
          'urgencyLevel': isCritical ? 'critical' : 'normal',
        },
      );
      //Medical Case has ended
      if (result.statusCode == 400) {
        markCaseAsEnded();
      }
      var messagesResponse = MedicalCaseMessages.fromJson(result.body);
      addNewMessages(
        filterNewMessages(
          convertMessageObjects(
            messagesResponse.messages.reversed.toList(),
          ),
        ),
      );
    } finally {
      isSendingMessage = false;
    }
  }

  List<types.Message> filterNewMessages(List<types.Message> messages) {
    List<String> messageIds = _messages.map((e) => e.id).toList();
    return messages
        .where((element) => !messageIds.contains(element.id))
        .toList();
  }

  void addNewMessages(List<types.Message> messages) {
    for (types.Message element in messages) {
      _addMessage(element);
    }
    setState(() {});
  }

  Future<void> updateMessagesList() async {
    if (isSendingMessage || isFetchingMessages) return;
    var updatedList = await getMessages();
    if (isSendingMessage) return;
    addNewMessages(
      filterNewMessages(
        updatedList,
      ),
    );
  }

  void markCaseAsEnded() {
    if (hasEnded) return;
    updateMessagesTimer.cancel();
    hasEnded = true;
    MedicalCasesManager.instance.updateList();
    setState(() {});
  }

  void createAndAssignUsers() {
    DoctorInfo doctorInfo = AccountManager.instance.user!;
    user = types.User(
      id: 'd${doctorInfo.id}',
      firstName: doctorInfo.firstName,
    );
    patient = types.User(
      id: 'p${widget.medicalCaseDetails.patient.id}',
      firstName: widget.medicalCaseDetails.patient.firstName,
      lastName: widget.medicalCaseDetails.patient.lastName,
    );
  }

  void initializeTimer() {
    updateMessagesTimer = Timer.periodic(5.seconds, (timer) {
      updateMessagesList();
    });
    if (widget.medicalCaseDetails.medicalCase.status == 'ended') {
      updateMessagesTimer.cancel();
    }
  }

  Future<void> showOptionsSheet() async {
    var result = await Get.bottomSheet(
      MedicalCaseOptionsBottomSheet(
        caseDetails: widget.medicalCaseDetails,
      ),
    );
    if (result == true) {
      MedicalCasesManager.instance.updateList();
      Get.back();
      SnackBarService.showSuccessSnackbar(
        'تم انهاء الحالة المرضية',
      );
    }
  }
}
