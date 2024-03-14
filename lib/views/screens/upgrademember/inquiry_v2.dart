import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/providers/upgrade_member/upgrade_member.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';
import 'package:hp3ki/views/screens/upgrademember/select_payment_method.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

class UpgradeMemberInquiryV2Screen extends StatefulWidget {
  const UpgradeMemberInquiryV2Screen({super.key});

  @override
  State<UpgradeMemberInquiryV2Screen> createState() =>
      _UpgradeMemberInquiryV2ScreenState();
}

class _UpgradeMemberInquiryV2ScreenState
    extends State<UpgradeMemberInquiryV2Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Scaffold buildUI() {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            buildAppBar(),
            buildItems(),
          ],
        ),
        buildNavbar(),
      ]),
    );
  }

  SliverAppBar buildAppBar() {
    return const CustomAppBar(title: 'Pembayaran').buildSliverAppBar(context);
  }

  SliverToBoxAdapter buildItems() {
    return SliverToBoxAdapter(
      child: Consumer<UpgradeMemberProvider>(builder: (BuildContext context,
          UpgradeMemberProvider upgradeMemberProvider, Widget? child) {
        PaymentListData? data = upgradeMemberProvider.selectedPaymentChannel;
        final double adminFee = data?.totalAdminFee?.toDouble() ?? 0;
        const double basePrice = 100000;
        return Wrap(children: [
          InkWell(
            onTap: () {
              NS.push(context, const UpgradeMemberV2IndexScreen());
            },
            child: Container(
              width: double.infinity,
              color: ColorResources.white,
              padding:
                  const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              child: Text(
                'Metode Pembayaran',
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (data != null)
            ListTile(
              onTap: () {
                NS.push(context, const UpgradeMemberV2IndexScreen());
              },
              tileColor: ColorResources.white,
              leading: CircleAvatar(
                backgroundColor: ColorResources.transparent,
                maxRadius: 40.0,
                child: SizedBox.expand(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: data.paymentLogo ?? "",
                      placeholder: (context, url) {
                        return const CircleAvatar(
                          backgroundColor: ColorResources.backgroundDisabled,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const CircleAvatar(
                            backgroundColor: ColorResources.transparent,
                            backgroundImage:
                                AssetImage("assets/images/icons/ic-empty.png"));
                      },
                    ),
                  ),
                ),
              ),
              title: Text(
                data.paymentName ?? "...",
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "Biaya admin: " +
                    Helper.formatCurrency(data.totalAdminFee?.toDouble() ?? 0),
                style: poppinsRegular,
              ),
            )
          else
            ListTile(
              tileColor: ColorResources.white,
              onTap: () {
                NS.push(context, const UpgradeMemberV2IndexScreen());
              },
              title: const Text('Pilih metode pembayaran'),
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
                        'Ringkasan Harga',
                        style: robotoRegular.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                    const InfoTile(
                      label: 'Biaya Upgrade Member',
                      price: basePrice,
                    ),
                    InfoTile(
                      label: 'Biaya Admin',
                      price: adminFee,
                    ),
                    InfoTile(
                      label: 'Total Harga',
                      price: basePrice + adminFee,
                    ),
                  ],
                ),
              ],
            ),
          )
        ]);
      }),
    );
  }

  Widget buildNavbar() {
    return Consumer<UpgradeMemberProvider>(builder: (context, provider, child) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: ColorResources.white,
          padding: const EdgeInsets.all(10.0),
          child: CustomButton(
            onTap: () {
              PaymentListData? data = provider.selectedPaymentChannel;
              if (data == null) {
                CustomDialog.showErrorCustom(context,
                    title: '', message: "Harap pilih metode pembayaran");
                return;
              }
              buildAskDialog(context);
            },
            isLoading: context.watch<UpgradeMemberProvider>().inquiryStatus ==
                    InquiryStatus.loading
                ? true
                : false,
            btnColor: ColorResources.secondary,
            customText: true,
            isBorderRadius: true,
            text: Text(
              'Bayar',
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: ColorResources.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
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
        context.read<UpgradeMemberProvider>().sendPaymentInquiry(
              context,
              userId: SharedPrefs.getUserId(),
              paymentCode: context
                  .read<UpgradeMemberProvider>()
                  .selectedPaymentChannel!
                  .paymentCode!,
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

  final double price;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: VisualDensity.compact,
      leading: Text(
        label,
        style: robotoRegular.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      title: Text(
        Helper.formatCurrency(price),
        style: robotoRegular,
        textAlign: TextAlign.end,
      ),
    );
  }
}
