import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SaleStepThree extends StatefulWidget {
  final SaleArgs sale;
  final Function(SaleArgs, bool) onDataFilled;
  const SaleStepThree(
      {super.key, required this.sale, required this.onDataFilled});

  @override
  State<SaleStepThree> createState() => _SaleStepThreeState();
}

class _SaleStepThreeState extends State<SaleStepThree> {
  final TextEditingController _discountController = TextEditingController();
  late SaleArgs eventArgs;

  @override
  void initState() {
    eventArgs = widget.sale;
    _discountController.text = eventArgs.discountDescription ?? "";
    super.initState();

    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });

    _discountController.addListener(() => _alertParentWidget());
  }

  _alertParentWidget() {
    if (_discountController.text != "") {
      eventArgs.discountDescription = _discountController.text.trim();
      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        CustomTextField(
          controller: _discountController,
          hint: "Discount",
          icon: const Icon(Icons.percent),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ColorStyle.primaryColorExtraLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorStyle.primaryColor,
            ),
          ),
          child: const Text(
            "This user-facing text can be like: \"Flat 50% Off\" or \"Upto 50% Off\"",
            style: TextStyle(
              color: ColorStyle.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
