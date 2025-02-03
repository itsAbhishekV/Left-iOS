import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

class ProfileBottomSheet extends ConsumerStatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  ConsumerState<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends ConsumerState<ProfileBottomSheet> {
  final _nameController = TextEditingController();
  bool isButtonDisabled = true;
  bool isLoading = false;

  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    final user = ref.read(userProvider);
    if (user != null) {
      _nameController.text = user.name;
      _selectedDate = DateTime.parse(user.dob);
    }
    super.initState();
  }

  void onSubmit() {
    if (_selectedDate == null || _nameController.text.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final name = _nameController.text;
    final dob = _selectedDate!.toIso8601String();
    final colorIndex = ref.watch(colorIndexProvider);

    final user = UserModel(name: name, dob: dob, colorIndex: colorIndex);
    // print('USER: ');
    // print(user.toJson());
    final sharedPrefs = SharedPrefsService();

    // saving to shared prefs.
    sharedPrefs.saveUserData(name, dob, colorIndex);

    // updating user state
    ref.read(userProvider.notifier).update((state) => user);

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  void showBottomDatePicker() {
    BottomPicker.date(
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: _selectedDate,
      backgroundColor: AppPalette.primary,
      pickerTextStyle: AppTextStyle.smallTitle.copyWith(
        color: Colors.white,
      ),
      maxDateTime: DateTime(2010),
      onSubmit: (date) {
        setState(() {
          _selectedDate = date;
        });
        _checkButtonState();
      },
      dismissable: true,
      displayCloseIcon: false,
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      pickerTitle: const SizedBox.shrink(),
      buttonWidth: 200.0,
    ).show(context);
  }

  void _checkButtonState() {
    // Check if both name and DOB are provided
    setState(() {
      isButtonDisabled = _nameController.text.isEmpty || _selectedDate == null;
    });
  }

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
                width: 140,
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  maxLength: 12,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'enter name here',
                    hintStyle: AppTextStyle.smallBody.copyWith(
                      color: Colors.grey.withAlpha(100),
                    ),
                  ),
                  onChanged: (value) {
                    // Update button state whenever name changes
                    _checkButtonState();
                  },
                ),
              ),
            ),
          ),

          // Editable Birthday Field
          GestureDetector(
            onTap: showBottomDatePicker,
            child: Container(
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
                trailing: SizedBox(
                  width: 140,
                  child: AbsorbPointer(
                    child: Text(
                      textAlign: TextAlign.right,
                      _selectedDate == null
                          ? ''
                          : DateFormat('d MMMM, yyyy').format(_selectedDate!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
              onPressed: isButtonDisabled
                  ? null
                  : () {
                      onSubmit();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        height: 14.0,
                        width: 14.0,
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : Text(
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
