import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepThreeContainer extends StatefulWidget {
  final EventArgs event;
  final Function(EventArgs, bool) onDataFilled;
  const StepThreeContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepThreeContainer> createState() => _StepThreeContainerState();
}

class _StepThreeContainerState extends State<StepThreeContainer> {
  final TextEditingController _capacityController = TextEditingController();
  late EventArgs eventArgs;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.event;
    _capacityController.text = eventArgs.maxCapacity?.toString() ?? "";
    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });
    _capacityController.addListener(() {
      _alertParentWidget();
    });
  }

  _alertParentWidget() {
    if (_capacityController.text != "") {
      eventArgs.maxCapacity = _capacityController.text;
      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: ColorStyle.secondaryTextColor,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'This represents the amount of available space there is at your event',
                style: TextStyle(
                  color: ColorStyle.secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        CustomTextField(
            controller: _capacityController,
            hint: "Capacity",
            icon: const Icon(Icons.groups_outlined),
            keyboardType: TextInputType.number),
        const SizedBox(height: 30),
      ],
    );
  }
}
