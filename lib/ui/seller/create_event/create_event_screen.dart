import 'package:eventify/models/api_models/base_response/base_response.dart';
import 'package:eventify/models/api_models/cloudinary_response/cloudinary_upload_response.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_response.dart';
import 'package:eventify/models/api_models/pass_response/pass_response.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/services/cloudinary_service.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/pass_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/create_event/step_five/create_event_step_five.dart';
import 'package:eventify/ui/seller/create_event/step_four/create_event_step_four.dart';
import 'package:eventify/ui/seller/create_event/step_one/create_event_step_one.dart';
import 'package:eventify/ui/seller/create_event/step_seven/create_event_step_seven.dart';
import 'package:eventify/ui/seller/create_event/step_six/create_event_step_six.dart';
import 'package:eventify/ui/seller/create_event/step_three/create_event_step_three.dart';
import 'package:eventify/ui/seller/create_event/step_two/create_event_step_two.dart';
import 'package:eventify/ui/seller/home/seller_home_screen.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CreateEventScreen extends StatefulWidget {
  final CreateEventsArgs args;
  const CreateEventScreen({super.key, required this.args});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  CloudinaryService cloudinaryService = CloudinaryService();
  EventService eventService = EventService();
  PassService passService = PassService();
  int stepperIndex = 0;
  bool isValidToProceed = false;
  //late Event event;
  late EventArgs eventArgs;
  late List<Widget> steps;

  //EVENT REQ ARGS
  List<String> passIds = [];

  @override
  initState() {
    eventArgs = widget.args.event != null
        ? _getEventArgsFromEvent(widget.args.event!)
        : EventArgs();

    steps = _getStepsList();
    super.initState();
  }

  EventArgs _getEventArgsFromEvent(Event event) {
    return EventArgs(
      eventId: event.id,
      listingVisible: event.listingVisible,
      name: event.name,
      description: event.description,
      categoryId: event.category?.id,
      dateTime: event.dateTime,
      address: event.address,
      city: event.city,
      longitude: event.longitude,
      latitude: event.latitude,
      maxCapacity: event.maxCapacity,
      priceType: event.priceType,
      priceStartsFrom: event.priceStartsFrom,
      priceGoesUpto: event.priceGoesUpto,
      images: event.images,
      passes: event.passes,
      contactName: event.contact?.name,
      contactPhone: event.contact?.phone,
      contactWhatsApp: event.contact?.whatsapp,
      contactEmail: event.contact?.email,
      contactOrganization: event.contact?.organization,
    );
  }

  List<Widget> _getStepsList() {
    return [
      StepOneContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      StepTwoContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      StepThreeContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      StepFourContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      StepFiveContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(eventArgs, validation)),
      StepSixContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(eventArgs, validation)),
      StepSevenContainer(
          event: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(eventArgs, validation))
    ];
  }

  List<String> titles = [
    "When is it going to happen?",
    "Where is it going to happen?",
    "How much space is there?",
    "What is the price range for your pass?",
    "Have a name and photo for your event?",
    "Want to describe your event to attendees?",
    "Where should we contact for inquiries?"
  ];

  _childDataFilled(EventArgs updatedEventArgs, bool validation) {
    setState(() {
      if (validation) {
        eventArgs = updatedEventArgs;
      }

      isValidToProceed = validation;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SmartDialog.dismiss();
    return WillPopScope(
      onWillPop: () {
        if (stepperIndex > 0) {
          stepperIndex--;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: ColorStyle.whiteColor,
            foregroundColor: ColorStyle.secondaryTextColor,
            elevation: 0.5,
            title: Text(
              eventArgs.eventId != null ? "Edit Event" : "Upload Event",
              style: const TextStyle(
                  color: ColorStyle.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                if (stepperIndex == 0) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    stepperIndex--;
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorStyle.secondaryTextColor,
              ),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[stepperIndex],
                  style: const TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: stepperIndex == 1
                      ? steps[stepperIndex]
                      : SingleChildScrollView(
                          child: steps[stepperIndex],
                        ),
                ),
                const SizedBox(height: 20),
                _stepperIndicator(),
                const SizedBox(height: 15),
                Container(
                    width: double.maxFinite,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: !isValidToProceed
                            ? null
                            : [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color:
                                        ColorStyle.blackColor.withOpacity(0.25))
                              ]),
                    child: !isValidToProceed
                        ? CustomRoundedButton(
                            'Continue',
                            () {},
                            buttonBackgroundColor: ColorStyle.whiteColor,
                            textColor: ColorStyle.primaryColor,
                            borderColor: ColorStyle.primaryColor,
                            roundedCorners: 12,
                            elevation: 0,
                            textWeight: FontWeight.bold,
                          )
                        : CustomRoundedButton(
                            stepperIndex < 6 ? 'Continue' : 'Publish',
                            () async {
                              if (stepperIndex < 6 && isValidToProceed) {
                                setState(() {
                                  stepperIndex++;
                                  isValidToProceed = false;
                                });
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                                bool areImagesUpload =
                                    await _getImageInternetUrls();

                                if (areImagesUpload) {
                                  if (eventArgs.passes != null &&
                                      eventArgs.passes!.isNotEmpty) {
                                    _getPassIds();
                                  } else {
                                    _showPublishPreferanceDialog();
                                  }
                                }
                              }
                            },
                            roundedCorners: 12,
                            textWeight: FontWeight.bold,
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _getImageInternetUrls() async {
    try {
      SmartDialog.showLoading(
        builder: (_) => const LoadingUtil(
          type: 4,
          text: "Processing your images...",
        ),
      );
      List<String> imageLocalPaths = eventArgs.images ?? [];

      List<String> publicFacingUrls = [];
      for (int i = 0; i < imageLocalPaths.length; i++) {
        String imagePath = imageLocalPaths[i];
        if (imagePath != "") {
          if (imagePath.startsWith("http")) {
            publicFacingUrls.add(imagePath);
          } else {
            BaseResponse baseResponse =
                await cloudinaryService.uploadImages(imagePath);

            if (baseResponse.error == null) {
              CloudinaryUploadResponse cloudinaryUploadResponse =
                  baseResponse.snapshot;
              publicFacingUrls.add(cloudinaryUploadResponse.url ?? "");
            } else {
              if (mounted) {
                ToastUtils.showCustomSnackbar(
                    context: context, contentText: baseResponse.error ?? "");
              }

              return false;
            }
          }
          SmartDialog.dismiss();
        }
      }

      List<String> eventImages = publicFacingUrls;
      eventArgs.images = eventImages;

      return true;
    } catch (e) {
      SmartDialog.dismiss();
      if (mounted) {
        ToastUtils.showCustomSnackbar(
            context: context, contentText: e.toString());
      }

      return false;
    }
  }

  _getPassIds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    SmartDialog.showLoading(
        builder: (_) => const LoadingUtil(
              type: 4,
              text: "Please wait...",
            ));

    if (eventArgs.eventId != null) {
      await passService.deletePasses(eventArgs.eventId!);
    }

    passService.addPasses(eventArgs.passes!).then((value) {
      SmartDialog.dismiss();
      if (value.snapshot != null) {
        PassResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          passIds = apiResponse.data?.passIds ?? [];
          _showPublishPreferanceDialog();
        } else {
          ToastUtils.showCustomSnackbar(
              context: context, contentText: apiResponse.message ?? "");
        }
      } else {
        ToastUtils.showCustomSnackbar(
            context: context, contentText: value.error ?? "");
      }
    });
  }

  _showPublishPreferanceDialog() {
    Dialog dialog = Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Publish Publicly",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "To maintain integrity, your event will be reviewed by our team. After the approval do you want to publish this event to the public catalogue of Event Bazaar instantly?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 40,
                              child: CustomRoundedButton(
                                "Later",
                                () {
                                  eventArgs.listingVisible = false;
                                  Navigator.of(context).pop();
                                  if (eventArgs.eventId == null) {
                                    _uploadEventToServer();
                                  } else {
                                    _editEvent();
                                  }
                                },
                                borderColor: ColorStyle.greyColor,
                                buttonBackgroundColor: ColorStyle.greyColor,
                                textColor: ColorStyle.secondaryTextColor,
                                textSize: 14,
                                roundedCorners: 4,
                                textWeight: FontWeight.w600,
                              ))),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: SizedBox(
                              height: 40,
                              child: CustomRoundedButton(
                                "Publish",
                                () {
                                  eventArgs.listingVisible = true;
                                  Navigator.of(context).pop();
                                  if (eventArgs.eventId == null) {
                                    _uploadEventToServer();
                                  } else {
                                    _editEvent();
                                  }
                                },
                                textSize: 14,
                                roundedCorners: 4,
                                textWeight: FontWeight.w600,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => dialog,
        barrierColor: const Color(0x59000000));
  }

  _uploadEventToServer() {
    try {
      SmartDialog.showLoading(
          builder: (_) => LoadingUtil(
                type: 4,
                text: eventArgs.listingVisible!
                    ? "Publishing your event..."
                    : "Saving your event...",
              ));

      eventService.uploadEvent(eventArgs, passIds).then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          EventResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            SellerHomeScreen.eventBus.fire(RefreshMyEvents());
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText: "Congratulations! Your event has been published",
            );
            Future.delayed(const Duration(milliseconds: 1600)).then((value) {
              Navigator.of(context).pop();
            });
          } else {
            ToastUtils.showCustomSnackbar(
                context: context, contentText: apiResponse.message ?? "");
          }
        } else {
          ToastUtils.showCustomSnackbar(
              context: context, contentText: value.error ?? "");
        }
      });
    } catch (e) {
      ToastUtils.showCustomSnackbar(
          context: context, contentText: e.toString());
    }
  }

  _editEvent() {
    try {
      SmartDialog.showLoading(
          builder: (_) =>
              const LoadingUtil(type: 4, text: "Updating your event..."));

      eventService.editEvent(eventArgs, passIds).then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          EventResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            SellerHomeScreen.eventBus.fire(RefreshMyEvents());
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText:
                  "Congratulations! Your event has been updated successfully",
            );
            Future.delayed(const Duration(milliseconds: 2000)).then((value) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          } else {
            ToastUtils.showCustomSnackbar(
                context: context, contentText: apiResponse.message ?? "");
          }
        } else {
          ToastUtils.showCustomSnackbar(
              context: context, contentText: value.error ?? "");
        }
      });
    } catch (e) {
      ToastUtils.showCustomSnackbar(
          context: context, contentText: e.toString());
    }
  }

  _stepperIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 0
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 0
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 0,
            child: const Text(
              "1",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 1
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 1
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 1
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 1,
            child: const Text(
              "2",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 2
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 2
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 2
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 2,
            child: const Text(
              "3",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 3
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 3
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 3
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 3,
            child: const Text(
              "4",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 4
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 4
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 4
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 4,
            child: const Text(
              "5",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 5
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 5
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 5
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 5,
            child: const Text(
              "6",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 6
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 6
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 6
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 6,
            child: const Text(
              "7",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
      ],
    );
  }
}
