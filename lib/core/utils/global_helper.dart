import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

mixin GlobalHelper<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Completer<void> completer = Completer();

  void showLoadingOverlay({
    required BuildContext context,
  }) {
    showCustomOverlay(
      context: context,
      builder: (context) => ColoredBox(
        color: Colors.black.withOpacity(0.2),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void showCProgressOverlay({
    required BuildContext context,
    required TickerProvider vsync,
  }) {
    _animationController = AnimationController(
      vsync: vsync,
      value: 0,
    );

    showCustomOverlay(
      context: context,
      builder: (context) => ColoredBox(
        color: Colors.black54,
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController!.view,
            builder: (BuildContext context, Widget? child) {
              return CircularProgressIndicator(
                value: _animationController?.value,
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  set updateProgress(double value) {
    _animationController?.value = value;
  }

  Future<S?> showCustomDialog<S>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? routerName,
    bool barrierDismissible = true,
  }) {
    return showDialog<S>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      routeSettings: routerName != null ? RouteSettings(name: routerName) : null,
      builder: (BuildContext buildContext) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return pageChild;
            },
          ),
        );
      },
    );
  }

  void showSnack(
    BuildContext context, {
    Widget? content,
    String? text,
    Color? backgroundColor,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 5,
        duration: duration ?? const Duration(seconds: 2),
        content: content ??
            Text(
              '$text',
              style: const TextStyle(),
            ),
        backgroundColor: backgroundColor ?? Colors.red,
      ),
    );
  }

  void showSuccessSnack(
    BuildContext context, {
    String? text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.vertical,
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height - 160,
          left: 10,
          right: 10,
        ),
        padding: EdgeInsets.zero,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 19),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/check.svg',
                  height: 50.h,
                  width: 50.h,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    '$text',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void showErrorSnack(
    BuildContext context, {
    String? text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.vertical,
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height - 160,
          left: 10,
          right: 10,
        ),
        padding: EdgeInsets.zero,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 19),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/error.svg',
                  height: 50.h,
                  width: 50.h,
                ),
                10.horizontalSpace,
                SizedBox(
                  width: 266.w,
                  child: Text(
                    '$text',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: -0.05,
                      fontSize: 14.sp,
                      height: 24.h / 14.sp,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void showCustomOverlay({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    if (_overlayEntry != null) {
      hideOverlay();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Builder(
        builder: builder,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    _animationController?.dispose();
  }

  void hideDialog() {
    Navigator.of(context).pop();
  }

  void hideKeyboard() {
    if (context.mounted) {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
