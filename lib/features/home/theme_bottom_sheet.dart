import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

class ThemeBottomSheet extends ConsumerStatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  ConsumerState<ThemeBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends ConsumerState<ThemeBottomSheet> {
  void _changeThemeColor(int colorIndex, BuildContext context) {
    ref.read(themeProvider.notifier).changeThemeColor(colorIndex);
    print('Color Index: $colorIndex');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(32.0),
        Text(
          'DISPLAY',
          style: AppTextStyle.smallTitle.copyWith(
            color: Colors.grey,
          ),
        ),

        // Set Theme
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withAlpha(20),
                width: 0.8,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Theme"),
            trailing: GestureDetector(
              onTap: () {
                // Show CupertinoContextMenu immediately on tap
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      title: const Text('Select Theme Color'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(1, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('White'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(2, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Pink'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(3, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Red'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(4, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Yellow'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(5, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Green'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(6, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Purple'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _changeThemeColor(7, context);
                            Navigator.pop(context);
                          },
                          child: _buildActionLabel('Blue'),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDefaultAction: true,
                        child: const Text('Cancel'),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.color_lens,
                color: theme,
              ),
            ),
          ),
        ),

        const Gap(16.0),
      ],
    );
  }

  Widget _buildActionLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.smallTitle.copyWith(
        color: Colors.white,
        fontSize: 14.0,
      ),
    );
  }
}
