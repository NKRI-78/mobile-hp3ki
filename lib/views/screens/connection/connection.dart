import 'package:flutter/material.dart';


import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';


//FIXME: implement ke semua page
class NoConnectionScreen extends StatefulWidget {
  
  const NoConnectionScreen({ 
    Key? key }) 
    : super(key: key);

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {

  @override 
  void initState() {
    super.initState();
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
      backgroundColor: ColorResources.greyLightPrimary,
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          buildNoConnectionSection(),
        ],
      )
    );
  }

  Widget buildNoConnectionSection() {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/avatar/avatar-network.png",
              height: 300,
              width: 300,
              fit: BoxFit.fitWidth,
            ),
            Text('Koneksi Bermasalah',
              style: poppinsRegular.copyWith(
                color: ColorResources.black,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5,),
            Text('Maaf terjadi kesalahan pada jaringan anda, pastikan anda terhubung pada internet.',
              style: poppinsRegular.copyWith(
                color: ColorResources.black.withOpacity(0.6),
                fontSize: Dimensions.fontSizeDefault,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}