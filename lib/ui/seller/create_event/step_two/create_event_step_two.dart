import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepTwoContainer extends StatefulWidget {
  const StepTwoContainer({super.key});

  @override
  State<StepTwoContainer> createState() => _StepTwoContainerState();
}

class _StepTwoContainerState extends State<StepTwoContainer> {
  TextEditingController _locationValueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        CustomTextField(
            controller: _locationValueController,
            hint: "Location",
            icon: const Icon(Icons.location_on_outlined),
            keyboardType: TextInputType.name),
        const SizedBox(height: 30),
      ],
    );
  }
}
