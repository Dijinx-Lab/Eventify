import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        title: const Text(
          "Alerts",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 2,
          itemBuilder: (context, index) {
            return _alertsCard();
          }),
    );
  }

  Widget _alertsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 100,
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
          color: ColorStyle.whiteColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: ColorStyle.blackColor.withOpacity(0.25))
          ]),
      child: Stack(
        children: [
          Row(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/pngs/example_card_image.png",
                  height: 60,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 10),
                  const Text(
                    "UN MUN 2023 Spring",
                    style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assignment_ind_outlined,
                          color: ColorStyle.secondaryTextColor, size: 14),
                      SizedBox(
                        width: 3,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Ahmed Afzal",
                        style: TextStyle(
                            color: ColorStyle.secondaryTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 5,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.schedule,
                        color: ColorStyle.primaryColor, size: 14),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "9:30 PM",
                      style: TextStyle(
                        color: ColorStyle.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.today_outlined,
                        color: ColorStyle.primaryColor, size: 14),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "09, Aug 2023",
                      style: TextStyle(
                        color: ColorStyle.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
