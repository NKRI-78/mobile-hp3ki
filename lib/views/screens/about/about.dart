import 'package:flutter/material.dart';


import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class AboutScreen extends StatefulWidget {
  final int screenIndex;

  const AboutScreen({ Key? key, required this.screenIndex }) : super(key: key);

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
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
        colors: [
          ColorResources.black,
          Color(0xff0B1741)
        ]
      ),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/background/bg.png')
      ),
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
            NS.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: Dimensions.iconSizeExtraLarge,
          )
        ),
      ),
    );
  }

  Widget buildBodyContent(){
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(
          children: [
            if (widget.screenIndex == 1)
              buildSeputarHP3KI(),
            if (widget.screenIndex == 2)
              buildVisiMisi(),
          ],
        ),
      ),
    );
  }

  Widget buildSeputarHP3KI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo/logo.png',
          fit: BoxFit.cover,
          height: 200.0,
          width: 200.0,
        ),
        const SizedBox(height: 15,),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: ColorResources.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Himpunan Pimpinan Pendidik Pelatihan dan Kewirausahaan Indonesia (HP3KI)',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20,),
                Text('Organisasi HP3KI merupakan organisasi yang bertujuan membantu pemerintah dalam mengentas kemiskinan dan menekan pengangguran melalui berbagai pelatihan kewirausahaan sehingga terciptanya tenaga kerja ahli yang berintegrasi dan profesional.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12,),
                Text('HP3KI bergerak untuk mengembangkan kewirausahaan dan usaha kecil dan menengah sehingga memiliki ketrampilan agar bisa menjadi kewirausahaan yang mandiri.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12,),
                Text(' Organisasi HP3KI adalah satu-satunya wadah tempat berhimpun Pimpinan dan Pendidik di Lembaga-lembaga Pelatihan dan Kewirausahaan di Indonesia yang bersifat nasional. ',
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
        Image.asset('assets/images/logo/logo.png',
          fit: BoxFit.cover,
          height: 200.0,
          width: 200.0,
        ),
        const SizedBox(height: 15,),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: ColorResources.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(' Visi dan Misi HP3KI ',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(' HPK3I memiliki Visi dan Misi yang dapat membantu memecahkan masalah pengangguran di Indonesia ',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15,),
                Text('Visi',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10,),
                Text('Memperluas akses dan pemerataan untuk kemajuan pelatihan dan kewirausahaan.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20,),
                Text('Misi',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10,),
                Text('1. Memperluas akses dan pemerataan untuk kemajuan pelatihan dan kewirausahaan.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5,),
                Text('2. Meningkatkan daya saing pelatihan dan Kewirausahaan dalam rangka memberikan kemampuan untuk dunia usaha dan dunia industri.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5,),
                Text('3. Meningkatkan kualifikasi dan kompetensi pelatihan dan Kewirausahaan yang relevan untuk kebutuhan masyarakat.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5,),
                Text('4. Mewujudkan lembaga pelatihan dan Kewirausahaan dalam peningkatan mutu dan keahlian.',
                  textAlign: TextAlign.justify,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5,),
                Text('5. Mewujudkan perlidungan, kesejahteraan dan penghargaan bagi anggota HP3KI',
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
}