import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleStepOne extends StatefulWidget {
  final SaleArgs sale;
  final Function(SaleArgs, bool) onDataFilled;
  const SaleStepOne(
      {super.key, required this.sale, required this.onDataFilled});

  @override
  State<SaleStepOne> createState() => _SaleStepOneState();
}

class _SaleStepOneState extends State<SaleStepOne> {
  final TextEditingController _startDateValueController =
      TextEditingController();
  final TextEditingController _startTimeValueController =
      TextEditingController();
  final TextEditingController _endDateValueController = TextEditingController();
  final TextEditingController _endTimeValueController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  late SaleArgs eventArgs;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.sale;
    if (eventArgs.startDateTime != null) {
      _startDateValueController.text = DateFormat('MMM d, y')
          .format(DateTime.parse(eventArgs.startDateTime!));
      _startTimeValueController.text =
          DateFormat('h:mm a').format(DateTime.parse(eventArgs.endDateTime!));
    }
    if (eventArgs.endDateTime != null) {
      _endDateValueController.text = DateFormat('MMM d, y')
          .format(DateTime.parse(eventArgs.startDateTime!));
      _endTimeValueController.text =
          DateFormat('h:mm a').format(DateTime.parse(eventArgs.endDateTime!));
    }

    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });

    _startDateValueController.addListener(() => _alertParentWidget());
    _startTimeValueController.addListener(() => _alertParentWidget());
    _endDateValueController.addListener(() => _alertParentWidget());
    _endTimeValueController.addListener(() => _alertParentWidget());
  }

  _alertParentWidget() {
    if (_startDateValueController.text != "" &&
        _startTimeValueController.text != "" &&
        _endDateValueController.text != "" &&
        _endTimeValueController.text != "") {
      DateTime combinedStartDateTime = DateTime(
        selectedStartDate.year,
        selectedStartDate.month,
        selectedStartDate.day,
        selectedStartTime.hour,
        selectedStartTime.minute,
      );
      DateTime combinedEndDateTime = DateTime(
        selectedEndDate.year,
        selectedEndDate.month,
        selectedEndDate.day,
        selectedEndTime.hour,
        selectedEndTime.minute,
      );
      eventArgs.startDateTime = combinedStartDateTime.toIso8601String();
      eventArgs.endDateTime = combinedEndDateTime.toIso8601String();
      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "Starting",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorStyle.secondaryTextColor),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await _selectDate(context, true);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomTextField(
                      controller: _startDateValueController,
                      hint: "Date",
                      icon: const Icon(Icons.today_outlined),
                      keyboardType: TextInputType.emailAddress),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await _selectTime(context, true);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomTextField(
                      controller: _startTimeValueController,
                      hint: "Time",
                      icon: const Icon(Icons.schedule),
                      keyboardType: TextInputType.emailAddress),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          "Ending",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorStyle.secondaryTextColor),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await _selectDate(context, false);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomTextField(
                      controller: _endDateValueController,
                      hint: "Date",
                      icon: const Icon(Icons.today_outlined),
                      keyboardType: TextInputType.emailAddress),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await _selectTime(context, false);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomTextField(
                      controller: _endTimeValueController,
                      hint: "Time",
                      icon: const Icon(Icons.schedule),
                      keyboardType: TextInputType.emailAddress),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool forStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: forStart ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (forStart) {
        selectedStartDate = picked;
        _startDateValueController.text =
            DateFormat('MMM d, y').format(selectedStartDate);
      } else {
        selectedEndDate = picked;
        _endDateValueController.text =
            DateFormat('MMM d, y').format(selectedEndDate);
      }

      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context, bool forStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: forStart ? selectedStartTime : selectedEndTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      DateTime dateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      if (forStart) {
        selectedStartTime = picked;
        _startTimeValueController.text = DateFormat('h:mm a').format(dateTime);
      } else {
        selectedEndTime = picked;
        _endTimeValueController.text = DateFormat('h:mm a').format(dateTime);
      }
      setState(() {});
    }
  }
}
