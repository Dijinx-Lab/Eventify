import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/screen_args/create_sale_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomSaleContainer extends StatelessWidget {
  final Sale sale;
  final Function(String eventId) onBookmarked;
  const CustomSaleContainer(
      {super.key, required this.sale, required this.onBookmarked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: GestureDetector(
        onTap: () {
          if (!PrefUtils().getIsUserLoggedIn) {
            Navigator.of(context).pushNamed(notLoggedInRoute);
          } else {
            Navigator.of(context).pushNamed(saleDetailRoute,
                arguments: CreateSaleArgs(sale: sale));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 160,
                    child: CachedNetworkImage(
                        imageUrl: sale.images?.first ?? "",
                        errorWidget: (context, url, error) {
                          return Container(
                            color: ColorStyle.secondaryTextColor,
                            child: const Center(
                                child: Icon(
                              Icons.error_outline,
                              color: ColorStyle.whiteColor,
                            )),
                          );
                        },
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: _buildSellerCard(),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: _buildPriceCard(),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: _buildTimingsCard(),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: _buildSaveCard(),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sale.name ?? "",
              style: const TextStyle(
                  color: ColorStyle.primaryTextColor,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  _buildSellerCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorStyle.primaryTextColor.withOpacity(0.68),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assignment_ind_outlined,
              color: ColorStyle.whiteColor, size: 14),
          const SizedBox(
            width: 3,
          ),
          Text(
            sale.brand ?? "",
            style: const TextStyle(
                color: ColorStyle.whiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _buildPriceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ColorStyle.primaryColor.withOpacity(0.70),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sale.website != null &&
                        sale.website != "" &&
                        sale.linkToStores != null &&
                        sale.linkToStores != ""
                    ? "Online & Offline Sale"
                    : sale.linkToStores != null && sale.linkToStores != ""
                        ? "Offline Sale"
                        : "Online Sale",
                style: const TextStyle(
                    color: ColorStyle.accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ColorStyle.primaryColor.withOpacity(0.70),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sell_outlined,
                  color: ColorStyle.accentColor, size: 14),
              const SizedBox(
                width: 3,
              ),
              Text(
                sale.discountDescription ?? "",
                style: const TextStyle(
                    color: ColorStyle.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildSaveCard() {
    return GestureDetector(
        onTap: () {
          if (sale.myEvent!) {
            onBookmarked(sale.id!);
          }
        },
        child: sale.approvedOn == null
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorStyle.accentColor.withOpacity(0.70),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_outlined,
                        color: ColorStyle.primaryColor, size: 18),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Pending Approval",
                      style: TextStyle(
                          color: ColorStyle.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              )
            : sale.myEvent!
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ColorStyle.primaryColor.withOpacity(0.70),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        sale.listingVisibile!
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: ColorStyle.accentColor,
                        size: 18))
                : (sale.preference?.bookmarked ?? false)
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColor.withOpacity(0.70),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          "Saved",
                          style: TextStyle(
                              color: ColorStyle.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ))
                    : Container()
        // Icon(
        //     event.myEvent!
        //         ?
        //         :
        //             ? Icons.bookmark
        //             : Icons.bookmark_outline,
        //     ),

        );
  }

  _buildTimingsCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorStyle.primaryTextColor.withOpacity(0.68),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today,
                  color: ColorStyle.whiteColor, size: 14),
              const SizedBox(
                width: 3,
              ),
              Text(
                DateFormat('MMM d, y').format(sale.endDateTime!),
                style: const TextStyle(
                    color: ColorStyle.whiteColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule,
                  color: ColorStyle.whiteColor, size: 14),
              const SizedBox(
                width: 3,
              ),
              Text(
                DateFormat('h:mm a').format(sale.endDateTime!),
                style: const TextStyle(
                    color: ColorStyle.whiteColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
