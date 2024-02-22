import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/category_response/category_response.dart';
import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/services/category_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:flutter/material.dart';

class CategoryListSheet extends StatefulWidget {
  const CategoryListSheet({super.key});

  @override
  State<CategoryListSheet> createState() => _CategoryListSheetState();
}

class _CategoryListSheetState extends State<CategoryListSheet> {
  CategoryService categoryService = CategoryService();
  List<Category>? categoryList;
  bool isLoading = true;

  @override
  initState() {
    _getCategories(isForAll: true);
    super.initState();
  }

  _getCategories({bool isForAll = false}) {
    categoryService.getCategories(isForAll: isForAll).then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        CategoryResponse apiResponse = value.snapshot;
        if (apiResponse.isSuccess ?? false) {
          categoryList = apiResponse.data;
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Column(
        children: [
          Expanded(
            child: categoryList == null
                ? const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) => TextButton(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {
                          // setState(() {
                          //   selectedCity = cityList[index].name;
                          // });
                          // _getEventsList();
                          Navigator.of(context).pop(categoryList![index]);
                        },
                        child: Text(
                          categoryList![index].categoryName ?? "",
                          style: const TextStyle(
                              color: ColorStyle.primaryTextColor,
                              fontWeight: FontWeight.w600),
                        )),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: categoryList!.length),
          ),
        ],
      ),
    );
  }
}
