import 'package:flutter/material.dart';
import 'package:supadots/core/exports.dart';

showBottomModalDialog({
  required BuildContext context,
  required List<Widget> children,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: AppPalette.primary,
    showDragHandle: true,
    enableDrag: true,
    context: context,
    builder: (BuildContext modalContext) => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Material(
        color: AppPalette.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 4.0,
          ).copyWith(bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    ),
  );
}
