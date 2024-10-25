import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_list.dart';
import 'package:hp3ki/providers/upgrade_member/upgrade_member.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class UpgradeMemberV2IndexScreen extends StatefulWidget {
  const UpgradeMemberV2IndexScreen({super.key});

  @override
  _UpgradeMemberV2IndexScreenState createState() =>
      _UpgradeMemberV2IndexScreenState();
}

class _UpgradeMemberV2IndexScreenState
    extends State<UpgradeMemberV2IndexScreen> {
  Future<void> getData() async {
    if (mounted) {
      await context.read<UpgradeMemberProvider>().getPaymentChannel(context);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() => getData());
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
      backgroundColor: ColorResources.white,
      appBar: buildAppBar(),
      body: getCart(),
    );
  }

  AppBar buildAppBar() {
    return const CustomAppBar(
      title: 'Pilih Metode Pembayaran',
    ).buildAppBar(context);
  }

  Widget getCart() {
    return Consumer<UpgradeMemberProvider>(builder: (BuildContext context,
        UpgradeMemberProvider upgradeMemberProvider, Widget? child) {
      if (upgradeMemberProvider.paymentChannelStatus ==
          PaymentChannelStatus.loading) {
        return Center(child: loadingList());
      } else if (upgradeMemberProvider.paymentChannelStatus ==
          PaymentChannelStatus.empty) {
        return const Center(
          child: Text('Metode Pembayaran Kosong.'),
        );
      } else if (upgradeMemberProvider.paymentChannelStatus ==
          PaymentChannelStatus.error) {
        return const Center(
          child: Text('Ada yang bermasalah.'),
        );
      } else {
        return RefreshIndicator(
          backgroundColor: ColorResources.primary,
          color: ColorResources.white,
          onRefresh: () async {
            upgradeMemberProvider.getPaymentChannel(context);
          },
          child: SizedBox(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: upgradeMemberProvider.paymentChannel!.length,
              itemBuilder: (BuildContext context, int i) {
                PaymentListData data = upgradeMemberProvider.paymentChannel![i];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                boxShadow: kElevationToShadow[4],
                                color: ColorResources.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ListTile(
                              onTap: () {
                                upgradeMemberProvider
                                    .setSelectedPaymentChannel(data);
                                NS.pop();
                              },
                              leading: CircleAvatar(
                                backgroundColor: ColorResources.transparent,
                                maxRadius: 40.0,
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      imageUrl: data.paymentLogo!,
                                      placeholder: (context, url) {
                                        return const CircleAvatar(
                                          backgroundColor:
                                              ColorResources.backgroundDisabled,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return const CircleAvatar(
                                            backgroundColor:
                                                ColorResources.transparent,
                                            backgroundImage: AssetImage(
                                                "assets/images/icons/ic-empty.png"));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                data.paymentName ?? "...",
                                style: poppinsRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                data.paymentDescription ?? "...",
                                style: poppinsRegular,
                              ),
                            ))
                      ]),
                );
              },
            ),
          ),
        );
      }
    });
  }
}

Widget loadingList() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      padding: const EdgeInsets.all(25.0),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: ColorResources.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: ColorResources.white),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    ),
  );
}
