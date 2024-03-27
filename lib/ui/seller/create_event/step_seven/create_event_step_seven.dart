// import 'dart:io';

// import 'package:eventify/models/api_models/event_response/event.dart';
// import 'package:eventify/utils/pref_utils.dart';
// import 'package:eventify/widgets/custom_text_field.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class StepSevenContainer extends StatefulWidget {
//   final Event event;
//   final Function(Event, bool) onDataFilled;
//   const StepSevenContainer(
//       {super.key, required this.event, required this.onDataFilled});

//   @override
//   State<StepSevenContainer> createState() => _StepSevenContainerState();
// }

// class _StepSevenContainerState extends State<StepSevenContainer> {
//   final TextEditingController _nameController = TextEditingController();
//   //final TextEditingController _secondController = TextEditingController();

//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _waController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _organizerController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   bool isPhotoTaken = false;
//   String? imagePath;
//   late Event event;

//   @override
//   void initState() {
//     event = widget.event;
//     if (event.eventId != null) {
//       _nameController.text = event.contactPersonName ?? "";
//       _organizerController.text = event.organizeBy ?? "";
//       _phoneController.text = event.contactPhoneNumber ?? "";
//       _waController.text = event.contactWhatsApp ?? "";
//       _emailController.text = event.contactEmail ?? "";
//     } else {
//       // _nameController.text =
//       //     "${PrefUtils().getUserFirstName} ${PrefUtils().getUserLastName}";

//       // _phoneController.text = PrefUtils().getUserPhone;
//       // _waController.text = PrefUtils().getUserPhone;
//       // _emailController.text = PrefUtils().getUserEmail;
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
//       event.organizeBy = _organizerController.text;
//       event.contactPhoneNumber = _phoneController.text;
//       event.contactWhatsApp = _waController.text;
//       event.contactEmail = _emailController.text;
//       event.contactPersonName = _nameController.text;
//       widget.onDataFilled(event, true);
//     } else {
//       widget.onDataFilled(event, false);
//     }
//   }

//   // Future<void> openCamera() async {
//   //   var status = await Permission.camera.request();
//   //   XFile? xfile = await _picker.pickImage(
//   //       source: ImageSource.camera,
//   //       imageQuality: 100,
//   //       preferredCameraDevice: CameraDevice.front);
//   //   if (xfile != null && await File(xfile.path).exists()) {
//   //     imagePath = xfile.path;
//   //     if (mounted) {
//   //       setState(() {
//   //         isPhotoTaken = true;
//   //       });
//   //     }
//   //   }
//   // }

//   // Future<void> openImages() async {
//   //   var status;
//   //   if (Platform.isAndroid) {
//   //     status = await Permission.storage.request();
//   //   } else {
//   //     status = await Permission.photos.request();
//   //   }
//   //   XFile? xfile = await _picker.pickImage(
//   //     source: ImageSource.gallery,
//   //     imageQuality: 100,
//   //   );
//   //   if (xfile != null && await File(xfile.path).exists()) {
//   //     imagePath = xfile.path;
//   //     if (mounted) {
//   //       setState(() {
//   //         isPhotoTaken = true;
//   //       });
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         Center(
//           child: GestureDetector(
//             onTap: () {
//               //  _openOptionsSheet();
//             },
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
//                   // Positioned(
//                   //   bottom: 0,
//                   //   right: 0,
//                   //   child: Container(
//                   //     height: 20,
//                   //     width: 20,
//                   //     decoration: BoxDecoration(
//                   //         color: ColorStyle.primaryColor,
//                   //         borderRadius: BorderRadius.circular(6)),
//                   //     child: const Icon(
//                   //       Icons.edit,
//                   //       color: ColorStyle.whiteColor,
//                   //       size: 12,
//                   //     ),
//                   //   ),
//                   // )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//         // CustomTextField(
//         //   controller: _firstController,
//         //   hint: "First name",
//         //   keyboardType: TextInputType.name,
//         // ),
//         // const SizedBox(height: 30),
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
//           hint: "Event Organizer",
//           keyboardType: TextInputType.emailAddress,
//         ),
//       ],
//     );
//   }

//   // _openOptionsSheet() {
//   //   showCupertinoModalPopup(
//   //       context: context,
//   //       builder: (BuildContext context) => Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//   //             child: CupertinoActionSheet(
//   //               actions: [
//   //                 GestureDetector(
//   //                   onTap: () async {
//   //                     Navigator.of(context).pop();
//   //                     await openCamera();
//   //                   },
//   //                   child: Container(
//   //                       height: 60,
//   //                       color: Colors.white,
//   //                       child: Container(
//   //                         // margin: const EdgeInsets.only(left: 25),
//   //                         child: const Center(
//   //                           child: Text("Camera",
//   //                               style: TextStyle(
//   //                                   fontSize: 16,
//   //                                   fontWeight: FontWeight.w600,
//   //                                   color: ColorStyle.primaryTextColor)),
//   //                         ),
//   //                       )),
//   //                 ),
//   //                 GestureDetector(
//   //                   onTap: () async {
//   //                     Navigator.of(context).pop();
//   //                     await openImages();
//   //                   },
//   //                   child: Container(
//   //                       height: 60,
//   //                       color: Colors.white,
//   //                       child: const Center(
//   //                         child: Text("Gallery",
//   //                             style: TextStyle(
//   //                                 fontSize: 16,
//   //                                 fontWeight: FontWeight.w600,
//   //                                 color: ColorStyle.primaryTextColor)),
//   //                       )),
//   //                 ),
//   //               ],
//   //               cancelButton: GestureDetector(
//   //                   onTap: () {
//   //                     Navigator.of(context).pop();
//   //                   },
//   //                   child: Container(
//   //                       height: 60,
//   //                       decoration: BoxDecoration(
//   //                           color: ColorStyle.primaryColor,
//   //                           borderRadius: BorderRadius.circular(12)),
//   //                       child: const Center(
//   //                         child: Text("Cancel",
//   //                             style: TextStyle(
//   //                                 fontSize: 16,
//   //                                 fontWeight: FontWeight.w600,
//   //                                 color: ColorStyle.whiteColor)),
//   //                       ))),
//   //             ),
//   //           ));
//   // }
// }
