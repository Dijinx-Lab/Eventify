import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/screen_args/create_sale_args.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/base/base_seller_screen.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_sale_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SellerSalesScreen extends StatefulWidget {
  const SellerSalesScreen({super.key});

  @override
  State<SellerSalesScreen> createState() => _SellerSalesScreenState();
}

class _SellerSalesScreenState extends State<SellerSalesScreen> {
  List<Sale>? salesList;
  bool isLoading = true;
  SaleService saleService = SaleService();
  bool isFloatingShown = false;

  @override
  void initState() {
    _getSalesList();
    _showAfterDelay();
    super.initState();

    BaseSellerScreen.eventBus.on<RefreshDiscoverEvents>().listen((ev) {
      if (mounted) {
        _getSalesList();
      }
    });
  }

  _showAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isFloatingShown = true;
      });
    });

    BaseSellerScreen.eventBus.on<RefreshMyEvents>().listen((event) {
      if (mounted) {
        _getSalesList();
      }
    });
  }

  _getSalesList() {
    setState(() {
      isLoading = true;
      salesList = null;
    });
    saleService.getSales("user").then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value.error == null) {
        SaleListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          setState(() {
            salesList = apiResponse.data?.sales ?? [];
          });
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
    return Scaffold(
      floatingActionButton: !isFloatingShown
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createSaleRoute,
                      arguments: CreateSaleArgs(sale: null));
                },
                backgroundColor: ColorStyle.primaryColor,
                child: const Icon(
                  Icons.add,
                  size: 35,
                  color: ColorStyle.whiteColor,
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : salesList == null
              ? _errorCard()
              : salesList!.isEmpty
                  ? _emptyCaseCard()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: salesList!.length,
                      itemBuilder: (context, index) {
                        return CustomSaleContainer(
                          sale: salesList![index],
                          onBookmarked: (eventId) {},
                        );
                      }),
    );
  }

  _emptyCaseCard() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset(
                'assets/svgs/ic_empty_search.svg',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "You haven't posted any sales yet",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: 200,
                height: 40,
                child: CustomRoundedButton("Refresh", () {
                  _getSalesList();
                }))
          ],
        ),
      ),
    );
  }

  _errorCard() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset(
                'assets/svgs/ic_error_ocurred.svg',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "An error occured on our end, please try again in a few moments",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: 200,
                height: 40,
                child: CustomRoundedButton("Refresh", () {
                  _getSalesList();
                }))
          ],
        ),
      ),
    );
  }
}
