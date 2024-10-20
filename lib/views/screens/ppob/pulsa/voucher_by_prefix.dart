import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hp3ki/data/models/ppob_v2/denom_pulsa.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/ppob/confirm_paymentv2.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({super.key});

  @override
  State<PulsaScreen> createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  FlutterContactPicker cp = FlutterContactPicker();
  Contact? contact;

  late TextEditingController phoneNumberC;
  String phoneNumber = "";

  int selected = -1;

  String productCode = "";
  String productName = "";
  int productPrice = 0;

  bool isloading = false;

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
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: globalKey,
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
      
                        const CustomAppBar(title: 'Pulsa').buildSliverAppBar(context),
      
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
                                                type: "PULSA"
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
                                      Contact? c = await cp.selectContact();
                                      if(c != null) {
                                        setState(() {
                                          phoneNumberC.text = c.phoneNumbers![0].replaceAll(RegExp("[()+\\s-]+"), "");
      
                                          if(phoneNumberC.text.startsWith('0')) {
                                            setState(() {
                                              phoneNumber = '62${phoneNumberC.text.replaceFirst(RegExp(r'0'), '')}';
                                              phoneNumberC.text = phoneNumberC.text.replaceFirst(RegExp(r'0'), '');
                                            });
                                          } else {
                                            phoneNumber = phoneNumberC.text;
                                            phoneNumberC.text = phoneNumberC.text.replaceFirst(RegExp(r'62'), '');
                                          }

                                          if (debounce?.isActive ?? false) debounce!.cancel();
                                            debounce = Timer(const Duration(milliseconds: 500), () {
                                              context.read<PPOBProvider>().getVoucherPulsaByPrefix(context, prefix:  int.parse(phoneNumber), type: "PULSA");
                                            });
                                        });
                                      }
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
                                        child: Text('Tidak ada data.',
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeDefault
                                          ),
                                        )
                                      ),
                                    );
                                  }
                                  else if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.error) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        top: 50.0
                                      ),
                                      child: const SizedBox(
                                        height: 150.0,
                                        child: Center(
                                          child: Text('Ada yang bermasalah.',
                                            style: TextStyle(
                                              fontSize: Dimensions.fontSizeDefault
                                            ),
                                          )
                                        ),
                                      ),
                                    );
                                  }
                                  else {
                                  return AlignedGridView.count(
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
                                    final DenomPulsaData selectedDenom = ppobProvider.listVoucherPulsaByPrefixData[i];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                      
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                                            
                                            Container(
                                              height: 80.0,
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
                                                      productCode = selectedDenom.productCode;
                                                      productName = selectedDenom.productName;
                                                      productPrice = selectedDenom.productPrice;
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
                                                        Text(selectedDenom.productName,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            fontWeight: FontWeight.w600,
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
                                                              Helper.formatCurrency(
                                                                double.parse(selectedDenom.productPrice.toString())
                                                              ).split('.')[0],
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
                                                              Helper.formatCurrency(
                                                                double.parse(selectedDenom.productPrice.toString())
                                                              ).split('.')[1],
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
                                  }
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
                          onTap: selected != -1 
                          ? () {
                              if(phoneNumberC.text.length < 9) {
                                ShowSnackbar.snackbar("Nomor ponsel minimal 10 digit", "", ColorResources.error);
                                return;
                              }
                              final int price = productPrice - 2000;

                              NS.push(context, ConfirmPaymentV2(
                                  accountNumber: phoneNumber,
                                  productCodePulsa: productCode,
                                  productName: productName,
                                  price: price.toDouble(),
                                  description: 'Isi Pulsa sebesar $price',
                                  adminFee: 2000,
                                  type: "pulsa",
                                )
                              );
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
      ),
    );
  }
}