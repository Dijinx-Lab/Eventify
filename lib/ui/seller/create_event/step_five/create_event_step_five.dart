// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:eventify/models/api_models/event_response/event.dart';
// import 'package:eventify/models/api_models/event_list_response/event_image.dart';
// import 'package:eventify/styles/color_style.dart';
// import 'package:eventify/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StepFiveContainer extends StatefulWidget {
//   final Event event;
//   final Function(Event, bool) onDataFilled;
//   const StepFiveContainer(
//       {super.key, required this.event, required this.onDataFilled});

//   @override
//   State<StepFiveContainer> createState() => _StepFiveContainerState();
// }

// class _StepFiveContainerState extends State<StepFiveContainer> {
//   final TextEditingController _nameController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   bool isPhotoTaken = false;
//   List<String>? _imagePaths;
//   final PageController _pageController =
//       PageController(viewportFraction: 1, keepPage: true);
//   int currentPage = 0;
//   late Event event;

//   @override
//   initState() {
//     event = widget.event;

//     if ((event.eventImages?.isNotEmpty ?? false) && event.eventName != null) {
//       _nameController.text = event.eventName ?? "";
//       _imagePaths = event.eventImages!.map((e) => e.imagePath!).toList();
//       isPhotoTaken = _imagePaths != null ? true : false;
//     }

//     Future.delayed(const Duration(microseconds: 800)).then((value) {
//       _alertParentWidget();
//     });

//     _pageController.addListener(() {
//       setState(() {
//         currentPage = _pageController.page!.toInt();
//       });
//     });

//     _nameController.addListener(() {
//       _alertParentWidget();
//     });

//     super.initState();
//   }

//   _alertParentWidget() async {
//     if (_imagePaths != null &&
//         _imagePaths!.isNotEmpty &&
//         _nameController.text != "") {
//       event.eventName = _nameController.text;
//       List<EventImage> eventImages = [];
//       for (var eventImage in _imagePaths!) {
//         eventImages.add(EventImage(imagePath: eventImage));
//       }
//       event.eventImages = eventImages;
//       widget.onDataFilled(event, true);
//     } else {
//       widget.onDataFilled(event, false);
//     }
//   }

//   Future<void> _openImages() async {
//     var status;
//     if (Platform.isAndroid) {
//       status = await Permission.storage.request();
//     } else {
//       status = await Permission.photos.request();
//     }
//     List<XFile>? xfile = await _picker.pickMultiImage(
//       // source: ImageSource.gallery,
//       imageQuality: 100,
//     );
//     if (xfile.isNotEmpty) {
//       // List<String> filepaths = [];
//       for (var file in xfile) {
//         if (await File(file.path).exists()) {
//           _imagePaths?.add(file.path);
//         }
//       }
//       setState(() {
//         // _imagePaths = filepaths;
//         isPhotoTaken = true;
//       });
//       _alertParentWidget();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             _openImages();
//           },
//           child: isPhotoTaken
//               ? SizedBox(
//                   height: 200,
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.topCenter,
//                         child: PageView.builder(
//                             controller: _pageController,
//                             itemCount: _imagePaths!.length,
//                             clipBehavior: Clip.antiAlias,
//                             itemBuilder: (context, index) {
//                               return SizedBox(
//                                 child: Stack(
//                                   children: [
//                                     Center(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: SizedBox(
//                                           height: 150,
//                                           width: double.maxFinite,
//                                           child: _imagePaths![index]
//                                                   .startsWith('http')
//                                               ? CachedNetworkImage(
//                                                   imageUrl: _imagePaths![index],
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Image.file(
//                                                   File(_imagePaths![index]),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       right: 0,
//                                       top: 15,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           if (_imagePaths!.length == 1) {
//                                             setState(() {
//                                               isPhotoTaken = false;
//                                               _imagePaths = null;
//                                             });
//                                           } else {
//                                             setState(() {
//                                               _imagePaths!.removeAt(index);
//                                             });
//                                           }
//                                           _alertParentWidget();
//                                         },
//                                         child: Container(
//                                             decoration: const BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: ColorStyle.cardColor),
//                                             child: const Icon(
//                                               Icons.close,
//                                               color:
//                                                   ColorStyle.secondaryTextColor,
//                                             )),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             }),
//                       ),
//                       _imagePaths != null &&
//                               _imagePaths!.isNotEmpty &&
//                               _imagePaths!.length != 1
//                           ? Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                   margin: const EdgeInsets.only(bottom: 10.0),
//                                   child: _buildPagerDotIndicator()))
//                           : Container(),
//                     ],
//                   ),
//                 )
//               : DottedBorder(
//                   radius: const Radius.circular(12),
//                   borderType: BorderType.RRect,
//                   color: ColorStyle.secondaryTextColor,
//                   dashPattern: [5, 3, 5, 3],
//                   strokeCap: StrokeCap.butt,
//                   child: Container(
//                     height: 150,
//                     width: double.maxFinite,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: ColorStyle.cardColor),
//                     child: const Center(
//                       child: Text(
//                         "Upload Image",
//                         style: TextStyle(
//                             color: ColorStyle.secondaryTextColor,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         const SizedBox(height: 30),
//         CustomTextField(
//             controller: _nameController,
//             hint: "Name",
//             icon: null,
//             keyboardType: TextInputType.name),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _buildPagerDotIndicator() {
//     List<Widget> dotsWidget = [];
//     for (int i = 0; i < _imagePaths!.length; i++) {
//       dotsWidget.add(Container(
//         margin: const EdgeInsets.symmetric(horizontal: 1.0),
//         width: 6,
//         height: 6,
//         decoration: BoxDecoration(
//             color: i == currentPage
//                 ? ColorStyle.primaryColor
//                 : ColorStyle.secondaryTextColor,
//             shape: BoxShape.circle),
//       ));
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: dotsWidget,
//     );
//   }
// }
