import 'dart:async';
import 'package:flutter/services.dart';

/// Service responsible for managing clipboard access and scheduled auto-clear.
class ClipboardService {
  Timer? _clearTimer;

  /// Copies [text] to system clipboard and schedules automatic clearance after [clearAfterSeconds].
  Future<void> copyWithAutoClear(String text, {required int clearAfterSeconds}) async {
    await Clipboard.setData(ClipboardData(text: text));

    _clearTimer?.cancel();
    if (clearAfterSeconds > 0) {
      _clearTimer = Timer(Duration(seconds: clearAfterSeconds), () async {
        final currentData = await Clipboard.getData(Clipboard.kTextPlain);
        if (currentData?.text == text) {
          await Clipboard.setData(const ClipboardData(text: ''));
        }
      });
    }
  }

  /// Cancels any scheduled clipboard clear operation.
  void dispose() {
    _clearTimer?.cancel();
  }
}
