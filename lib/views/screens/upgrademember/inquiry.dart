import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/data/models/payment_channel/payment_channel.dart';
import 'package:hp3ki/data/models/package_account/package_account_model.dart';

import 'package:hp3ki/providers/upgrade_member/upgrade_member.dart';

import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';

import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/utils/dimensions.dart';

class UpgradeMemberInquiryScreen extends StatefulWidget {
  const UpgradeMemberInquiryScreen({super.key});

  @override
  State<UpgradeMemberInquiryScreen> createState() => UpgradeMemberInquiryScreenState();
}

class UpgradeMemberInquiryScreenState extends State<UpgradeMemberInquiryScreen> {
  
  @override
  void initState() {
    super.initState();

    Future.microtask(() => init());
  }

  List<PackageAccount> packages = [];

  PackageAccount? package;

  Future<void> init() async {
    try {
      Dio dio = DioManager().getClient();
      final res = await dio.get('${AppConstants.baseUrl}/api/v1/pricelist/pricing-account');
      packages = (res.data['data'] as List).map((e) => PackageAccount.fromJson(e)).toList();

      if (packages.isNotEmpty) {
        package = packages[0];
      }

      setState(() {});
    } on DioError catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: packages.isEmpty 
      ? const SizedBox() 
      : Stack(
        children: [

          CustomScrollView(
            slivers: [
              buildAppBar(),
              buildItems(),
            ],
          ),

          buildNavbar(),
      
        ]
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return const CustomAppBar(title: 'Pembayaran').buildSliverAppBar(context);
  }

  SliverToBoxAdapter buildItems() {
    return SliverToBoxAdapter(
      child: Consumer<UpgradeMemberProvider>(
        builder: (BuildContext context, UpgradeMemberProvider upgradeMemberProvider, Widget? child) {
        
        PaymentChannelData data = upgradeMemberProvider.selectedPaymentChannel!;
        int adminFee = data.fee ?? 0;

        return Wrap(
          children: [
            Container(
              width: double.infinity,
              color: ColorResources.white,
              padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              child: Text('Metode Pembayaran',
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              tileColor: ColorResources.white,
              leading: CircleAvatar(
                backgroundColor: ColorResources.transparent,
                maxRadius: 40.0,
                child: SizedBox.expand(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: data.logo.toString(),
                      placeholder: (context, url) {
                        return const CircleAvatar(
                          backgroundColor: ColorResources.backgroundDisabled,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const CircleAvatar(
                          backgroundColor: ColorResources.transparent,
                          backgroundImage: AssetImage("assets/images/icons/ic-empty.png")
                        );
                      },
                    ),
                  ),
                ),
              ),
              title: Text(
                data.name,
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Biaya admin: " + Helper.formatCurrency(adminFee),
                style: poppinsRegular,
              ),
            ),
            Container(
              color: ColorResources.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    color: const Color(0xffD9D9D9),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pilihan Paket',
                          style: robotoRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeLarge),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ...List.generate(
                        packages.length,
                        (index) {
                          final p = packages[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                package = p;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  Radio<PackageAccount>.adaptive(
                                      value: p,
                                      groupValue: package,
                                      onChanged: (pack) {
                                        setState(() {
                                          package = pack;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      style: robotoRegular.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimensions.fontSizeLarge),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: ColorResources.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    color: const Color(0xffD9D9D9),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Ringkasan Harga',
                          style: robotoRegular.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeLarge
                          ),
                        ),
                      ),
                      InfoTile(
                        label: 'Biaya Upgrade Member',
                        price: package!.price,
                      ),
                      InfoTile(
                        label: 'Biaya Admin',
                        price: adminFee,
                      ),
                      InfoTile(
                        label: 'Total Harga',
                        price: (package!.price + adminFee),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]
        );
      }),
    );
  }

  Widget buildNavbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: ColorResources.white,
        padding: const EdgeInsets.all(10.0),
        child: CustomButton(
          onTap: () async {
            if (package == null) {
              CustomDialog.showErrorCustom(
                context, 
                title: "", 
                message: "Harap pilih paket terlebih dahulu"
              );
              return;
            }
            buildAskDialog(context);
          },
          isLoading: context.watch<UpgradeMemberProvider>().inquiryStatus == InquiryStatus.loading ? true : false,
          btnColor: ColorResources.secondary,
          customText: true,
          isBorderRadius: true,
          text: Text('Bayar',
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  AwesomeDialog buildAskDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "Apakah anda sudah yakin ingin melakukan transaksi ini?",
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
        await context.read<UpgradeMemberProvider>().sendPaymentInquiryV2(context,
          userId: SharedPrefs.getUserId(),
          paymentCode: context.read<UpgradeMemberProvider>().selectedPaymentChannel!.nameCode,
          channelId: context.read<UpgradeMemberProvider>().selectedPaymentChannel!.id.toString(),
          package: package!
        );
      },
      btnCancelText: "Tidak",
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
    )..show();
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.price,
    required this.label,
  });

  final int? price;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: VisualDensity.compact,
      leading: Text(
        label,
        style: robotoRegular.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Text(
        Helper.formatCurrency(price ?? 0),
        style: robotoRegular,
        textAlign: TextAlign.end,
      ),
    );
  }
}
