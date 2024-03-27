import 'package:eventify/models/api_models/pass_response/pass.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PassDetailsSheet extends StatelessWidget {
  final List<Pass> passDetails;
  const PassDetailsSheet({super.key, required this.passDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Pass Details",
              style: TextStyle(
                  color: ColorStyle.secondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: passDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 20,
                        top: index == 0 ? 0 : 20),
                    decoration: BoxDecoration(
                        border: index == passDetails.length - 1
                            ? null
                            : Border(
                                bottom: BorderSide(
                                    color: ColorStyle.secondaryTextColor,
                                    width: 0.5))),
                    child: Row(
                      children: [
                        Text(
                          passDetails[index].name ?? "",
                          style: const TextStyle(
                              color: ColorStyle.primaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.sell_outlined,
                                  size: 15,
                                  color: ColorStyle.primaryColorLight,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  // passDetails[index]
                                  //         .discount!.discountedPrice!
                                  //         .toString() ??
                                  "",
                                  style: const TextStyle(
                                    color: ColorStyle.primaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  passDetails[index].fullPrice?.toString() ??
                                      "",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: ColorStyle.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.history_toggle_off_outlined,
                                  size: 15,
                                  color: ColorStyle.primaryColorLight,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('MMM d, y').format(
                                      passDetails[index].discount!.lastDate!),
                                  style: const TextStyle(
                                    color: ColorStyle.primaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
