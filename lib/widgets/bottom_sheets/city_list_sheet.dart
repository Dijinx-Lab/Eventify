import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class CityListSheet extends StatelessWidget {
  final List<City> cityList;

  const CityListSheet({super.key, required this.cityList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Navigator.of(context).pop(cityList[index].name);
                    },
                    child: Text(
                      cityList[index].name ?? "",
                      style: const TextStyle(
                          color: ColorStyle.primaryTextColor,
                          fontWeight: FontWeight.w600),
                    )),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: cityList.length),
          ),
        ],
      ),
    );
  }
}
