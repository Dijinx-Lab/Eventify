import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final SearchArgs args;
  const SearchScreen({super.key, required this.args});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.text = widget.args.query;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: ColorStyle.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
                            ]),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_back,
                          color: ColorStyle.secondaryTextColor,
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
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
                          onSubmitted: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
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
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 30,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: ColorStyle.primaryColorExtraLight,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 20,
                            color: ColorStyle.primaryColor,
                          ),
                          SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              "Filters",
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
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const CustomEventContainer();
                    }),
              )
            ],
          ),
        ));
  }
}
