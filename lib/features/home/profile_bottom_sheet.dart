import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:left/core/theme.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQueryData.viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20.0),

          Text(
            'PROFILE',
            style: AppTextStyle.smallTitle.copyWith(
              color: Colors.grey,
            ),
          ),

          // Editable Name Field
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
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text("Your name"),
              trailing: SizedBox(
                width: 120,
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'enter name here',
                    hintStyle: AppTextStyle.smallBody.copyWith(
                      color: Colors.grey.withAlpha(100),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Editable Birthday Field
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
              leading: const Icon(Icons.cake, color: Colors.red),
              title: const Text("Your birthday"),
              trailing: GestureDetector(
                // onTap: () => _selectDate(context),
                child: SizedBox(
                  width: 120,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _birthdayController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(8.0),

          // Informational Text
          Text(
            "The name and birthday is used for the Life view, which is based on a standard life expectancy of 82 years.",
            style: AppTextStyle.smallBody.copyWith(
              color: Colors.grey,
              fontSize: 10.0,
            ),
          ),

          const Gap(16.0),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Save".toUpperCase(),
                style: AppTextStyle.smallTitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const Gap(12.0),
        ],
      ),
    );
  }
}
