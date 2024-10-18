import 'package:eventify/models/misc_models/sale_filter.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleFilterSheet extends StatefulWidget {
  final SaleFilter preFilters;
  const SaleFilterSheet({super.key, required this.preFilters});

  @override
  State<SaleFilterSheet> createState() => _SaleFilterSheetState();
}

class _SaleFilterSheetState extends State<SaleFilterSheet> {
  late SaleFilter filter;
  final TextEditingController _startDateValueController =
      TextEditingController();
  final TextEditingController _startTimeValueController =
      TextEditingController();
  final TextEditingController _endDateValueController = TextEditingController();
  final TextEditingController _endTimeValueController = TextEditingController();
  DateTime? selectedStartDate;
  TimeOfDay? selectedStartTime;
  DateTime? selectedEndDate;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    filter = widget.preFilters;
    if (filter.startDateTime != null) {
      _startDateValueController.text =
          DateFormat('MMM d, y').format(filter.startDateTime!);
      _startTimeValueController.text =
          DateFormat('h:mm a').format(filter.startDateTime!);
    }
    if (filter.endDateTime != null) {
      _endDateValueController.text =
          DateFormat('MMM d, y').format(filter.endDateTime!);
      _endTimeValueController.text =
          DateFormat('h:mm a').format(filter.endDateTime!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Filters",
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorStyle.secondaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(
                          SaleFilter(
                            saleLocationType: 'both',
                            startDateTime: null,
                            endDateTime: null,
                            sortBy: 'relevance',
                          ),
                        ),
                        child: Container(
                          height: 30,
                          constraints: const BoxConstraints(maxWidth: 130),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              color: ColorStyle.primaryColorExtraLight,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                size: 20,
                                color: ColorStyle.primaryColor,
                              ),
                              SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  "Reset",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: ColorStyle.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Sale Location",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLocationsButtons(),
                  const SizedBox(height: 8),
                  const Text(
                    "Discount Start Date",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _selectDate(context, true);
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 55,
                              child: CustomTextField(
                                  controller: _startDateValueController,
                                  hint: "Date",
                                  icon: const Icon(Icons.today_outlined),
                                  keyboardType: TextInputType.emailAddress),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _selectTime(context, true);
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 55,
                              child: CustomTextField(
                                  controller: _startTimeValueController,
                                  hint: "Time",
                                  icon: const Icon(Icons.schedule),
                                  keyboardType: TextInputType.emailAddress),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Discount End Date",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _selectDate(context, false);
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 55,
                              child: CustomTextField(
                                  controller: _endDateValueController,
                                  hint: "Date",
                                  icon: const Icon(Icons.today_outlined),
                                  keyboardType: TextInputType.emailAddress),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _selectTime(context, false);
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 55,
                              child: CustomTextField(
                                  controller: _endTimeValueController,
                                  hint: "Time",
                                  icon: const Icon(Icons.schedule),
                                  keyboardType: TextInputType.emailAddress),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Sort By",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSortButtons(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.maxFinite,
            height: 45,
            child: CustomRoundedButton(
              'Save',
              () {
                if (selectedStartDate != null && selectedStartTime != null) {
                  DateTime combinedStartDateTime = DateTime(
                    selectedStartDate!.year,
                    selectedStartDate!.month,
                    selectedStartDate!.day,
                    selectedStartTime!.hour,
                    selectedStartTime!.minute,
                  );
                  filter.startDateTime = combinedStartDateTime;
                }
                if (selectedEndDate != null && selectedEndTime != null) {
                  DateTime combinedEndDateTime = DateTime(
                    selectedEndDate!.year,
                    selectedEndDate!.month,
                    selectedEndDate!.day,
                    selectedEndTime!.hour,
                    selectedEndTime!.minute,
                  );

                  filter.endDateTime = combinedEndDateTime;
                }

                Navigator.of(context).pop(filter);
              },
              roundedCorners: 12,
              elevation: 0,
              textWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildSortButtons() {
    return Column(
      children: [
        Row(
          children: [
            Radio<String>(
              value: "relevance",
              groupValue: filter.sortBy,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.sortBy = value;
                });
              },
            ),
            const Text("Relevance"),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Radio<String>(
              value: "dateStarting",
              groupValue: filter.sortBy,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.sortBy = value;
                });
              },
            ),
            const Text("Date Starting"),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Radio<String>(
              value: "dateEnding",
              groupValue: filter.sortBy,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.sortBy = value;
                });
              },
            ),
            const Text("Date Ending"),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  _buildLocationsButtons() {
    return Row(
      children: [
        Row(
          children: [
            Radio<String>(
              value: "online",
              groupValue: filter.saleLocationType,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.saleLocationType = value;
                });
              },
            ),
            const Text("Online"),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Radio<String>(
              value: "offline",
              groupValue: filter.saleLocationType,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.saleLocationType = value;
                });
              },
            ),
            const Text("Offline"),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Radio<String>(
              value: "both",
              groupValue: filter.saleLocationType,
              visualDensity: VisualDensity.compact,
              onChanged: (String? value) {
                setState(() {
                  filter.saleLocationType = value;
                });
              },
            ),
            const Text("Any"),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool forStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: forStart ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (forStart) {
        selectedStartDate = picked;
        _startDateValueController.text =
            DateFormat('MMM d, y').format(selectedStartDate!);
      } else {
        selectedEndDate = picked;
        _endDateValueController.text =
            DateFormat('MMM d, y').format(selectedEndDate!);
      }

      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context, bool forStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: forStart
          ? selectedStartTime ?? TimeOfDay.now()
          : selectedEndTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      DateTime dateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      if (forStart) {
        selectedStartTime = picked;
        _startTimeValueController.text = DateFormat('h:mm a').format(dateTime);
      } else {
        selectedEndTime = picked;
        _endTimeValueController.text = DateFormat('h:mm a').format(dateTime);
      }
      setState(() {});
    }
  }
}
