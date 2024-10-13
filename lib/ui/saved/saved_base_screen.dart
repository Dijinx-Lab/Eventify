import 'package:event_bus/event_bus.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/saved/saved_sales_screen.dart';
import 'package:eventify/ui/saved/saved_events_screen.dart';
import 'package:flutter/material.dart';

class SavedBaseScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const SavedBaseScreen({super.key});

  @override
  State<SavedBaseScreen> createState() => _SavedBaseScreenState();
}

class _SavedBaseScreenState extends State<SavedBaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Widget> pages = [
    const SavedEventsScreen(),
    const SavedSalesScreen(),
  ];

  @override
  void initState() {
    _tabController = TabController(length: pages.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorStyle.whiteColor,
        title: const Text(
          "Saved Events",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            color: ColorStyle.primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            color: ColorStyle.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "Events"),
            Tab(text: "Sales"),
          ],
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: pages,
      ),
    );
  }
}
