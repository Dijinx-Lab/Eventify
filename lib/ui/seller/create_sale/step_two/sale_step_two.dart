import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SaleStepTwo extends StatefulWidget {
  final SaleArgs sale;
  final Function(SaleArgs, bool) onDataFilled;
  const SaleStepTwo(
      {super.key, required this.sale, required this.onDataFilled});

  @override
  State<SaleStepTwo> createState() => _SaleStepTwoState();
}

class _SaleStepTwoState extends State<SaleStepTwo> {
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _vendorWebsiteController =
      TextEditingController();
  final TextEditingController _vendorLocationsListController =
      TextEditingController();
  late SaleArgs eventArgs;

  @override
  void initState() {
    eventArgs = widget.sale;
    _vendorWebsiteController.text = eventArgs.website ?? "";
    _vendorLocationsListController.text = eventArgs.linkToStores ?? "";
    _vendorNameController.text = eventArgs.brandName ?? PrefUtils().lastBrand;
    super.initState();
    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });

    _vendorWebsiteController.addListener(() => _alertParentWidget());
    _vendorLocationsListController.addListener(() => _alertParentWidget());
    _vendorNameController.addListener(() => _alertParentWidget());
  }

  _alertParentWidget() {
    if ((_vendorWebsiteController.text != "" ||
            _vendorLocationsListController.text != "") &&
        _vendorNameController.text != "") {
      eventArgs.website = _vendorWebsiteController.text.trim();
      eventArgs.linkToStores = _vendorLocationsListController.text.trim();
      eventArgs.brandName = _vendorNameController.text.trim();
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
          controller: _vendorNameController,
          hint: "Brand Name",
          icon: const Icon(Icons.work_outline_rounded),
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _vendorWebsiteController,
          hint: "Link to Website",
          icon: const Icon(Icons.link),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _vendorLocationsListController,
          hint: "Link to Stores' Locations",
          icon: const Icon(Icons.add_location_alt_outlined),
          keyboardType: TextInputType.url,
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
            "Either online store or a link to store locations is required. You may enter both for more reachability",
            style: TextStyle(
              color: ColorStyle.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
