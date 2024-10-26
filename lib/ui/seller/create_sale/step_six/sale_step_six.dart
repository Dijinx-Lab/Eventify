// import 'dart:io';

// import 'package:eventify/models/screen_args/sale_args.dart';
// import 'package:eventify/utils/pref_utils.dart';
// import 'package:eventify/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';

// class SaleStepSix extends StatefulWidget {
//   final SaleArgs sale;
//   final Function(SaleArgs, bool) onDataFilled;
//   const SaleStepSix(
//       {super.key, required this.sale, required this.onDataFilled});

//   @override
//   State<SaleStepSix> createState() => _SaleStepSixState();
// }

// class _SaleStepSixState extends State<SaleStepSix> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _waController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _organizerController = TextEditingController();

//   bool isPhotoTaken = false;
//   String? imagePath;
//   late SaleArgs eventArgs;

//   @override
//   void initState() {
//     eventArgs = widget.sale;
//     if (eventArgs.eventId != null) {
//       _nameController.text = eventArgs.contactName ?? "";
//       _organizerController.text = eventArgs.contactOrganization ?? "";
//       _phoneController.text = eventArgs.contactPhone ?? "";
//       _waController.text = eventArgs.contactWhatsApp ?? "";
//       _emailController.text = eventArgs.contactEmail ?? "";
//     } else {
//       _nameController.text =
//           "${PrefUtils().getFirstName} ${PrefUtils().getLasttName}";
//       _phoneController.text =
//           "${PrefUtils().getCountryCode}${PrefUtils().getPhone}";
//     }

//     Future.delayed(const Duration(microseconds: 800)).then((value) {
//       _alertParentWidget();
//     });

//     super.initState();

//     _nameController.addListener(() {
//       _alertParentWidget();
//     });

//     _phoneController.addListener(() {
//       _alertParentWidget();
//     });

//     _waController.addListener(() {
//       _alertParentWidget();
//     });

//     _emailController.addListener(() {
//       _alertParentWidget();
//     });

//     _organizerController.addListener(() {
//       _alertParentWidget();
//     });
//   }

//   _alertParentWidget() async {
//     if (_nameController.text != "" &&
//         _phoneController.text != "" &&
//         _waController.text != "" &&
//         _emailController.text != "" &&
//         _organizerController.text != "") {
//       eventArgs.contactOrganization = _organizerController.text;
//       eventArgs.contactPhone = _phoneController.text;
//       eventArgs.contactWhatsApp = _waController.text;
//       eventArgs.contactEmail = _emailController.text;
//       eventArgs.contactName = _nameController.text;
//       widget.onDataFilled(eventArgs, true);
//     } else {
//       widget.onDataFilled(eventArgs, false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         Center(
//           child: GestureDetector(
//             onTap: () {},
//             child: SizedBox(
//               height: 70,
//               width: 70,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(200),
//                     child: Center(
//                       child: isPhotoTaken
//                           ? SizedBox(
//                               height: 70,
//                               width: 70,
//                               child: Image.file(
//                                 File(imagePath!),
//                                 fit: BoxFit.cover,
//                               ))
//                           : SizedBox(
//                               height: 70,
//                               width: 70,
//                               child: Image.asset(
//                                 "assets/pngs/image_placeholder.png",
//                                 fit: BoxFit.cover,
//                               )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//         CustomTextField(
//           controller: _nameController,
//           hint: "Name",
//           keyboardType: TextInputType.name,
//         ),
//         const SizedBox(height: 30),
//         CustomTextField(
//           controller: _phoneController,
//           hint: "Phone number",
//           keyboardType: TextInputType.number,
//         ),
//         const SizedBox(height: 30),
//         CustomTextField(
//           controller: _waController,
//           hint: "Whatsapp number",
//           keyboardType: TextInputType.number,
//         ),
//         const SizedBox(height: 30),
//         CustomTextField(
//           controller: _emailController,
//           hint: "Email",
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 30),
//         CustomTextField(
//           controller: _organizerController,
//           hint: "Sale Organizer",
//           keyboardType: TextInputType.emailAddress,
//         ),
//       ],
//     );
//   }
// }
