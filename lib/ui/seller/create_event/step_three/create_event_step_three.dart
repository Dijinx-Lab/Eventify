// import 'package:eventify/models/api_models/event_response/event.dart';
// import 'package:eventify/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';

// class StepThreeContainer extends StatefulWidget {
//   final Event event;
//   final Function(Event, bool) onDataFilled;
//   const StepThreeContainer(
//       {super.key, required this.event, required this.onDataFilled});

//   @override
//   State<StepThreeContainer> createState() => _StepThreeContainerState();
// }

// class _StepThreeContainerState extends State<StepThreeContainer> {
//   final TextEditingController _capacityController = TextEditingController();
//   late Event event;

//   @override
//   void initState() {
//     super.initState();
//     event = widget.event;
//     _capacityController.text = event.capacity?.toString() ?? "";
//     Future.delayed(const Duration(microseconds: 800)).then((value) {
//       _alertParentWidget();
//     });
//     _capacityController.addListener(() {
//       _alertParentWidget();
//     });
//   }

//   _alertParentWidget() {
//     if (_capacityController.text != "") {
//       event.capacity = int.parse(_capacityController.text);
//       widget.onDataFilled(event, true);
//     } else {
//       widget.onDataFilled(event, false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         CustomTextField(
//             controller: _capacityController,
//             hint: "Capacity",
//             icon: const Icon(Icons.groups_outlined),
//             keyboardType: TextInputType.number),
//         const SizedBox(height: 30),
//       ],
//     );
//   }
// }
