import 'dart:io';

import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/user_response/user_detail.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/auth_util.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

class SignUpScreen extends StatefulWidget {
  final SignupArgs args;
  const SignUpScreen({super.key, required this.args});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ScrollController _scrollControlller = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confPwdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneSignInPhoneController =
      TextEditingController();
  final TextEditingController _phoneSignInPwdController =
      TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String initialCountry = 'PK';
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PK');
  PhoneNumber _phoneSignInNumber = PhoneNumber(isoCode: 'PK');

  bool isPwdVisible = false;
  bool isSignupSeleted = true;
  bool isTermsChecked = false;
  bool isErrorEnforced = false;
  bool isCodeResent = false;

  final ImagePicker picker = ImagePicker();
  bool isPhotoTaken = false;
  String? imagePath;
  UserService userService = UserService();

  final FocusNode focusNode = FocusNode();
  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
        color: Color.fromRGBO(70, 69, 66, 1),
        fontSize: 30,
        fontWeight: FontWeight.w400),
  );
  final cursor = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 21,
      height: 1,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(137, 146, 160, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  @override
  void initState() {
    isSignupSeleted = widget.args.isSignupSelected;
    super.initState();
  }

  _resetFields() {
    setState(() {
      _emailController.text = "";
      _pwdController.text = "";
      _confPwdController.text = "";
      _ageController.text = "";
      _phoneNumber = PhoneNumber(isoCode: 'PK');
      _phoneController.text = "";
      _otpController.text = "";
      _firstNameController.text = "";
      _lastNameController.text = "";
      isSignupSeleted = !isSignupSeleted;
    });
  }

  _navigatorFunction() {
    if (PrefUtils().getAppPreference == "new") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(roleSelectionRoute, (e) => false);
    } else if (PrefUtils().getAppPreference == "viewer") {
      PrefUtils().setIsAppTypeCustomer = true;
      Navigator.of(context).pushNamedAndRemoveUntil(
          mainRoute, arguments: MainArgs(0), (e) => false);
    } else {
      PrefUtils().setIsAppTypeCustomer = false;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
    }
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
  //       _navigatorFunction();
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
  //       _navigatorFunction();
  //     }
  //   }
  // }

  bool _frontendValidation() {
    bool isValid = false;
    String errorText = "";
    if (isSignupSeleted) {
      if (_firstNameController.text.isEmpty) {
        errorText = "First name is required";

        isValid = false;
      } else if (_lastNameController.text.isEmpty) {
        errorText = "Last name is required";

        isValid = false;
      } else if (_emailController.text.isEmpty) {
        errorText = "Email is required";
        isValid = false;
      } else if (_phoneController.text.isEmpty) {
        errorText = "Phone number is required";

        isValid = false;
      } else if (_pwdController.text.isEmpty) {
        errorText = "Password is required";

        isValid = false;
      } else if (_pwdController.text != _confPwdController.text) {
        errorText = "Passwords do not match";
        isValid = false;
      } else if (!isTermsChecked) {
        errorText = "You'll need to agree with our terms and conditions";
        isValid = false;
      } else {
        isValid = true;
      }
    } else {
      if (_emailController.text.isEmpty) {
        errorText = "Email or a phone number is required";
        isValid = false;
      } else if (_pwdController.text.isEmpty) {
        errorText = "Password is required";
        isValid = false;
      } else {
        isValid = true;
      }
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

  Future<String?> _getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    return await _firebaseMessaging.getToken();
  }

  _signIn() async {
    String? token = await _getFcmToken();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    userService
        .signIn(_emailController.text.trim(), _pwdController.text.trim(), token)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          _saveUserData(apiResponse.data!.user!);
          _navigatorFunction();
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
      } else if (value.error == '403') {
        _showCodeSentDialog();
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

  _ssoGoogle() async {
    String? token = await _getFcmToken();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    AuthUtil.signInWithGoogle().then((userCredential) {
      if (userCredential != null) {
        String? email = userCredential.user?.email;
        String? name = userCredential.user?.displayName ??
            userCredential.user?.providerData[0].displayName;
        String googleId = userCredential.user!.uid;
        userService
            .sso(
          email,
          name,
          googleId,
          null,
          token,
        )
            .then((value) async {
          SmartDialog.dismiss();
          if (value.error == null) {
            UserResponse apiResponse = value.snapshot;
            if (apiResponse.success ?? false) {
              _saveUserData(apiResponse.data!.user!);
              _navigatorFunction();
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
    });
  }

  _signUp() async {
    String? token = await _getFcmToken();
    String fname = _firstNameController.text.trim();
    String lname = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String pwd = _pwdController.text.trim();
    String cPwd = _confPwdController.text.trim();
    int age = int.parse(_ageController.text.trim());
    String countryCode = _phoneNumber.dialCode ?? '+92';
    String phone = _phoneController.text.trim().replaceAll(' ', '');
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    userService
        .signUp(
      fname,
      lname,
      email,
      pwd,
      cPwd,
      age,
      countryCode,
      phone,
      token,
    )
        .then((value) async {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          _saveUserData(apiResponse.data!.user!, loggedIn: false);
          _showCodeSentDialog();
          //_navigatorFunction();
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

  _signInWithPhone() async {
    String? token = await _getFcmToken();
    if (mounted) Navigator.of(context).pop();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    userService
        .signInWithPhone(
      _phoneSignInNumber.dialCode ?? '+92',
      _phoneSignInPhoneController.text.trim().replaceAll(' ', ''),
      _phoneSignInPwdController.text.trim(),
      token,
    )
        .then((value) async {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          _saveUserData(apiResponse.data!.user!);

          _navigatorFunction();
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

  _saveUserData(UserDetail userDetail, {bool loggedIn = true}) {
    PrefUtils().setFirstName = userDetail.firstName ?? "";
    PrefUtils().setLasttName = userDetail.lastName ?? "";
    PrefUtils().setAge = int.tryParse(userDetail.age ?? '0') ?? 0;
    PrefUtils().setCountryCode = userDetail.countryCode ?? "";
    PrefUtils().setPhone = userDetail.phone ?? "";
    PrefUtils().setEmail = userDetail.email ?? "";
    PrefUtils().setToken = userDetail.authToken ?? "";
    PrefUtils().setSignInMethod = userDetail.loginMethod ?? "";
    PrefUtils().setIsUserLoggedIn = loggedIn;
    PrefUtils().setAppPreference = userDetail.appSidePreference ?? "new";
    PrefUtils().setNotificationsEnabled =
        userDetail.notificationsEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SingleChildScrollView(
          controller: _scrollControlller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SvgPicture.asset('assets/svgs/login_ellipse_alt.svg',
                      width: MediaQuery.of(context).size.width),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                          'assets/svgs/ic_eventify_seller_logo.svg',
                          width: 200),
                    ),
                  ),
                  Visibility(
                    visible: Navigator.canPop(context),
                    child: Positioned(
                      left: 15,
                      top: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_back,
                            color: ColorStyle.whiteColor,
                            size: 30,
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: _resetFields,
                            child: Column(
                              children: [
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: isSignupSeleted
                                          ? ColorStyle.primaryTextColor
                                          : ColorStyle.secondaryTextColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  height: 5,
                                  width: isSignupSeleted ? 65 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSignupSeleted
                                          ? ColorStyle.primaryColorLight
                                          : Colors.transparent),
                                )
                              ],
                            ),
                          );
                        }),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: _resetFields,
                          child: Column(
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                    color: !isSignupSeleted
                                        ? ColorStyle.primaryTextColor
                                        : ColorStyle.secondaryTextColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              AnimatedContainer(
                                height: 5,
                                width: !isSignupSeleted ? 65 : 0,
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: !isSignupSeleted
                                        ? ColorStyle.primaryColorLight
                                        : Colors.transparent),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Visibility(
                      visible: isSignupSeleted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              controller: _firstNameController,
                              hint: "First Name",
                              icon: const Icon(Icons.person_outline),
                              keyboardType: TextInputType.name),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _lastNameController,
                              hint: "Last Name",
                              icon: const Icon(Icons.person_outline),
                              keyboardType: TextInputType.name),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _ageController,
                              hint: "Age",
                              icon: const Icon(Icons.today_outlined),
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: ColorStyle.secondaryTextColor)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: ColorStyle.secondaryTextColor
                                      .withOpacity(0.8),
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      setState(() {
                                        _phoneNumber = number;
                                      });
                                    },
                                    onInputValidated: (bool value) {},
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                      useBottomSheetSafeArea: true,
                                    ),
                                    spaceBetweenSelectorAndTextField: 0,
                                    ignoreBlank: false,
                                    hintText: "Phone",
                                    initialValue: _phoneNumber,
                                    textFieldController: _phoneController,
                                    inputDecoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                    ),
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Visibility(
                          //   visible: PrefUtils().getIsAppTypeCustomer == false,
                          //   child: CustomTextField(
                          //       controller: _orgController,
                          //       hint: "Organization Name",
                          //       icon: const Icon(Icons.corporate_fare_outlined),
                          //       keyboardType: TextInputType.name),
                          // ),
                          // Visibility(
                          //   visible: PrefUtils().getIsAppTypeCustomer == false,
                          //   child: const SizedBox(height: 10),
                          // )
                        ],
                      ),
                    ),
                    CustomTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: Icon(isSignupSeleted
                            ? Icons.email_outlined
                            : Icons.person_outline),
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: _pwdController,
                        hint: "Password",
                        icon: const Icon(Icons.lock_outline),
                        obscuretext: !isPwdVisible,
                        trailing: IconButton(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                isPwdVisible = !isPwdVisible;
                              });
                            },
                            icon: Icon(isPwdVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined))),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: isSignupSeleted,
                      child: CustomTextField(
                          controller: _confPwdController,
                          hint: "Confirm Password",
                          icon: const Icon(Icons.lock_outline),
                          obscuretext: !isPwdVisible,
                          trailing: IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  isPwdVisible = !isPwdVisible;
                                });
                              },
                              icon: Icon(isPwdVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined))),
                    ),
                    Visibility(
                        visible: !isSignupSeleted,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: const Text(
                              "Forgot Password",
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(forgotPassOneRoute);
                            },
                          ),
                        )),
                    Visibility(
                      visible: isSignupSeleted,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isTermsChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isTermsChecked = !isTermsChecked;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(termsRoute);
                              },
                              child: RichText(
                                text: const TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                        color: ColorStyle.primaryTextColor),
                                    children: [
                                      TextSpan(
                                        text: "terms and conditions",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: ColorStyle.primaryColor),
                                      )
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: double.maxFinite,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
                            ]),
                        child: CustomRoundedButton(
                          isSignupSeleted ? 'Sign Up' : 'Sign In',
                          () async {
                            if (isSignupSeleted) {
                              if (_frontendValidation()) {
                                _signUp();
                              }
                            } else {
                              if (_frontendValidation()) {
                                _signIn();
                              }
                            }
                          },
                          roundedCorners: 12,
                          textWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 15),
                    Center(
                      child: Visibility(
                        //visible: PrefUtils().getIsAppTypeCustomer,
                        child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                      color: ColorStyle.blackColor
                                          .withOpacity(0.25))
                                ]),
                            child: CustomRoundedButton(
                              'Skip For Now',
                              () {
                                PrefUtils().setIsUserLoggedIn = false;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    mainRoute,
                                    arguments: MainArgs(0),
                                    (e) => false);
                              },
                              roundedCorners: 18,
                              textSize: 14,
                              textWeight: FontWeight.w500,
                              buttonBackgroundColor: ColorStyle.whiteColor,
                              borderColor: ColorStyle.secondaryTextColor,
                              textColor: ColorStyle.secondaryTextColor,
                            )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: !isSignupSeleted,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 1,
                                width: 100,
                                color: ColorStyle.secondaryTextColor,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'or sign in with',
                                style: TextStyle(
                                    color: ColorStyle.secondaryTextColor,
                                    fontSize: 10),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                height: 1,
                                width: 100,
                                color: ColorStyle.secondaryTextColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _showPhoneDialog(),
                                child: Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.whiteColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: const Icon(
                                      Icons.phone_outlined,
                                      color: ColorStyle.secondaryTextColor,
                                      size: 30,
                                    )),
                              ),
                              GestureDetector(
                                onTap: () => _ssoGoogle(),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.whiteColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            color: ColorStyle.blackColor
                                                .withOpacity(0.25))
                                      ]),
                                  child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: Image.asset(
                                      'assets/pngs/google_logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: Platform.isIOS,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(left: 30),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.whiteColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            color: ColorStyle.blackColor
                                                .withOpacity(0.25)),
                                      ]),
                                  child: Image.asset(
                                    'assets/pngs/apple_logo.png',
                                    // height: 50,
                                    // width: 50,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  _showPhoneDialog() {
    _phoneSignInPhoneController.text = '';
    _phoneSignInPwdController.text = '';
    _phoneSignInNumber = PhoneNumber(isoCode: 'PK');
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Sign In With Phone",
                            style: TextStyle(
                              color: ColorStyle.secondaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: ColorStyle.secondaryTextColor)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: ColorStyle.secondaryTextColor
                                      .withOpacity(0.8),
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      setState(() {
                                        _phoneSignInNumber = number;
                                      });
                                    },
                                    onInputValidated: (bool value) {},
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                      useBottomSheetSafeArea: true,
                                    ),
                                    spaceBetweenSelectorAndTextField: 0,
                                    ignoreBlank: false,
                                    hintText: "Phone",
                                    initialValue: _phoneSignInNumber,
                                    textFieldController:
                                        _phoneSignInPhoneController,
                                    inputDecoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      border: InputBorder.none,
                                    ),
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _phoneSignInPwdController,
                              hint: "Password",
                              icon: const Icon(Icons.lock_outline),
                              obscuretext: !isPwdVisible,
                              trailing: IconButton(
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      isPwdVisible = !isPwdVisible;
                                    });
                                  },
                                  icon: Icon(isPwdVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined))),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            height: 45,
                            child: CustomRoundedButton(
                              "Sign In",
                              () => _signInWithPhone(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        barrierColor: const Color(0x59000000));
  }

  _showCodeSentDialog() {
    _otpController.text = '';
    isErrorEnforced = false;
    isCodeResent = false;
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              validateOtp() async {
                SmartDialog.showLoading(
                    builder: (_) => const LoadingUtil(type: 2));
                userService
                    .verifyOtp('email', _otpController.text.trim(),
                        _emailController.text.trim())
                    .then((value) {
                  SmartDialog.dismiss();
                  if (value.error == null) {
                    UserResponse apiResponse = value.snapshot;
                    if (apiResponse.success ?? false) {
                      Navigator.of(context).pop();
                      _saveUserData(apiResponse.data!.user!);
                      _navigatorFunction();
                    } else {
                      _otpController.text = '';
                      setState(() {
                        isErrorEnforced = true;
                      });
                    }
                  } else {}
                });
              }

              return Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Verification",
                            style: TextStyle(
                              color: ColorStyle.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "We've sent you an email on ${_emailController.text.trim()} to verify it's really you, please check your inbox and enter the code",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: ColorStyle.primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "(Don't miss the spam folder)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorStyle.secondaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Pinput(
                            length: 6,
                            controller: _otpController,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme.copyWith(
                                decoration: BoxDecoration(
                              color: ColorStyle.greyColor,
                              borderRadius: BorderRadius.circular(300),
                            )),
                            separatorBuilder: (index) {
                              return const SizedBox(width: 12);
                            },
                            focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: BoxDecoration(
                                  color: ColorStyle.primaryColorExtraLight,
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                textStyle: const TextStyle(
                                    color: ColorStyle.primaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600)),
                            submittedPinTheme: defaultPinTheme.copyWith(
                                decoration: BoxDecoration(
                                  color: ColorStyle.primaryColorExtraLight,
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                textStyle: const TextStyle(
                                    color: ColorStyle.primaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600)),
                            errorPinTheme: defaultPinTheme.copyWith(
                                decoration: BoxDecoration(
                                  color: ColorStyle.primaryColorExtraLight,
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                textStyle: const TextStyle(
                                    color: ColorStyle.primaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600)),
                            showCursor: true,
                            cursor: cursor,
                            forceErrorState: isErrorEnforced,
                            errorText: 'Invalid Code',
                            errorBuilder: (errorText, pin) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      errorText!,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          color: ColorStyle.primaryColorLight,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isCodeResent
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Code Resent",
                                      style: TextStyle(
                                          color: ColorStyle.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: ColorStyle.primaryColor,
                                      size: 15,
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Did not get a code?",
                                      style: TextStyle(
                                          color: ColorStyle.primaryTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _otpController.text = "";
                                        isErrorEnforced = false;
                                        setState(() {});
                                        SmartDialog.showLoading(
                                            builder: (_) =>
                                                const LoadingUtil(type: 2));
                                        userService
                                            .sendOtp('email',
                                                _emailController.text.trim())
                                            .then((value) {
                                          SmartDialog.dismiss();
                                          if (value.error == null) {
                                            GenericResponse apiResponse =
                                                value.snapshot;
                                            if (apiResponse.success ?? false) {
                                              setState(() {
                                                isCodeResent = true;
                                              });
                                              Future.delayed(const Duration(
                                                      milliseconds: 2000))
                                                  .then((value) {
                                                setState(() {
                                                  isCodeResent = false;
                                                });
                                              });
                                            }
                                          } else {}
                                        });
                                      },
                                      child: const Text(
                                        "Resend",
                                        style: TextStyle(
                                            color: ColorStyle.primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            height: 45,
                            child: CustomRoundedButton(
                              "Verify",
                              () => validateOtp(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        barrierColor: const Color(0x59000000));
  }

  // _customDialog(context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width - 45,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //         color: ColorStyle.whiteColor,
  //         borderRadius: BorderRadius.circular(12)),
  //     child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Profile Picture",
  //             style: TextStyle(
  //                 fontSize: 20,
  //                 color: ColorStyle.primaryColor,
  //                 fontWeight: FontWeight.w900),
  //           ),
  //           const SizedBox(height: 15),
  //           const Text(
  //             "Do you want to upload a profile picture?",
  //             style: TextStyle(color: ColorStyle.primaryTextColor),
  //           ),
  //           const SizedBox(
  //             height: 40,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Row(
  //               //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Expanded(
  //                   child: CustomRoundedButton(
  //                     "Skip",
  //                     () {
  //                       SmartDialog.dismiss(result: false);
  //                     },
  //                     //roundedCorners: 18,
  //                     textSize: 14,
  //                     textWeight: FontWeight.w500,
  //                     buttonBackgroundColor: ColorStyle.whiteColor,
  //                     borderColor: ColorStyle.secondaryTextColor,
  //                     textColor: ColorStyle.secondaryTextColor,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 Expanded(
  //                   child: CustomRoundedButton(
  //                     "Upload",
  //                     () {
  //                       SmartDialog.dismiss(result: true);
  //                     },
  //                     //roundedCorners: 18,
  //                     textSize: 14,
  //                     textWeight: FontWeight.w500,
  //                     // buttonBackgroundColor: ColorStyle.whiteColor,
  //                     // borderColor: ColorStyle.secondaryTextColor,
  //                     // textColor: ColorStyle.secondaryTextColor,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ]),
  //   );
  // }
}
