import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class CategoryListSheet extends StatefulWidget {
  final List<Category> categoryList;
  const CategoryListSheet({super.key, required this.categoryList});

  @override
  State<CategoryListSheet> createState() => _CategoryListSheetState();
}

class _CategoryListSheetState extends State<CategoryListSheet> {
  late List<Category> categoryList;
  bool isLoading = true;

  @override
  initState() {
    categoryList = widget.categoryList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Column(
        children: [
          Expanded(
            child:
                // categoryList == null
                //     ? const Center(
                //         child: SizedBox(
                //           child: CircularProgressIndicator(),
                //         ),
                //       )
                //     :
                ListView.separated(
                    itemBuilder: (context, index) => TextButton(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {
                          Navigator.of(context).pop(categoryList[index]);
                        },
                        child: Text(
                          categoryList[index].name ?? "",
                          style: const TextStyle(
                              color: ColorStyle.primaryTextColor,
                              fontWeight: FontWeight.w600),
                        )),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: categoryList.length),
          ),
        ],
      ),
    );
  }
}
