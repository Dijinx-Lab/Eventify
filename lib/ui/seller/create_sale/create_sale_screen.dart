import 'package:eventify/models/api_models/base_response/base_response.dart';
import 'package:eventify/models/api_models/cloudinary_response/cloudinary_upload_response.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_response.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/screen_args/create_sale_args.dart';
import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/services/cloudinary_service.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/base/base_seller_screen.dart';
import 'package:eventify/ui/seller/create_sale/step_five/sale_step_five.dart';
import 'package:eventify/ui/seller/create_sale/step_four/sale_step_four.dart';
import 'package:eventify/ui/seller/create_sale/step_one/sale_step_one.dart';
import 'package:eventify/ui/seller/create_sale/step_six/sale_step_six.dart';
import 'package:eventify/ui/seller/create_sale/step_three/sale_step_three.dart';
import 'package:eventify/ui/seller/create_sale/step_two/sale_step_two.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CreateSaleScreen extends StatefulWidget {
  final CreateSaleArgs args;
  const CreateSaleScreen({super.key, required this.args});

  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  CloudinaryService cloudinaryService = CloudinaryService();
  SaleService saleService = SaleService();
  int stepperIndex = 0;
  bool isValidToProceed = false;
  late SaleArgs eventArgs;
  late List<Widget> steps;

  @override
  initState() {
    eventArgs = widget.args.sale != null
        ? _getEventArgsFromEvent(widget.args.sale!)
        : SaleArgs();
    steps = _getStepsList();
    super.initState();
  }

  SaleArgs _getEventArgsFromEvent(Sale event) {
    return SaleArgs(
      eventId: event.id,
      listingVisible: event.listingVisibile,
      name: event.name,
      description: event.description,
      startDateTime: event.startDateTime,
      endDateTime: event.endDateTime,
      linkToStores: event.linkToStores,
      website: event.website,
      discountDescription: event.discountDescription,
      images: event.images,
      contactName: event.contact?.name,
      contactPhone: event.contact?.phone,
      contactWhatsApp: event.contact?.whatsapp,
      contactEmail: event.contact?.email,
      contactOrganization: event.contact?.organization,
    );
  }

  List<Widget> _getStepsList() {
    return [
      SaleStepOne(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      SaleStepTwo(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      SaleStepThree(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      SaleStepFour(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      SaleStepFive(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
      SaleStepSix(
          sale: eventArgs,
          onDataFilled: (event, validation) =>
              _childDataFilled(event, validation)),
    ];
  }

  List<String> titles = [
    "Select a time range for the sale",
    "Enter information about the vendor",
    "Enter the discount range that you are offering",
    "Add images and a name for your sale",
    "Tell people more about the specifics of your sale",
    "Contact information for inquiries",
  ];

  _childDataFilled(SaleArgs updatedEventArgs, bool validation) {
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
              eventArgs.eventId != null ? "Edit Sale" : "Upload Sale",
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
                            stepperIndex < 5 ? 'Continue' : 'Publish',
                            () async {
                              if (stepperIndex < 5 && isValidToProceed) {
                                setState(() {
                                  stepperIndex++;
                                  isValidToProceed = false;
                                });
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                                bool areImagesUpload =
                                    await _getImageInternetUrls();

                                if (areImagesUpload) {
                                  _showPublishPreferanceDialog();
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
                  "To maintain integrity, your listing will be reviewed by our team. After the approval do you want to publish this listing to the public catalogue of Event Bazaar instantly?",
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

      saleService.uploadSale(eventArgs).then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          SaleResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            BaseSellerScreen.eventBus.fire(RefreshMyEvents());
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText: "Congratulations! Your sale has been published",
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
              const LoadingUtil(type: 4, text: "Updating your listing..."));

      saleService.editSale(eventArgs).then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          SaleResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            BaseSellerScreen.eventBus.fire(RefreshMyEvents());
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText:
                  "Congratulations! Your listing has been updated successfully",
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
      ],
    );
  }
}
