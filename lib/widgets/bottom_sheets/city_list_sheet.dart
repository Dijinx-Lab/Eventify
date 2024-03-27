import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CityListSheet extends StatefulWidget {
  final List<City> cityList;

  const CityListSheet({super.key, required this.cityList});

  @override
  State<CityListSheet> createState() => _CityListSheetState();
}

class _CityListSheetState extends State<CityListSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<City>? searchedList;

  @override
  void initState() {
    _searchController.addListener(() => _searchList());
    super.initState();
  }

  _searchList() {
    String pattern = _searchController.text.toLowerCase();
    List<City> matches = [];

    for (City city in widget.cityList) {
      if (city.name?.toLowerCase().contains(pattern) ?? false) {
        matches.add(city);
      }
    }

    setState(() {
      searchedList = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).size.height - 100
            : MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          children: [
            CustomTextField(
                controller: _searchController,
                hint: "Search for a city",
                icon: const Icon(
                  Icons.search,
                ),
                trailing: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _searchController.text = "";
                    setState(() {
                      searchedList = null;
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
                keyboardType: TextInputType.name),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => TextButton(
                      style: const ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () {
                        if (searchedList != null) {
                          Navigator.of(context).pop(searchedList![index].name);
                        } else {
                          Navigator.of(context)
                              .pop(widget.cityList[index].name);
                        }
                      },
                      child: Text(
                        searchedList != null
                            ? searchedList![index].name ?? ""
                            : widget.cityList[index].name ?? "",
                        style: const TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontWeight: FontWeight.w600),
                      )),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: searchedList != null
                      ? searchedList!.length
                      : widget.cityList.length),
            ),
          ],
        ),
      ),
    );
  }
}
