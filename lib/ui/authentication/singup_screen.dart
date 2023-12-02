import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatefulWidget {
  final SignupArgs args;
  const SignUpScreen({super.key, required this.args});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool isPwdVisible = false;
  bool isSignupSeleted = true;

  @override
  void initState() {
    isSignupSeleted = widget.args.isSignupSelected;
    super.initState();
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
          child: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                      PrefUtils().getIsAppTypeCustomer
                          ? 'assets/svgs/login_ellipse.svg'
                          : 'assets/svgs/login_ellipse_alt.svg',
                      width: MediaQuery.of(context).size.width),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                          PrefUtils().getIsAppTypeCustomer
                              ? 'assets/svgs/ic_eventify_client_logo.svg'
                              : 'assets/svgs/ic_eventify_seller_logo.svg',
                          width: 160),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _emailController.text = "";
                                isPwdVisible = false;
                                _pwdController.text = "";
                                isSignupSeleted = true;
                              });
                            },
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
                                  width: isSignupSeleted ? 70 : 0,
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
                          onTap: () {
                            setState(() {
                              _emailController.text = "";
                              isPwdVisible = false;
                              _pwdController.text = "";
                              isSignupSeleted = false;
                            });
                          },
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
                                width: !isSignupSeleted ? 70 : 0,
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
                    CustomTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: const Icon(Icons.alternate_email),
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
                          () {
                            PrefUtils().setIsUserLoggedIn = true;
                            if (PrefUtils().getIsAppTypeCustomer) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainRoute,
                                  arguments: MainArgs(0),
                                  (e) => false);
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  sellerHomeRoute, (e) => false);
                            }
                          },
                          roundedCorners: 12,
                          textWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: PrefUtils().getIsAppTypeCustomer,
                      child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color:
                                        ColorStyle.blackColor.withOpacity(0.25))
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
                    const SizedBox(height: 30),
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
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 60,
                            width: 60,
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
                            child: Icon(
                              Icons.phone_outlined,
                              color: ColorStyle.secondaryTextColor,
                              size: 30,
                            )),
                        Container(
                          height: 60,
                          width: 60,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorStyle.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color:
                                        ColorStyle.blackColor.withOpacity(0.25))
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
                        Container(
                          height: 60,
                          width: 60,
                          padding: EdgeInsets.all(10),
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
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
