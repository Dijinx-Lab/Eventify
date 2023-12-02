import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:flutter/material.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  bool isFloatingShown = false;

  @override
  void initState() {
    _showAfterDelay();
    super.initState();
  }

  _showAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isFloatingShown = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        title: const Text(
          "Your Events",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(accountsRoute);
                },
                icon: const Icon(Icons.account_circle_outlined)),
          )
        ],
      ),
      floatingActionButton: !isFloatingShown
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createEventRoute,
                      arguments: CreateEventsArgs(true));
                },
                backgroundColor: ColorStyle.primaryColor,
                child: const Icon(
                  Icons.add,
                  size: 35,
                  color: ColorStyle.whiteColor,
                ),
                //isExtended: true,
              ),
            ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: 2,
          itemBuilder: (context, index) {
            return const CustomEventContainer();
          }),
    );
  }
}
