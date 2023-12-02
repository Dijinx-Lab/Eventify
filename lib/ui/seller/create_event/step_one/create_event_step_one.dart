import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepOneContainer extends StatefulWidget {
  const StepOneContainer({super.key});

  @override
  State<StepOneContainer> createState() => _StepOneContainerState();
}

class _StepOneContainerState extends State<StepOneContainer> {
  TextEditingController _dateValueController = TextEditingController();
  TextEditingController _timeValueController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
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
