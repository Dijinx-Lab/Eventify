import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        title: const Text(
          "Saved Events",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container();
           // return const CustomEventContainer();
          }),
    );
  }
}
