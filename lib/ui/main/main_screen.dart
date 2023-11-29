import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/accounts/accounts_screen.dart';
import 'package:eventify/ui/alerts/alerts_screen.dart';
import 'package:eventify/ui/discover/discover_screen.dart';
import 'package:eventify/ui/saved/saved_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final MainArgs args;
  const MainScreen({super.key, required this.args});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _index = 0;

  final List<Widget> _widgets = const [
    DiscoverScreen(),
    SavedScreen(),
    AlertsScreen(),
    AccountsScreen()
  ];

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _index = widget.args.index;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: IndexedStack(index: _index, children: _widgets),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: ColorStyle.secondaryTextColor, width: 0.1))),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Accounts')
          ],
          type: BottomNavigationBarType.fixed,
          elevation: 3,
          currentIndex: _index,
          showUnselectedLabels: true,
          unselectedFontSize: 10,
          selectedFontSize: 12,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
          backgroundColor: ColorStyle.whiteColor,
          selectedItemColor: ColorStyle.primaryColor,
          unselectedItemColor: ColorStyle.secondaryTextColor,
        ),
      ),
    );
  }
}
