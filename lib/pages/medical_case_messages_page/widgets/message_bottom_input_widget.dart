import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/ui_utils/spacing_utils.dart';

class MessageBottomInputWidget extends StatefulWidget {
  const MessageBottomInputWidget({
    super.key,
    required this.onSendPressed,
  });

  final void Function(types.PartialText, bool) onSendPressed;

  @override
  State<MessageBottomInputWidget> createState() =>
      _MessageBottomInputWidgetState();
}

class _MessageBottomInputWidgetState extends State<MessageBottomInputWidget> {
  late TextEditingController _textController;
  final isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool _sendButtonVisible = false;

  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (el) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        if (kIsWeb && _textController.value.isComposingRangeValid) {
          return KeyEventResult.ignored;
        }
        if (event is KeyDownEvent) {
          _handleSendPressed();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  void initState() {
    super.initState();

    _textController =
        options.textEditingController ?? InputTextFieldController();
    _handleSendButtonVisibilityModeChange();
  }

  void _handleSendButtonVisibilityModeChange() {
    _textController.removeListener(_handleTextControllerChange);
    if (options.sendButtonVisibilityMode == SendButtonVisibilityMode.hidden) {
      _sendButtonVisible = false;
    } else if (options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible = true;
    }
  }

  void _handleTextControllerChange() {
    if (_textController.value.isComposingRangeValid) {
      return;
    }
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  InputOptions get options => const InputOptions(
        sendButtonVisibilityMode: SendButtonVisibilityMode.always,
      );

  ChatTheme get theme => DefaultChatTheme(
        primaryColor: primaryColor,
        inputBorderRadius: BorderRadius.zero,
        inputBackgroundColor: Colors.white,
        inputElevation: 2,
        inputTextColor: Colors.black,
        messageBorderRadius: 14.r,
        messageInsetsVertical: 10.h,
        messageInsetsHorizontal: 15.w,
        inputPadding: EdgeInsets.only(
          top: 20.h,
          bottom: 20.h,
          right: 24.w,
          left: 50.w,
        ),
      );

  ChatL10n get l10n => const ChatL10nAr(
        emptyChatPlaceholder: 'ما من رسائل حتى الان',
        inputPlaceholder: 'الرسالة',
      );

  bool isCritical = false;
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final buttonPadding = theme.inputPadding.copyWith(left: 16, right: 16);
    final safeAreaInsets = isMobile
        ? EdgeInsets.fromLTRB(
            query.padding.left,
            0,
            query.padding.right,
            query.viewInsets.bottom + query.padding.bottom,
          )
        : EdgeInsets.zero;
    final textPadding = theme.inputPadding.copyWith(left: 0, right: 0).add(
          EdgeInsets.fromLTRB(
            24,
            0,
            _sendButtonVisible ? 0 : 24,
            0,
          ),
        );
    return Focus(
      autofocus: options.autofocus,
      child: Padding(
        padding: theme.inputMargin,
        child: Material(
          borderRadius: theme.inputBorderRadius,
          color: theme.inputBackgroundColor,
          surfaceTintColor: theme.inputSurfaceTintColor,
          elevation: theme.inputElevation,
          child: Container(
            decoration: theme.inputContainerDecoration,
            padding: safeAreaInsets,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                AddHorizontalSpacing(value: 10.w),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: isCritical ? Colors.red.shade100 : Colors.grey,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    duration: 1000.milliseconds,
                    curve: Curves.fastLinearToSlowEaseIn,
                    clipBehavior: Clip.hardEdge,
                    // padding: buttonPadding,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        isCritical = !isCritical;
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: 1000.milliseconds,
                          curve: Curves.fastLinearToSlowEaseIn,
                          style: TextStyle(
                            color:
                                isCritical ? Colors.red.shade800 : Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Jannat',
                          ),
                          child: Text(
                            isCritical ? 'عاجلة' : 'عادية',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AddHorizontalSpacing(value: 15.w),
                Expanded(
                  child: Padding(
                    padding: textPadding,
                    child: TextField(
                      enabled: options.enabled,
                      autocorrect: options.autocorrect,
                      autofocus: options.autofocus,
                      enableSuggestions: options.enableSuggestions,
                      controller: _textController,
                      cursorColor: theme.inputTextCursorColor,
                      decoration: theme.inputTextDecoration.copyWith(
                        hintStyle: theme.inputTextStyle.copyWith(
                          color: theme.inputTextColor.withOpacity(0.5),
                        ),
                        hintText: l10n.inputPlaceholder,
                      ),
                      focusNode: _inputFocusNode,
                      keyboardType: options.keyboardType,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: options.onTextChanged,
                      onTap: options.onTextFieldTap,
                      style: theme.inputTextStyle.copyWith(
                        color: theme.inputTextColor,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: buttonPadding.bottom + buttonPadding.top + 24,
                  ),
                  child: Visibility(
                    visible: _sendButtonVisible,
                    child: SendButton(
                      onPressed: _handleSendPressed,
                      padding: buttonPadding,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final partialText = types.PartialText(text: trimmedText);
      widget.onSendPressed(partialText, isCritical);

      if (options.inputClearMode == InputClearMode.always) {
        _textController.clear();
      }
    }
  }
}
