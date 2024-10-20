import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dimensions.dart';

class ListrikScreen extends StatefulWidget {
  const ListrikScreen({super.key});

  @override
  State<ListrikScreen> createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TextEditingController plnPraC;
  late TextEditingController plnPasC;

  int selected = -1;

  String productCode = "";
  String productName = "";
  int productPrice = 0;

  int selectedChannelPln = 0;
  int count = 0;

  Timer? debounce;

  @override 
  void initState() {
    super.initState();

    if(mounted){
      context.read<PPOBProvider>().clearListPricePLN();
    }

    plnPraC = TextEditingController();
    plnPraC.addListener(tokenNumberChange);

    plnPasC = TextEditingController();
    plnPasC.addListener(tokenNumberChange);
  }

  @override 
  void dispose() {
    plnPasC = TextEditingController();
    plnPasC.addListener(tokenNumberChange);
  
    plnPraC.dispose();
    plnPraC.removeListener(tokenNumberChange);
  
    super.dispose();
  }

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### #### ####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.eager
  );

  void tokenNumberChange() {
    if(plnPraC.text.length >= 9) {
      if(debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        if(selectedChannelPln == 0) {
          context.read<PPOBProvider>().getListPricePLNPrabayar(context);
        } else {
          context.read<PPOBProvider>().postInquiryPLNPascaBayar(context, maskFormatter.getUnmaskedText());
        }
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
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

                    const CustomAppBar(title: 'Listrik').buildSliverAppBar(context),
                
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                    
                          Container(
                            decoration: const BoxDecoration(
                              color: ColorResources.backgroundDisabled,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedChannelPln = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedChannelPln == 0 ? ColorResources.white : null,
                                        border: selectedChannelPln == 0
                                          ? Border.all(
                                            width: 1.5, color: theme.primaryColor,
                                          )
                                          : null
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Prabayar",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black,
                                            fontWeight: selectedChannelPln == 0
                                              ? FontWeight.w600
                                              : FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ) 
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedChannelPln = 1;
                                      });
                                      if(plnPasC.text.trim() != "") {
                                        context.read<PPOBProvider>().postInquiryPLNPascaBayar(
                                          context, 
                                          plnPasC.text, 
                                        );
                                      } 
                                      context.read<PPOBProvider>().clearList();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedChannelPln == 1 ? ColorResources.white : null,
                                        border: selectedChannelPln == 1
                                          ? Border.all(
                                            width: 1.5, color: theme.primaryColor,
                                          )
                                          : null
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Pascabayar",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black,
                                            fontWeight: selectedChannelPln == 1
                                              ? FontWeight.w600
                                              : FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ) 
                                  ),
                                ),
                              ],
                            ),
                          ),

                          selectedChannelPln == 0 
                          ? Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [

                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        left: 16.0,
                                        right: 16.0,
                                        bottom: 30.0
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [

                                          TextField(
                                            style: const TextStyle(
                                              fontSize: Dimensions.fontSizeDefault
                                            ),
                                            inputFormatters: [
                                              maskFormatter,
                                            ],
                                            onChanged: (String val) {
                                              setState(() {
                                                count = maskFormatter.unmaskText(val).length;
                                              });
                                            },
                                            controller: plnPraC,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Isi ID Customer',
                                              hintStyle: TextStyle(
                                                fontSize: Dimensions.fontSizeDefault,
                                                color: ColorResources.hintColor
                                              ),
                                              border: UnderlineInputBorder(),
                                              enabledBorder: UnderlineInputBorder()
                                            )
                                          ),
                                        ],
                                      )
                                    ),
                                  ),

                                  Positioned(
                                    right: 14.0,
                                    bottom: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 2.0),
                                            child: Text(count.toString())
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 2.0,
                                              right: 2.0
                                            ),
                                            child: const Text("/")
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 2.0),
                                            child: const Text("20")
                                          ),
                                        ],
                                      ),
                                    )
                                  )

                                ],
                              )

                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: Dimensions.fontSizeDefault
                                    ),
                                    maxLength: 12,
                                    controller: plnPasC,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Isi ID Customer',
                                      hintStyle: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.hintColor
                                      ),
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder()
                                    )
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: 20.0
                              ),
                              child: Consumer<PPOBProvider>(
                                builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                                  return ppobProvider.inquiryPLNPascabayarStatus == InquiryPLNPascabayarStatus.loading 
                                  ? Container(
                                      width: double.infinity,
                                      color: ColorResources.white,
                                      height: 60.0,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: SpinKitThreeBounce(
                                          size: 20.0,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )  
                                  : const SizedBox();
                                },
                              )
                            ),
                      
                            Consumer<PPOBProvider>(
                              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator()
                                  );
                                }
                                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.error) {
                                  return const SizedBox(
                                    height: 150.0,
                                    child: Center(
                                      child: Text('Data tidak ditemukan',
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ),
                                  );
                                }
                                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.error) {
                                  return const SizedBox(
                                    height: 150.0,
                                    child: Center(
                                      child: Text('Ada yang bermasalah',
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ),
                                  );
                                }
                                return Container(
                                  margin: const EdgeInsets.only(top: 50.0),
                                  child: AlignedGridView.count(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    shrinkWrap: true,
                                    itemCount: ppobProvider.listPricePLNPrabayarData.length,
                                    crossAxisSpacing: 20.0,
                                    mainAxisSpacing: 40.0,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                        
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                                              
                                              Container(
                                                height: 90.0,
                                                decoration: BoxDecoration(
                                                  color: selected == i 
                                                  ? ColorResources.primary 
                                                  : const Color(0xffF1F1F1),
                                                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                  boxShadow: boxShadow
                                                ),
                                                width: 150.0,
                                                child: Material(
                                                  color: selected == i 
                                                  ? ColorResources.primary 
                                                  : const Color(0xffF1F1F1),
                                                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                  child: InkWell(
                                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                    onTap: () {
                                                      setState(() {
                                                        selected = i;
                                                        productPrice = ppobProvider.listPricePLNPrabayarData[i].productPrice!;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                        top: 30.0,
                                                        bottom: 10.0
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                Helper.formatCurrency(
                                                                  double.parse((ppobProvider.listPricePLNPrabayarData[i].productPrice! + 2000).toString())
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
                                                                  double.parse((ppobProvider.listPricePLNPrabayarData[i].productPrice! + 2000).toString())
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
                                                              
                                              Positioned(
                                                top: -25.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Image.asset("assets/images/icons/ic-coin.png",
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.scaleDown,
                                                )
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                    
                        ])
                      ),
                    )

                  ],
                ),

                selectedChannelPln == 0 
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        onTap: selected == -1 
                        ? () {} 
                        : () async {
                          if(plnPraC.text.trim() != "") {
                            await context.read<PPOBProvider>().postInquiryPLNPrabayarStatus(
                              context, 
                              idPel: maskFormatter.getUnmaskedText(),
                              price: productPrice.toString(),
                              index: selected,
                            );
                          } else {
                            ShowSnackbar.snackbar('Isi ID Customer terlebih dahulu!', '', ColorResources.error);
                          }
                        },
                        isBorderRadius: true,
                        isBorder: false,
                        isBoxShadow: false,
                        btnColor: selected == -1 
                        ? Colors.grey
                        : ColorResources.primary,
                        btnTxt: "Selanjutnya",
                      ),
                    )
                  ) 
                : Align(
                  child: Container()
                )

              ],
            );
          },
        )
      )
    );
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}