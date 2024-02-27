import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/views/screens/ppob/confirm_paymentv2.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  late ExpandableController ec;

  bool expansion = false;

  int selectedTopup = -1;
  int selectedVA = -1;

  String productId = "";
  dynamic price = "";
  String paymentChannel = "";

  Future<void> getData() async {
    if(mounted) {
      await context.read<PPOBProvider>().getListWalletDenom(context);
    }
    if(mounted) {
      await context.read<PPOBProvider>().getVA(context);
    }
  }

  @override 
  void initState() {
    super.initState();

    ec = ExpandableController(initialExpanded: false);

    Future.wait([getData()]);
  }

  @override 
  void dispose() {
    ec.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();  
  } 
  
  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.greyLightPrimary,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
    
          return RefreshIndicator(
            onRefresh: () {
              return Future.sync(() {
                context.read<PPOBProvider>().getListWalletDenom(context);
                context.read<PPOBProvider>().getVA(context);
              });
            },
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
          
                const CustomAppBar( title: 'TopUp Saldoku', ).buildSliverAppBar(context),
                
                Consumer<PPOBProvider>(
                  builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                  if(ppobProvider.listWalletDenomStatus == ListWalletDenomStatus.loading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorResources.primary,
                          ),
                        ),
                      );
                    }
                    else if(ppobProvider.listWalletDenomStatus == ListWalletDenomStatus.empty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(getTranslated("THERE_IS_NO_DATA", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          ),
                        ),
                      );
                    }
                    else if(ppobProvider.listWalletDenomStatus == ListWalletDenomStatus.error) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          ),
                        ),
                      );
                    }
                  else {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        Consumer<PPOBProvider>(
                          builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                            return Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                left: 25.0,
                                right: 25.0
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: ppobProvider.listWalletDenom.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.0,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int i) {
                                  final WalletDenomData selectedDenom = ppobProvider.listWalletDenom[i];
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorResources.white,
                                            borderRadius: BorderRadius .circular(13.0),
                                            border: Border.all(
                                              width: 2.5,
                                              color: selectedTopup == i
                                                ? ColorResources.primary
                                                : ColorResources.hintColor
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTopup = i;
                                                productId = selectedDenom.id!;
                                                price = selectedDenom.denom.toString();
                                              });
                                              NS.push(context, ConfirmPaymentV2(
                                                accountNumber: SharedPrefs.getUserPhone(),
                                                description: 'Isi Saldo sebesar ${selectedDenom.denom}',
                                                price: selectedDenom.denom!.toDouble(),
                                                adminFee: ppobProvider.adminFee!,
                                                productId: selectedDenom.id!,
                                                provider: 'asdasd',
                                                productName: 'Saldo',
                                                type: "topup",
                                              ));
                                            },
                                            child: Container(
                                              width: 100.0,
                                              decoration: BoxDecoration(
                                                color: selectedTopup == i ? ColorResources.primary.withOpacity(0.3) : ColorResources.white,
                                                borderRadius: BorderRadius .circular(10.0)
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(NumberFormat("###,000", "id_ID").format(selectedDenom.denom),
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.black,
                                                      fontSize: Dimensions.fontSizeOverLarge,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Text(NumberFormat("###,000", "id_ID").format((selectedDenom.denom! + ppobProvider.adminFee!)),
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeDefault,
                                                      color: selectedTopup == i 
                                                        ? ColorResources.primary
                                                        :ColorResources.black,
                                                      fontWeight: selectedTopup == i 
                                                        ? FontWeight.w500
                                                        : FontWeight.w300
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ),
                                      )
                                    ]
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ]
                    )
                  );
                  }
                })
              ],
            ),
          );
        },
      )
    );
  }
}
