// coverage:ignore-file

import 'dart:async';
import 'package:flutter/material.dart';

///This mixin used for showing dialogs,overlay,bootomsheet,snackbars which automatically disposed
///when the stateful class use this class disposes.s
mixin GlobalHelper<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Completer<void> completer = Completer();

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

  void showCustomOverlay({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    _overlayEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Builder(
          builder: builder,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _animationController?.dispose();
  }

  Future<T?> showCustomBottomSheet({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = false,
    bool enableDrag = false,
    bool useSafeArea = true,
    double? elevation,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: builder,
      enableDrag: false,
      elevation: elevation,
    );
  }

  void hideBottomSheet({
    required BuildContext context,
  }) {
    Navigator.of(context).pop();
  }

  void hideDialog() {
    Navigator.of(context).pop();
  }

  void hideFlashOverlay() {
    if (!completer.isCompleted) {
      completer.complete();
    }
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
    hideFlashOverlay();
    hideOverlay();
    _animationController?.dispose();
    super.dispose();
  }
}
