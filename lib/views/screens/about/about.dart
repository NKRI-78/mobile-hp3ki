import 'package:flutter/material.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class AboutScreen extends StatefulWidget {
  final int screenIndex;

  const AboutScreen({Key? key, required this.screenIndex}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: buildBackgroundImage(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            buildAppBar(),
            buildBodyContent(),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
      backgroundBlendMode: BlendMode.darken,
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorResources.black, Color(0xff0B1741)]),
      image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background/bg.png')),
    );
  }

  Widget buildAppBar() {
    return SliverAppBar(
      backgroundColor: ColorResources.transparent,
      centerTitle: true,
      toolbarHeight: 50.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        child: IconButton(
            onPressed: () {
              NS.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: Dimensions.iconSizeExtraLarge,
            )),
      ),
    );
  }

  Widget buildBodyContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(
          children: [
            if (widget.screenIndex == 1) buildSeputarHP3KI(),
            if (widget.screenIndex == 2) buildVisiMisi(),
          ],
        ),
      ),
    );
  }

  Widget buildSeputarHP3KI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo/logo-aspro.png',
          fit: BoxFit.cover,
          height: 200.0,
          width: 200.0,
        ),
        const SizedBox(
          height: 15,
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: ColorResources.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Tentang Asosiasi Profesi Indonesia',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '"Bersama Membangun Profesionalisme dan Kemandirian Bangsa"',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Perkumpulan Asosiasi Profesi Indonesia merupakan sebuah wadah strategis yang menaungi berbagai Organisasi Profesi dan Asosiasi Profesi di Indonesia. Dideklarasikan pada tahun 2017, Aspro hadir dengan tujuan untuk memperkuat koordinasi, sinkronisasi, dan harmonisasi antarorganisasi profesi dalam mendukung pengembangan Sumber Daya Manusia (SDM) yang unggul dan berdaya saing.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Dalam perjalanannya, Aspro telah dipimpin oleh sejumlah tokoh yang memiliki komitmen tinggi terhadap visi organisasi. Periode pertama (2017–2020) dipimpin oleh Jonny Maukar, dilanjutkan oleh Arpinus Koto pada periode kedua (2020–2024), dan kini memasuki periode ketiga di bawah kepemimpinan Ali Badarudin.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Aspro berperan penting sebagai platform untuk menyatukan aspirasi anggotanya dalam menyikapi isu-isu strategis, seperti rancangan regulasi, pelaksanaan program pendidikan, pelatihan, dan sertifikasi yang berdampak pada masa depan profesi dan keahlian tertentu. Selain itu, Aspro juga berfungsi sebagai fasilitator yang menjembatani penyelesaian konflik internal organisasi, jika diminta oleh anggotanya.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Melalui sinergi dan kolaborasi yang berkesinambungan, Aspro terus berkomitmen untuk menjadi mitra strategis dalam mewujudkan SDM Indonesia yang kompeten, berdaya saing, dan siap menghadapi tantangan global.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildVisiMisi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo/logo-aspro.png',
          fit: BoxFit.cover,
          height: 200.0,
          width: 200.0,
        ),
        const SizedBox(
          height: 15,
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: ColorResources.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  ' Bersama Membangun Profesionalisme dan Kemandirian Bangsa ',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
