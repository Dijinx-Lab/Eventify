import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepOneContainer extends StatefulWidget {
  final EventArgs event;
  final Function(EventArgs, bool) onDataFilled;
  const StepOneContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepOneContainer> createState() => _StepOneContainerState();
}

class _StepOneContainerState extends State<StepOneContainer> {
  final TextEditingController _dateValueController = TextEditingController();
  final TextEditingController _timeValueController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late EventArgs eventArgs;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.event;
    if (eventArgs.dateTime != null) {
      _dateValueController.text =
          DateFormat('MMM d, y').format(DateTime.parse(eventArgs.dateTime!));
      _timeValueController.text =
          DateFormat('h:mm a').format(DateTime.parse(eventArgs.dateTime!));
    }

    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });

    _dateValueController.addListener(() {
      _alertParentWidget();
    });
    _timeValueController.addListener(() {
      _alertParentWidget();
    });
  }

  _alertParentWidget() {
    if (_dateValueController.text != "" && _timeValueController.text != "") {
      DateTime combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      eventArgs.dateTime = combinedDateTime.toIso8601String();
      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () async {
            await _selectDate(context);
          },
          child: AbsorbPointer(
            absorbing: true,
            child: CustomTextField(
                controller: _dateValueController,
                hint: "Date",
                icon: const Icon(Icons.today_outlined),
                keyboardType: TextInputType.emailAddress),
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () async {
            await _selectTime(context);
          },
          child: AbsorbPointer(
            absorbing: true,
            child: CustomTextField(
                controller: _timeValueController,
                hint: "Time",
                icon: const Icon(Icons.schedule),
                keyboardType: TextInputType.emailAddress),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateValueController.text = DateFormat('MMM d, y').format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      final now = DateTime.now();
      DateTime dateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      setState(() {
        selectedTime = picked;
        _timeValueController.text = DateFormat('h:mm a').format(dateTime);
      });
    }
  }
}
