import 'package:eventify/models/api_models/event_list_response/event.dart';
import 'package:eventify/models/api_models/event_list_response/pass_detail.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/input_formatting_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepFourContainer extends StatefulWidget {
  final Event event;
  final Function(Event, bool) onDataFilled;
  const StepFourContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepFourContainer> createState() => _StepFourContainerState();
}

class _StepFourContainerState extends State<StepFourContainer> {
  final TextEditingController _startsFromController = TextEditingController();
  final TextEditingController _goesUptoController = TextEditingController();
  final TextEditingController _passPriceController = TextEditingController();
  final TextEditingController _discountPercentController =
      TextEditingController();
  final TextEditingController _dicountedPriceController =
      TextEditingController();
  final TextEditingController _discountEndDateController =
      TextEditingController();
  final TextEditingController _passInfoController = TextEditingController();
  DateTime? _discountEndingOn;

  List<PassDetail> passDetails = [];
  DateTime selectedDate = DateTime.now();
  String _groupValue = "";
  late Event event;

  @override
  void initState() {
    event = widget.event;
    if (event.priceStartFrom == 0 && event.priceGoesUpto == 0) {
      _groupValue = "free";
    } else if ((event.priceStartFrom ?? 0) > 0 &&
        (event.priceGoesUpto ?? 0) > 0) {
      _groupValue = "paid";
      _startsFromController.text = event.priceStartFrom?.toString() ?? "";
      _goesUptoController.text = event.priceGoesUpto?.toString() ?? "";
      passDetails = event.eventPassDetails ?? [];
    }

    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });
    super.initState();
  }

  _alertParentWidget() async {
    if (_groupValue != "") {
      if (_groupValue == "free") {
        event.priceStartFrom = 0;
        event.priceGoesUpto = 0;
        widget.onDataFilled(event, true);
      } else if (_groupValue == "paid" &&
          _startsFromController.text != "" &&
          _goesUptoController.text != "" &&
          passDetails.isNotEmpty) {
        event.priceStartFrom = int.parse(_startsFromController.text);
        event.priceGoesUpto = int.parse(_goesUptoController.text);
        event.eventPassDetails = passDetails;
        widget.onDataFilled(event, true);
      } else {
        widget.onDataFilled(event, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _groupValue = "free";
            });
            _alertParentWidget();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
            ),
            child: Row(
              children: [
                Radio(
                    value: "free",
                    groupValue: _groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupValue = value;
                        });
                        _alertParentWidget();
                      }
                    }),
                const Text("This is a free event")
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _groupValue = "paid";
            });
            _alertParentWidget();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
            ),
            child: Row(
              children: [
                Radio(
                    value: "paid",
                    groupValue: _groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupValue = value;
                        });
                        _alertParentWidget();
                      }
                    }),
                const Text("This is a paid event")
              ],
            ),
          ),
        ),
        Visibility(
          visible: _groupValue == "paid",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                  controller: _startsFromController,
                  hint: "Starts From",
                  icon: const Icon(Icons.sell_outlined),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              CustomTextField(
                  controller: _goesUptoController,
                  hint: "Goes Upto",
                  icon: const Icon(Icons.sell_outlined),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pass Details",
                    style: TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      _showPassDetailsDialog(null);
                    },
                    child: const Text(
                      "Add Pass",
                      style: TextStyle(
                        color: ColorStyle.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              passDetails.isEmpty
                  ? const Center(
                      child: Text(
                        "You need to add atleast one type of pass for paid events",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorStyle.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(passDetails.length,
                          (index) => _buildPassDetailWidget(index)),
                    )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPassDetailWidget(int index) {
    return GestureDetector(
      onTap: () {
        _showPassDetailsDialog(index);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: ColorStyle.primaryColorExtraLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passDetails[index].passInfo ?? "",
                  style: const TextStyle(
                    color: ColorStyle.primaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      size: 15,
                      color: ColorStyle.primaryColorLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      passDetails[index].dicountedPrice?.toString() ?? "",
                      style: const TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      passDetails[index].passPrice?.toString() ?? "",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: ColorStyle.secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.history_toggle_off_outlined,
                      size: 15,
                      color: ColorStyle.primaryColorLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, y')
                          .format(passDetails[index].discountEndDate!),
                      style: const TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                _showPassDetailsDialog(index);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.edit_note_outlined,
                size: 28,
                color: ColorStyle.primaryColorLight,
              ),
            ),
            IconButton(
                onPressed: () {
                  _showDeletePassDetailDialog(index);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 25,
                  color: ColorStyle.primaryColorLight,
                ))
          ],
        ),
      ),
    );
  }

  _updateControllers(int? index) {
    if (index == null) {
      _passPriceController.text = "";
      _discountPercentController.text = "";
      _dicountedPriceController.text = "";
      _discountEndDateController.text = "";
      _passInfoController.text = "";
    } else {
      _passPriceController.text =
          passDetails[index].passPrice?.toString() ?? "";
      _discountPercentController.text =
          passDetails[index].discountPercent?.toString() ?? "";
      _dicountedPriceController.text =
          passDetails[index].dicountedPrice?.toString() ?? "";
      _discountEndDateController.text = passDetails[index].discountEndDate !=
              null
          ? DateFormat('MMM d, y').format(passDetails[index].discountEndDate!)
          : "";
      _passInfoController.text = passDetails[index].passInfo ?? "";
    }
  }

  _showPassDetailsDialog(int? index) {
    _updateControllers(index);
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
                    "Pass Details",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                            controller: _passInfoController,
                            hint: "Pass Name",
                            //   icon: const Icon(Icons.sell_outlined),
                            keyboardType: TextInputType.name),
                        const SizedBox(height: 15),
                        CustomTextField(
                            controller: _passPriceController,
                            hint: "Full Price",
                            inputFormatters: [
                              InputFormattingUtils.numbersOnly(),
                            ],
                            // icon: const Icon(Icons.sell_outlined),
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 25),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Discount (Optional)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorStyle.secondaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                  controller: _dicountedPriceController,
                                  hint: "Price",
                                  inputFormatters: [
                                    InputFormattingUtils.numbersOnly(),
                                  ],
                                  keyboardType: TextInputType.number),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: CustomTextField(
                                  controller: _discountPercentController,
                                  hint: "Percentage",
                                  inputFormatters: [
                                    InputFormattingUtils.numbersOnly(),
                                  ],
                                  keyboardType: TextInputType.number),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 60,
                              child: CustomTextField(
                                  controller: _discountEndDateController,
                                  hint: "Ending On",
                                  keyboardType: TextInputType.name),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 50,
                              child: CustomRoundedButton(
                                "Cancel",
                                () {
                                  Navigator.of(context).pop();
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
                              height: 50,
                              child: CustomRoundedButton(
                                "Save",
                                () {
                                  passDetails.add(PassDetail(
                                      passInfo: _passInfoController.text,
                                      passPrice:
                                          int.parse(_passPriceController.text),
                                      dicountedPrice: int.parse(
                                          _dicountedPriceController.text),
                                      discountPercent: int.parse(
                                          _discountPercentController.text),
                                      discountEndDate: _discountEndingOn));
                                  setState(() {});
                                  _alertParentWidget();
                                  Navigator.of(context).pop();
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

  _showDeletePassDetailDialog(int index) {
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
                    "Delete Pass",
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
                  "Are you sure you want to delete this pass?",
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
                                "Cancel",
                                () {
                                  Navigator.of(context).pop();
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
                                "Delete",
                                () {
                                  passDetails.removeAt(index);
                                  setState(() {});
                                  _alertParentWidget();
                                  Navigator.of(context).pop();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        _discountEndingOn = picked;
        selectedDate = picked;
        _discountEndDateController.text =
            DateFormat('MMM d, y').format(selectedDate);
      });
    }
  }
}
