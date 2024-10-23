import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/ppob/confirm_paymentv2.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PaketDataScreen extends StatefulWidget {
  const PaketDataScreen({super.key});

  @override
  State<PaketDataScreen> createState() => _PaketDataScreen();
}

class _PaketDataScreen extends State<PaketDataScreen> {


  late TextEditingController phoneNumberC;
  String phoneNumber = "";

  int selected = -1;

  String productCode = "";
  String productName = "";
  int productPrice = 0;

  Timer? debounce;

  @override 
  void initState() {
    super.initState();

    if(mounted) {
      context.read<PPOBProvider>().clearVoucherPulsaByPrefix();
    }
    
    phoneNumberC = TextEditingController();
  }

  @override 
  void dispose() {
    phoneNumberC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            
            ThemeData theme = Theme.of(context);

            return Stack(
              clipBehavior: Clip.none,
              children: [

                CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [

                    const CustomAppBar(title: 'Paket Data').buildSliverAppBar(context),

                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                    
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: ColorResources.transparent
                                  ),
                                  child: const Text("+62")
                                )
                              ),
                              Expanded(
                                flex: 6,
                                child: TextField(
                                  controller: phoneNumberC,
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (String val) {
                                    if(val.startsWith('0')) {
                                      setState(() {
                                        phoneNumber = '62${val.replaceFirst(RegExp(r'0'), '')}';
                                        phoneNumberC = TextEditingController(text: "8");
                                        phoneNumberC.selection = TextSelection.fromPosition(
                                          TextPosition(offset: val.length)
                                        );  
                                      });
                                    } else {
                                      phoneNumber = '62$val';
                                    }

                                    setState(() {
                                      selected = -1;
                                    });

                                    if(val.length >= 9) {
                                      if (debounce?.isActive ?? false) debounce!.cancel();
                                        debounce = Timer(const Duration(milliseconds: 500), () {
                                          context.read<PPOBProvider>().getVoucherPulsaByPrefix(
                                            context, 
                                            prefix: int.parse(phoneNumber), 
                                            type: "DATA"
                                          );
                                        });
                                    } else {
                                      context.read<PPOBProvider>().clearVoucherPulsaByPrefix();
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.hintColor
                                    ),
                                    border: UnderlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                )    
                              ),
                              GestureDetector(
                                onTap: () async {
                            
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: Image.asset('assets/images/icons/ic-contact.png',
                                    width: 25.0,
                                  )
                                ),
                              )
                            ],
                          ),
                    
                          Consumer<PPOBProvider>(
                            builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                              if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.idle) {
                                return const SizedBox();
                              }
                              if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.loading) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0
                                  ),
                                  height: 150.0,
                                  child: Center(
                                    child: SpinKitThreeBounce(
                                      size: 20.0,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                );
                              }
                              if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.empty) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0
                                  ),
                                  height: 150.0,
                                  child: const Center(
                                    child: Text('There is no product',
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                    )
                                  ),
                                );
                              }
                              if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.error) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0
                                  ),
                                  child: const SizedBox(
                                    height: 150.0,
                                    child: Center(
                                      child: Text('Oops! There was problem, please try again later',
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      )
                                    ),
                                  ),
                                );
                              }
                              return ppobProvider.listVoucherPulsaByPrefixData.isEmpty 
                              ? Container()
                              : AlignedGridView.count(
                                padding: const EdgeInsets.only(
                                  top: 50.0,
                                  bottom: 80.0
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                itemCount: ppobProvider.listVoucherPulsaByPrefixData.length,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 30.0,
                                itemBuilder: (BuildContext context, int i) {
                                  final DenomPulsaData selectedPaketData = ppobProvider.listVoucherPulsaByPrefixData[i];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color: selected == i 
                                              ? ColorResources.primary 
                                              : const Color(0xffF1F1F1),
                                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                              boxShadow: boxShadow
                                            ),
                                            width: 175.0,
                                            child: Material(
                                              color: selected == i 
                                              ? ColorResources.primary 
                                              : const Color(0xffF1F1F1),
                                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                              child: InkWell(
                                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                                onTap: () {
                                                  setState(() {
                                                    selected = i;
                                                    productCode = selectedPaketData.productCode;
                                                    productName = selectedPaketData.productName;
                                                    productPrice = selectedPaketData.productPrice;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 5.0,
                                                    right: 5.0,
                                                    bottom: 10.0
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(selectedPaketData.productName,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: Dimensions.fontSizeExtraSmall,
                                                          fontWeight: FontWeight.bold,
                                                          color: selected == i
                                                          ? Colors.white 
                                                          : Colors.black
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8.0),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            Helper.formatCurrency(0).split('.')[0],
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeExtraLarge,
                                                              fontWeight: FontWeight.bold,
                                                              color: selected == i
                                                              ? Colors.white 
                                                              : Colors.black
                                                            ),
                                                          ),
                                                          Text('.',
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeDefault,
                                                              fontWeight: FontWeight.bold,
                                                              color: selected == i
                                                              ? Colors.white 
                                                              : Colors.black
                                                            ),
                                                          ),
                                                          Text(
                                                            Helper.formatCurrency(0).split('.')[1],
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeDefault,
                                                              fontWeight: FontWeight.bold,
                                                              color: selected == i
                                                              ? Colors.white 
                                                              : Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ) 
                                          ),
                                                          
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                    
                        ])
                      ),
                    )

                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: CustomButton(
                      onTap:  selected != -1 
                      ? () {
                          if(phoneNumberC.text.length < 9) {
                            ShowSnackbar.snackbar("Nomor ponsel minimal 10 digit", "", ColorResources.error);
                            return;
                          }
                          NS.push(context, ConfirmPaymentV2(
                            accountNumber: phoneNumber,
                            productName: productName,
                            productCodePulsa: productCode,
                            price: productPrice.toDouble(),
                            description: 'Isi Paket Data',
                            type: 'pulsa',
                            adminFee: 2000,
                          ));
                        } 
                      : () {
                        if(selected == -1) {
                          ShowSnackbar.snackbar("Anda belum memilih denom", "", ColorResources.error);
                          return;
                        }
                      },
                      isBorderRadius: true,
                      isBorder: false,
                      isBoxShadow: false,
                      btnColor: selected != -1 
                      ?ColorResources.primary
                      :Colors.grey,
                      btnTxt: "Selanjutnya",
                    ),
                  )
                )

              ],
            );
          },
        )
      )
    );
  }
  
}