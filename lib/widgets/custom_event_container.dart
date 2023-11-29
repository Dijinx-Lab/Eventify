import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class CustomEventContainer extends StatelessWidget {
  const CustomEventContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(detailRoute);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                          image:
                              AssetImage("assets/pngs/example_card_image.png"),
                          fit: BoxFit.cover)),
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
            const Text(
              "UN MUN 2023 Spring",
              style: TextStyle(
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_ind_outlined,
              color: ColorStyle.whiteColor, size: 14),
          SizedBox(
            width: 3,
          ),
          Text(
            "Ahmed Afzal",
            style: TextStyle(
                color: ColorStyle.whiteColor,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorStyle.primaryColor.withOpacity(0.70),
          borderRadius: BorderRadius.circular(8)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sell_outlined, color: ColorStyle.accentColor, size: 14),
          SizedBox(
            width: 3,
          ),
          Text(
            "Starts From Rs 2000",
            style: TextStyle(
                color: ColorStyle.accentColor,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _buildSaveCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: ColorStyle.primaryColor.withOpacity(0.70),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.bookmark_outline,
          color: ColorStyle.accentColor, size: 18),
    );
  }

  _buildTimingsCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorStyle.primaryTextColor.withOpacity(0.68),
          borderRadius: BorderRadius.circular(8)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today,
                  color: ColorStyle.whiteColor, size: 14),
              SizedBox(
                width: 3,
              ),
              Text(
                "22, Aug 2023",
                style: TextStyle(
                    color: ColorStyle.whiteColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, color: ColorStyle.whiteColor, size: 14),
              SizedBox(
                width: 3,
              ),
              Text(
                "9:30 PM",
                style: TextStyle(
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
