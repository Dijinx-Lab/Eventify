import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/create_sale_args.dart';
import 'package:eventify/models/screen_args/detail_args.dart';
import 'package:eventify/models/screen_args/forgot_pass_args.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/ui/accounts/accounts_screen.dart';
import 'package:eventify/ui/accounts/privacy_policy_screen.dart';
import 'package:eventify/ui/accounts/profile_screen.dart';
import 'package:eventify/ui/accounts/reset_password_screen.dart';
import 'package:eventify/ui/accounts/terms_and_conditions_screen.dart';
import 'package:eventify/ui/alerts/alerts_screen.dart';
import 'package:eventify/ui/authentication/forgot_pass/forgot_pass_one_screen.dart';
import 'package:eventify/ui/authentication/forgot_pass/forgot_pass_three_screen.dart';
import 'package:eventify/ui/authentication/forgot_pass/forgot_pass_two_screen.dart';
import 'package:eventify/ui/authentication/role_selection_screen.dart';
import 'package:eventify/ui/authentication/signup_screen.dart';
import 'package:eventify/ui/detail/event/event_detail_screen.dart';
import 'package:eventify/ui/detail/sale/sale_detail_screen.dart';
import 'package:eventify/ui/discover/search_screen.dart';
import 'package:eventify/ui/main/main_screen.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_one.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_three.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_two.dart';
import 'package:eventify/ui/seller/base/base_seller_screen.dart';
import 'package:eventify/ui/seller/create_event/create_event_screen.dart';
import 'package:eventify/ui/seller/create_sale/create_sale_screen.dart';
import 'package:eventify/ui/splash/splash_screen.dart';
import 'package:eventify/ui/unloggedin/unloggedin_screen.dart';
import 'package:flutter/material.dart';

class CustomRoutes {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case initialRouteWithNoArgs:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case initialRoute:
        return MaterialPageRoute(
            builder: (_) =>
                SplashScreen(args: settings.arguments as SplashArgs));
      case onboardingOneRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreenOne());
      case onboardingTwoRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreenTwo());
      case onboardingThreeRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreenThree());
      case roleSelectionRoute:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case signupRoute:
        return MaterialPageRoute(
            builder: (_) =>
                SignUpScreen(args: settings.arguments as SignupArgs));
      case mainRoute:
        return MaterialPageRoute(
            builder: (_) => MainScreen(args: settings.arguments as MainArgs));
      case searchRoute:
        return MaterialPageRoute(
            builder: (_) =>
                SearchScreen(args: settings.arguments as SearchArgs));
      case eventDetailRoute:
        return MaterialPageRoute(
            builder: (_) =>
                EventDetailScreen(args: settings.arguments as DetailArgs));
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case resetpassRoute:
        return MaterialPageRoute(builder: (_) => const ResetPassScreen());
      case privacyRoute:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case termsRoute:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditionScreen());
      case sellerHomeRoute:
        return MaterialPageRoute(builder: (_) => const BaseSellerScreen());
      case accountsRoute:
        return MaterialPageRoute(builder: (_) => const AccountsScreen());
      case createEventRoute:
        return MaterialPageRoute(
            builder: (_) => CreateEventScreen(
                args: settings.arguments as CreateEventsArgs));
      case forgotPassOneRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordOneScreen());
      case forgotPassTwoRoute:
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordTwoScreen(
                  arguments: settings.arguments as ForgotPassArgs,
                ));
      case forgotPassThreeRoute:
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordThreeScreen(
                  arguments: settings.arguments as ForgotPassArgs,
                ));
      case notLoggedInRoute:
        return MaterialPageRoute(builder: (_) => const UnLoggedInScreen());
      case createSaleRoute:
        return MaterialPageRoute(
            builder: (_) => CreateSaleScreen(
                  args: settings.arguments as CreateSaleArgs,
                ));
      case saleDetailRoute:
        return MaterialPageRoute(
            builder: (_) =>
                SaleDetailScreen(args: settings.arguments as CreateSaleArgs));
      case alertsRoute:
        return MaterialPageRoute(builder: (_) => const AlertsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                SplashScreen(args: settings.arguments as SplashArgs));
    }
  }
}
