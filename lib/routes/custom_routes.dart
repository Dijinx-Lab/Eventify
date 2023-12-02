import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/ui/accounts/accounts_screen.dart';
import 'package:eventify/ui/accounts/privacy_policy_screen.dart';
import 'package:eventify/ui/accounts/profile_screen.dart';
import 'package:eventify/ui/accounts/reset_password_screen.dart';
import 'package:eventify/ui/accounts/terms_and_conditions_screen.dart';
import 'package:eventify/ui/authentication/role_selection.dart';
import 'package:eventify/ui/authentication/singup_screen.dart';
import 'package:eventify/ui/detail/detail_screen.dart';
import 'package:eventify/ui/discover/search_screen.dart';
import 'package:eventify/ui/main/main_screen.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_one.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_three.dart';
import 'package:eventify/ui/onboarding/onboarding_screen_two.dart';
import 'package:eventify/ui/seller/create_event/create_event_screen.dart';
import 'package:eventify/ui/seller/home/seller_home_screen.dart';
import 'package:eventify/ui/splash/splash_screen.dart';
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
      case detailRoute:
        return MaterialPageRoute(builder: (_) => const DetailScreen());
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
        return MaterialPageRoute(builder: (_) => const SellerHomeScreen());
      case accountsRoute:
        return MaterialPageRoute(builder: (_) => const AccountsScreen());
      case createEventRoute:
        return MaterialPageRoute(
            builder: (_) => CreateEventScreen(
                args: settings.arguments as CreateEventsArgs));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                SplashScreen(args: settings.arguments as SplashArgs));
    }
  }
}
