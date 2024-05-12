import 'package:clipboard/clipboard.dart';
import 'package:eventify/models/api_models/contacts_response/contacts_response.dart';
import 'package:eventify/models/api_models/contacts_response/user_contact.dart';
import 'package:eventify/services/stats_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserContactListSheet extends StatefulWidget {
  final String filter;
  final String eventId;

  const UserContactListSheet(
      {super.key, required this.filter, required this.eventId});

  @override
  State<UserContactListSheet> createState() => _UserContactListSheetState();
}

class _UserContactListSheetState extends State<UserContactListSheet> {
  List<UserContact>? contacts;
  bool isLoading = true;

  @override
  void initState() {
    _getAllContactsList();
    super.initState();
  }

  _getAllContactsList() {
    setState(() {
      isLoading = true;
    });
    StatsService()
        .getStatsUsers(widget.filter, widget.eventId)
        .then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value.error == null) {
        ContactsResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          contacts = apiResponse.data?.users ?? [];
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
          contentText: "Please check your connection and try again later",
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          children: [
            Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : contacts == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: SvgPicture.asset(
                                  'assets/svgs/ic_error_ocurred.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "An error occured on our end, please try again in a few moments",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorStyle.secondaryTextColor),
                              ),
                            ],
                          )
                        : contacts!.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: SvgPicture.asset(
                                      "assets/svgs/ic_empty_interest.svg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Currently there are no impressions on this event",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorStyle.secondaryTextColor),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: contacts?.length ?? 0,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    FlutterClipboard.copy(
                                        "Name: ${contacts?[index].firstName} ${contacts?[index].lastName}\nEmail: ${contacts?[index].email ?? "N/A"}\nPhone: ${contacts?[index].phone == null ? "N/A" : "${contacts?[index].countryCode} ${contacts?[index].phone}"}");
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color:
                                                      ColorStyle.primaryColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${contacts?[index].firstName} ${contacts?[index].lastName}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: ColorStyle
                                                          .primaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: contacts?[index].email !=
                                                  null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 30),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.email,
                                                      size: 15,
                                                      color: ColorStyle
                                                          .secondaryTextColor,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "${contacts?[index].email}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: ColorStyle
                                                              .secondaryTextColor,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: contacts?[index].phone !=
                                                  null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 30),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      size: 15,
                                                      color: ColorStyle
                                                          .secondaryTextColor,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "${contacts?[index].countryCode} ${contacts?[index].phone}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: ColorStyle
                                                              .secondaryTextColor,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.copy_all,
                                          color: ColorStyle.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
          ],
        ),
      ),
    );
  }
}
