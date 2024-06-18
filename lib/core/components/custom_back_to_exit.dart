import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDoubleBackToExitWidget extends StatefulWidget {
  const CustomDoubleBackToExitWidget({
    super.key,
    required this.child,
    this.onDoubleBack,
    this.behavior,
  });
  final Widget child;
  final FutureOr<bool> Function()? onDoubleBack;
  final SnackBarBehavior? behavior;

  @override
  State<CustomDoubleBackToExitWidget> createState() =>
      _DoubleBackToCloseMobileState();
}

class _DoubleBackToCloseMobileState
    extends State<CustomDoubleBackToExitWidget> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // * Web
    if (kIsWeb) return widget.child;

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(milliseconds: 1350)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Press back again to exit',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
          duration: const Duration(milliseconds: 1350),
          backgroundColor: const Color.fromARGB(101, 0, 0, 0),
          behavior: widget.behavior,
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(10),
          width: MediaQuery.sizeOf(context).width / 3,
        ));
        return false;
      }

      if (widget.onDoubleBack != null) return await widget.onDoubleBack!();

      return true;
    }

    // * Android
    if (Platform.isAndroid) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: widget.child,
      );
    }

    // * IOS
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) async {
          if (details.delta.dx > 8) await onWillPop();
        },
        child: widget.child,
      ),
    );
  }
}
