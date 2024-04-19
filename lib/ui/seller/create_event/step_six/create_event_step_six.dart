import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/category_response/category_list_response.dart';
import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/services/category_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepSixContainer extends StatefulWidget {
  final EventArgs event;
  final Function(EventArgs, bool) onDataFilled;
  const StepSixContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepSixContainer> createState() => _StepSixContainerState();
}

class _StepSixContainerState extends State<StepSixContainer> {
  final TextEditingController _descriptionController = TextEditingController();
  // CategoryService categoryService = CategoryService();
  List<Category> categories = [];
  String selectedCategory = "";
  late EventArgs eventArgs;
  bool isLoading = true;

  @override
  void initState() {
    eventArgs = widget.event;
    //print(eventArgs.description);
    //print(eventArgs.categoryId);
    if (eventArgs.description != null && eventArgs.categoryId != null) {
      _descriptionController.text = eventArgs.description ?? "";
      selectedCategory = eventArgs.categoryId ?? "";
    }

    super.initState();
    _getCategories();
    _descriptionController.addListener(() {
      _alertParentWidget();
    });

    Future.delayed(const Duration(microseconds: 500)).then((value) {
      _alertParentWidget();
    });
  }

  _alertParentWidget() async {
    if (_descriptionController.text != "" &&
        selectedCategory != "" &&
        categories.isNotEmpty) {
      eventArgs.description = _descriptionController.text;
      eventArgs.categoryId = categories
          .where((element) => element.id! == selectedCategory)
          .first
          .id;

      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  _getCategories() {
    setState(() {
      isLoading = true;
    });
    CategoryService().getCategories().then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        CategoryListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          categories = apiResponse.data?.categories ?? [];
          _alertParentWidget();
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  // _getCategories() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   categoryService.getCategories(isForAll: true).then((value) async {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     if (value.error == null) {
  //       CategoryResponse apiResponse = value.snapshot;
  //       if (apiResponse.isSuccess ?? false) {
  //         categories = apiResponse.data ?? [];
  //         _alertParentWidget();
  //       } else {
  //         ToastUtils.showCustomSnackbar(
  //           context: context,
  //           contentText: apiResponse.message ?? "",
  //           icon: const Icon(
  //             Icons.cancel_outlined,
  //             color: ColorStyle.whiteColor,
  //           ),
  //         );
  //       }
  //     } else {
  //       ToastUtils.showCustomSnackbar(
  //         context: context,
  //         contentText: value.error ?? "",
  //         icon: const Icon(
  //           Icons.cancel_outlined,
  //           color: ColorStyle.whiteColor,
  //         ),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        CustomTextField(
          controller: _descriptionController,
          hint: "Description",
          keyboardType: TextInputType.name,
          maxLines: 6,
        ),
        const SizedBox(height: 30),
        const Text(
          "Categories",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : categories.isEmpty
                ? GestureDetector(
                    onTap: () {
                      _getCategories();
                    },
                    child: const Center(
                      child: Text(
                        "We ran into an error loading categories\nPlease click here to releoad",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Column(
                        children: categories
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = e.id.toString();
                                  });
                                  _alertParentWidget();
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    width: double.maxFinite,
                                    height: 60,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: selectedCategory ==
                                                  e.id.toString()
                                              ? ColorStyle.primaryColor
                                              : ColorStyle.secondaryTextColor,
                                          width: 0.7),
                                    ),
                                    child: Row(children: [
                                      Radio(
                                          value: e.id.toString(),
                                          groupValue: selectedCategory,
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                selectedCategory =
                                                    e.id.toString();
                                              });
                                              _alertParentWidget();
                                            }
                                          }),
                                      Text(
                                        e.name ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: selectedCategory ==
                                                    e.id.toString()
                                                ? ColorStyle.primaryColor
                                                : ColorStyle
                                                    .secondaryTextColor),
                                      ),
                                    ])),
                              ),
                            )
                            .toList(),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       selectedCategory = "Other";
                      //     });
                      //     _alertParentWidget();
                      //   },
                      //   child: Container(
                      //       margin: const EdgeInsets.only(bottom: 15),
                      //       width: double.maxFinite,
                      //       height: 60,
                      //       padding: const EdgeInsets.symmetric(vertical: 20),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         border: Border.all(
                      //             color: selectedCategory == "Other"
                      //                 ? ColorStyle.primaryColor
                      //                 : ColorStyle.secondaryTextColor,
                      //             width: 0.7),
                      //       ),
                      //       child: Row(children: [
                      //         Radio(
                      //             value: "Other",
                      //             groupValue: selectedCategory,
                      //             onChanged: (value) {
                      //               if (value != null) {
                      //                 setState(() {
                      //                   selectedCategory = "Other";
                      //                 });
                      //                 _alertParentWidget();
                      //               }
                      //             }),
                      //         Text(
                      //           "Other",
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               color: selectedCategory == "Other"
                      //                   ? ColorStyle.primaryColor
                      //                   : ColorStyle.secondaryTextColor),
                      //         ),
                      //       ])),
                      // ),
                    ],
                  ),
        // Visibility(
        //   visible: selectedCategory == "Other",
        //   child: CustomTextField(
        //       controller: _descriptionController,
        //       hint: "Category Name",
        //       icon: null,
        //       keyboardType: TextInputType.name),
        // ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
