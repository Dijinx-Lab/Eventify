import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  TextEditingController _searchController = TextEditingController();

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: ColorStyle.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: ColorStyle.blackColor.withOpacity(0.25))
                        ]),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: ColorStyle.primaryColor,
                          ),
                          hintStyle: TextStyle(fontSize: 13),
                          hintText: "Search for an event",
                          border: InputBorder.none),
                      onSubmitted: (value) {
                        Navigator.of(context).pushNamed(searchRoute,
                            arguments:
                                SearchArgs(_searchController.text.trim()));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 80,
                  height: 45,
                  decoration: BoxDecoration(
                      color: ColorStyle.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: ColorStyle.blackColor.withOpacity(0.25))
                      ]),
                  child: const Center(
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorStyle.whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "Popular Categories",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See all",
                      style: TextStyle(
                          color: ColorStyle.primaryColor,
                          fontSize: 14,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.only(left: 20),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: ColorStyle.primaryColorLight),
                    child: const Text(
                      'Concert',
                      style: TextStyle(color: ColorStyle.whiteColor),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "Near You",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  width: 130,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: ColorStyle.primaryColorExtraLight,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: ColorStyle.primaryColor,
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          "Gulshan-e-Iqbal street 11",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const CustomEventContainer();
                }),
          )
        ]),
      ),
    );
  }
}
