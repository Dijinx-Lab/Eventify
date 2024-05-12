import 'package:eventify/models/api_models/user_response/user_detail.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/avatars/name_avatar.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  late PhoneNumber _phoneNumber;
  // final ImagePicker _picker = ImagePicker();
  // bool isPhotoTaken = false;
  // String? imagePath;

  @override
  void initState() {
    _firstNameController.text = PrefUtils().getFirstName;
    _lastNameController.text = PrefUtils().getLasttName;
    _emailController.text = PrefUtils().getEmail;
    _phoneController.text = PrefUtils().getPhone;
    _ageController.text = PrefUtils().getAge.toString() == "0"
        ? ""
        : PrefUtils().getAge.toString();
    //print(PrefUtils().getCountryCode);
    if (PrefUtils().getCountryCode != '') {
      _phoneNumber = PhoneNumber(
          isoCode: 'PK',
          dialCode: PrefUtils().getCountryCode,
          phoneNumber: PrefUtils().getPhone);
    } else {
      _phoneNumber = PhoneNumber(isoCode: 'PK');
    }

    super.initState();
  }

  bool _frontendValidation() {
    bool isValid = false;
    String errorText = "";

    if (_firstNameController.text.isEmpty) {
      errorText = "First name is required";

      isValid = false;
    } else if (_lastNameController.text.isEmpty) {
      errorText = "Last name is required";

      isValid = false;
    } else if (_ageController.text.isEmpty) {
      errorText = "Age is required";
      isValid = false;
    } else if (_emailController.text.isEmpty) {
      errorText = "Email is required";
      isValid = false;
    } else if (_phoneController.text.isEmpty) {
      errorText = "Phone number is required";

      isValid = false;
    } else {
      isValid = true;
    }

    if (!isValid) {
      ToastUtils.showCustomSnackbar(
        context: context,
        icon: const Icon(
          Icons.cancel_outlined,
          color: ColorStyle.whiteColor,
        ),
        contentText: errorText,
      );
    }
    return isValid;
  }

  // Future<void> openCamera() async {
  //   var status = await Permission.camera.request();
  //   XFile? xfile = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 100,
  //       preferredCameraDevice: CameraDevice.front);
  //   if (xfile != null && await File(xfile.path).exists()) {
  //     imagePath = xfile.path;
  //     if (mounted) {
  //       setState(() {
  //         isPhotoTaken = true;
  //       });
  //     }
  //   }
  // }

  // Future<void> openImages() async {
  //   var status;
  //   if (Platform.isAndroid) {
  //     status = await Permission.storage.request();
  //   } else {
  //     status = await Permission.photos.request();
  //   }
  //   XFile? xfile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 100,
  //   );
  //   if (xfile != null && await File(xfile.path).exists()) {
  //     imagePath = xfile.path;
  //     if (mounted) {
  //       setState(() {
  //         isPhotoTaken = true;
  //       });
  //     }
  //   }
  // }

  _updateProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService()
        .updateProfile(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _phoneController.text.trim().replaceAll(' ', ''),
            _phoneNumber.dialCode ?? '+92',
            null,
            null,
            null,
            _ageController.text.trim())
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          _saveUserData(apiResponse.data!.user!);
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: "Profile updated",
            icon: const Icon(
              Icons.celebration_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: "Please check your connection and try again later",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _saveUserData(UserDetail userDetail) {
    PrefUtils().setFirstName = userDetail.firstName ?? "";
    PrefUtils().setLasttName = userDetail.lastName ?? "";
    PrefUtils().setAge = int.tryParse(userDetail.age ?? '0') ?? 0;
    PrefUtils().setCountryCode = userDetail.countryCode ?? "";
    PrefUtils().setPhone = userDetail.phone ?? "";
    PrefUtils().setEmail = userDetail.email ?? "";
    PrefUtils().setToken = userDetail.authToken ?? "";
    PrefUtils().setNotificationsEnabled =
        userDetail.notificationsEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ColorStyle.secondaryTextColor,
          ),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                //_openOptionsSheet();
                              },
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: Stack(
                                  children: [
                                    NameAvatar(
                                        firstName: PrefUtils().getFirstName,
                                        lastName: PrefUtils().getLasttName),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(200),
                                    //   child: Center(
                                    //     child: SizedBox(
                                    //         height: 70,
                                    //         width: 70,
                                    //         child: Image.asset(
                                    //           "assets/pngs/image_placeholder.png",
                                    //           fit: BoxFit.cover,
                                    //         )),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //   bottom: 0,
                                    //   right: 0,
                                    //   child: Container(
                                    //     height: 20,
                                    //     width: 20,
                                    //     decoration: BoxDecoration(
                                    //         color: ColorStyle.primaryColor,
                                    //         borderRadius:
                                    //             BorderRadius.circular(6)),
                                    //     child: const Icon(
                                    //       Icons.edit,
                                    //       color: ColorStyle.whiteColor,
                                    //       size: 12,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "First name",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _firstNameController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Last name",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _lastNameController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Age",
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      AbsorbPointer(
                        absorbing: true,
                        child: CustomTextField(
                          controller: _emailController,
                          borderColor: ColorStyle.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Phone",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: ColorStyle.secondaryTextColor)),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              _phoneNumber = number;
                            });
                          },
                          onInputValidated: (bool value) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            useBottomSheetSafeArea: true,
                          ),
                          spaceBetweenSelectorAndTextField: 0,
                          ignoreBlank: false,
                          hintText: "Phone",
                          initialValue: _phoneNumber,
                          textFieldController: _phoneController,
                          inputDecoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: InputBorder.none,
                          ),
                          formatInput: true,
                          keyboardType: const TextInputType.numberWithOptions(),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 50,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: ColorStyle.blackColor.withOpacity(0.25))
                  ]),
              child: CustomRoundedButton(
                'Save',
                () {
                  // bool isFirstNameChanged =
                  //     PrefUtils().getFirstName != _firstNameController.text;
                  // bool isLastNameChanged =
                  //     PrefUtils().getLasttName != _lastNameController.text;
                  // bool isPhoneChanged = PrefUtils().getPhone !=
                  //     _phoneController.text.trim().replaceAll(' ', '');
                  // bool isCountryCodeChanged = PrefUtils().getCountryCode !=
                  //     (_phoneNumber.dialCode ?? '+92');
                  if (_frontendValidation()) {
                    _updateProfile();
                  }
                },
                roundedCorners: 12,
                textWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _openOptionsSheet() {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) => Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             child: CupertinoActionSheet(
  //               actions: [
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Navigator.of(context).pop();
  //                     await openCamera();
  //                   },
  //                   child: Container(
  //                       height: 60,
  //                       color: Colors.white,
  //                       child: Container(
  //                         // margin: const EdgeInsets.only(left: 25),
  //                         child: const Center(
  //                           child: Text("Camera",
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: ColorStyle.primaryTextColor)),
  //                         ),
  //                       )),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Navigator.of(context).pop();
  //                     await openImages();
  //                   },
  //                   child: Container(
  //                       height: 60,
  //                       color: Colors.white,
  //                       child: const Center(
  //                         child: Text("Gallery",
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: ColorStyle.primaryTextColor)),
  //                       )),
  //                 ),
  //               ],
  //               cancelButton: GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Container(
  //                       height: 60,
  //                       decoration: BoxDecoration(
  //                           color: ColorStyle.primaryColor,
  //                           borderRadius: BorderRadius.circular(12)),
  //                       child: const Center(
  //                         child: Text("Cancel",
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: ColorStyle.whiteColor)),
  //                       ))),
  //             ),
  //           ));
  // }
}
