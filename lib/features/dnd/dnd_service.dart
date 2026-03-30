import 'package:flutter/material.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'dart:io';

class DndService {
  static Future<bool> requestDndPermission(BuildContext context) async {
    if (!Platform.isAndroid) return true;
    
    final bool? isGranted = await FlutterDnd.isNotificationPolicyAccessGranted;
    if (isGranted ?? false) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Distractions'),
        content: const Text('To block all notifications during your focus session, this app needs Do Not Disturb permission. Would you like to enable it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
              FlutterDnd.gotoPolicySettings();
            },
            child: const Text('Enable DND'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> turnOnDnd() async {
    if (Platform.isAndroid) {
      final bool? isGranted = await FlutterDnd.isNotificationPolicyAccessGranted;
      if (isGranted ?? false) {
        await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
      }
    }
  }

  static Future<void> turnOffDnd() async {
    if (Platform.isAndroid) {
      final bool? isGranted = await FlutterDnd.isNotificationPolicyAccessGranted;
      if (isGranted ?? false) {
        await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
      }
    }
  }
}
