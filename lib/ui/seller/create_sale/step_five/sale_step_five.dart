import 'dart:convert';

import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class SaleStepFive extends StatefulWidget {
  final SaleArgs sale;
  final Function(SaleArgs, bool) onDataFilled;
  const SaleStepFive(
      {super.key, required this.sale, required this.onDataFilled});

  @override
  State<SaleStepFive> createState() => _SaleStepFiveState();
}

class _SaleStepFiveState extends State<SaleStepFive> {
  final _controller = QuillController.basic();
  String selectedCategory = "";
  late SaleArgs eventArgs;

  @override
  void initState() {
    eventArgs = widget.sale;
    if (eventArgs.description != null) {
      final jsonDescription = json.decode(eventArgs.description ?? "");
      _controller.document = Document.fromJson(jsonDescription);
    }

    super.initState();

    _controller.addListener(() => _alertParentWidget());

    Future.delayed(const Duration(microseconds: 500)).then((value) {
      _alertParentWidget();
    });
  }

  _alertParentWidget() async {
    String jsonDescription =
        json.encode(_controller.document.toDelta().toJson());
    if (jsonDescription != "") {
      eventArgs.description = jsonDescription;

      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            toolbarSize: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
            ),
            controller: _controller,
            multiRowsDisplay: false,
            showInlineCode: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showFontSize: false,
            showFontFamily: false,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: true,
            showListCheck: false,
            showCodeBlock: false,
            showIndent: false,
            showUndo: false,
            showRedo: false,
            showDirection: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
          ),
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              minHeight: 100,
              maxHeight: 150,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
