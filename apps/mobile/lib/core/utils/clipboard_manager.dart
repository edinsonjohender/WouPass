import 'dart:async';
import 'package:flutter/services.dart';
import 'package:woupassv2/core/constants/app_constants.dart';

class ClipboardManager {
  Timer? _clearTimer;

  void copyAndClear(String text, {int? clearAfterSeconds}) {
    Clipboard.setData(ClipboardData(text: text));

    _clearTimer?.cancel();
    _clearTimer = Timer(
      Duration(seconds: clearAfterSeconds ?? AppConstants.defaultClipboardClearSeconds),
      () => Clipboard.setData(const ClipboardData(text: '')),
    );
  }

  void dispose() {
    _clearTimer?.cancel();
  }
}
