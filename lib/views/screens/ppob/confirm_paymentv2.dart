import 'package:flutter/material.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class ConfirmPaymentV2 extends StatefulWidget {
  final String idPelPLN;
  final String refTwoPLN;
  final String productCodePulsa;
  final String productId;
  final String description;
  final double price;
  final double adminFee;
  final String provider;
  final String accountNumber;
  final String productName;
  final String type;

  const ConfirmPaymentV2({ 
    Key? key,
    this.productId = "...",
    this.description = "...",
    this.price = 0,
    this.adminFee = 0,
    this.provider = "...",
    this.accountNumber = "...",
    this.productName = "...",
    this.type = "", 
    this.idPelPLN = "...",
    this.refTwoPLN = "...",
    this.productCodePulsa = "...",
  }) : super(key: key);

  @override
  State<ConfirmPaymentV2> createState() => ConfirmPaymentV2State();
}

class ConfirmPaymentV2State extends State<ConfirmPaymentV2> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  Future<void> getData() async {
    if(mounted) {
      context.read<PPOBProvider>().getVA(context);
    }
    if(mounted) {
      context.read<PPOBProvider>().resetPaymentMethod();
    }
  }
  
  @override 
  void initState() {
    super.initState();

    Future.wait([getData()]);
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.greyLightPrimary,
      body: SafeArea(
        child: Consumer<PPOBProvider>(
          builder: (context, ppobProvider, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [

                RefreshIndicator(
                  backgroundColor: ColorResources.primary,
                  color: ColorResources.white,
                  onRefresh: () {
                    return Future.sync(() {
                      ppobProvider.getVA(context);
                    });
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                
                      CustomAppBar(title: getTranslated("PAYMENT", context)).buildSliverAppBar(context),

                      SliverList(
                        delegate: SliverChildListDelegate([

                          Container(
                            margin: const EdgeInsets.only(
                              top: Dimensions.marginSizeDefault,
                              left: Dimensions.marginSizeDefault
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(getTranslated("METHOD_PAYMENT", context),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(
                              top: Dimensions.marginSizeDefault,
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Expanded(
                                  child: ppobProvider.selectedPaymentMethodData == null
                                  ? Text(getTranslated("NO_PAYMENT_METHOD", context),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.hintColor
                                      ),
                                    )
                                  : Text(ppobProvider.selectedPaymentMethod,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.hintColor
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: CustomButton(
                                    isBorder: false,
                                    isBorderRadius: true,
                                    isBoxShadow: false,
                                    btnColor: const Color(0xFFEBEEEF),
                                    btnTextColor: ColorResources.primary,
                                    onTap: () {
                                      buildPaymentMethodModal(context, ppobProvider);
                                    }, 
                                    btnTxt: getTranslated("CHANGE", context)
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(
                              top: Dimensions.marginSizeDefault,
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(getTranslated("BILLING_INFORMATION", context),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: ColorResources.black
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    RowItem(label: 'Nama Produk',text: widget.productName),
                                    const SizedBox(height: 4.0),
                                    RowItem(label: 'Keterangan', text: widget.description),
                                    const SizedBox(height: 4.0),
                                    RowItem(
                                      label: widget.type.contains('prabayar')
                                          ? "ID Pelanggan"
                                          : 'Nomor Telepon',
                                      text: widget.type.contains('prabayar')
                                          ? widget.idPelPLN
                                          : widget.accountNumber,
                                    ),
                                    const SizedBox(height: 4.0),
                                    RowItem(
                                      label: getTranslated("METHOD_PAYMENT", context),
                                      text: ppobProvider.selectedPaymentMethodData?.name ?? "Belum dipilih",
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text('Rincian Pesanan',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: ColorResources.black
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    RowItem(label: 'Harga Pesanan', text: Helper.formatCurrency(int.parse(widget.price.toString()))),
                                    RowItem(label: 'Biaya Admin', text: Helper.formatCurrency(int.parse(widget.adminFee.toString()))),
                                    RowItem(label: 'Total Pembayaran', text: Helper.formatCurrency(int.parse((widget.price + widget.adminFee).toString()))),
                                  ],
                                ),
                              ],
                            ),
                          )

                        ])
                      )
                
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: Dimensions.marginSizeDefault,
                      right: Dimensions.marginSizeDefault,
                      bottom: Dimensions.marginSizeSmall
                    ),
                    child: CustomButton(
                      btnColor: ColorResources.primary,
                      isBorder: false,
                      isBorderRadius: true,
                      isBoxShadow: false,
                      isLoading: ppobProvider.payStatus == PayStatus.loading 
                      ? true 
                      : false,
                      onTap: () async {
                        if(ppobProvider.selectedPaymentMethod.trim() == "-" || ppobProvider.selectedPaymentMethod.contains('Belum')) {
                          ShowSnackbar.snackbar(getTranslated("PAYMENT_ACCOUNT_IS_REQUIRED", context), "", ColorResources.error);
                          return;
                        } else {
                          buildAskDialog(context, ppobProvider);
                        }
                      }, 
                      btnTxt: getTranslated("CONTINUE", context)
                    ),
                  ),
                ),

              ],
            );
          },
        )
      ),
    );
  }

  Future<dynamic> buildPaymentMethodModal(BuildContext context, PPOBProvider ppobProvider) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)
        )
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NS.pop();
                      },
                      child: const Icon(Icons.close)
                    )
                  ],
                ),
              ),

              const Divider(
                height: 1.0,
                color: ColorResources.grey,
              ),
        
              widget.type == "pulsa" || widget.type == "emoney" || widget.type == "pln-prabayar" || widget.type == "pln-pascabayar"
              ? Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.sizeOf(context).height * 0.15,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: CheckboxListTile(
                    value: ppobProvider.isSelected,
                    onChanged: (value) {
                      ppobProvider.setPaymentMethod(
                        id: widget.productId,
                        name: "Saldo",
                        channel: "wallet",
                      );
                      NS.pop();
                    },
                    title: Text('Saldo',
                      style: robotoRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorResources.black
                      ),
                    ),
                    subtitle: Text( ppobProvider.balanceStatus == BalanceStatus.loading 
                      ? "..."
                      : ppobProvider.balanceStatus == BalanceStatus.error 
                      ?  "..."
                      : Helper.formatCurrency(int.parse(ppobProvider.balance.toString())),
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        ),
                      ),
                    ),
                ) 
              : Consumer<PPOBProvider>(
                  builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                  if(ppobProvider.vaStatus == VaStatus.loading) {
                    return Container();
                  }
                  if(ppobProvider.vaStatus == VaStatus.empty) {
                    return Container();
                  }
                  return Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ppobProvider.listVa.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: Dimensions.marginSizeSmall
                          ),
                          child: Card(
                            color: ppobProvider.selectedPaymentMethodData != null
                            ? ppobProvider.selectedPaymentMethodData?.channel == ppobProvider.listVa[i].channel 
                            ? ColorResources.primary.withOpacity(0.5)
                            : ColorResources.white : (ppobProvider.selectedPaymentMethod == ppobProvider.listVa[i].channel 
                            ? ColorResources.primary.withOpacity(0.5)
                            : ColorResources.white),
                            elevation: 3.0,
                            child: Material(
                              color: ColorResources.transparent,
                              child: InkWell(
                                onTap: () async {
                                  ppobProvider.setPaymentMethod(
                                    id: ppobProvider.listVa[i].classId!,
                                    name: ppobProvider.listVa[i].name!,
                                    channel: ppobProvider.listVa[i].channel!,
                                  );
                                  NS.pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 20,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: ppobProvider.listVa[i].paymentLogo!,
                                                  height: ppobProvider.listVa[i].name! == "Linkaja" 
                                                  ? 40.0 
                                                  : 50.0,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                              child: Text(ppobProvider.listVa[i].name!,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  fontWeight: FontWeight.w600,
                                                  color: ppobProvider.selectedPaymentMethodData != null 
                                                  ? (ppobProvider.selectedPaymentMethodData?.channel == ppobProvider.listVa[i].channel 
                                                  ? ColorResources.white
                                                  : ColorResources.black) 
                                                  : (ppobProvider.selectedPaymentMethod == ppobProvider.listVa[i].channel 
                                                  ? ColorResources.white
                                                  : ColorResources.black)
                                                ),
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: ppobProvider.selectedPaymentMethodData != null
                                        ? (ppobProvider.selectedPaymentMethodData?.channel == ppobProvider.listVa[i].channel
                                            ? const Icon(
                                                Icons.radio_button_checked,
                                                color: ColorResources.white,
                                              )
                                            : const Icon(Icons.radio_button_off)
                                          )
                                        : (ppobProvider.selectedPaymentMethod == ppobProvider.listVa[i].channel
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: ColorResources.white,
                                            )
                                          : const Icon(Icons.radio_button_off)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
        
            ],
          ),
        );
      }
    );
  }

  AwesomeDialog buildAskDialog(BuildContext context, PPOBProvider ppobProvider) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Apakah anda sudah yakin ingin melakukan transaksi ini?",
          style: robotoRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeLarge,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkText: "Yakin",
      btnOkColor: ColorResources.secondary,
      btnOkOnPress: () async {
          final double totalPrice = widget.price + widget.adminFee;
          if(ppobProvider.selectedPaymentMethod.trim() == "-") {
            ShowSnackbar.snackbar(getTranslated("PAYMENT_ACCOUNT_IS_REQUIRED", context), "", ColorResources.error);
            return;
          }
          switch (widget.type) {
            case "pulsa":
              await ppobProvider.purchasePulsa(
                context, 
                phone: widget.accountNumber,
                productCode: widget.productCodePulsa,
              );
            break;
            case "pln-prabayar":
              await ppobProvider.payPLNPrabayar(
                context,
                idPel: widget.idPelPLN,
                nominal: totalPrice.toString(),
                refTwo: widget.refTwoPLN,
              );
            break;  
            case "pln-pascabayar":
              final getTransactionId = ppobProvider.inquiryPLNPascaBayarData!.transactionId;
              await ppobProvider.payPLNPascabayar(context, widget.accountNumber, getTransactionId!);
            break;
            case "topup":
              await ppobProvider.inquiryTopUp(
                context,
                widget.productId,
                ppobProvider.selectedPaymentMethodData!.channel!,
              );
            break;
          default:
        }
      },
      btnCancelText: "Tidak",
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
    )..show();
  }

}
class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.label,
    required this.text,
  });

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(label,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.hintColor
          ),
        ),
        Text(text,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black
          ),
        )
      ],
    );
  }
}