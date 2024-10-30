import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/button/custom.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';
import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/views/screens/ecommerce/store/create_update_store.dart';
import 'package:hp3ki/views/screens/ecommerce/store/seller/products.dart';

class StoreInfoScreen extends StatefulWidget {
  final String storeId;
  const StoreInfoScreen({
    required this.storeId,
    super.key
  });

  @override
  State<StoreInfoScreen> createState() => StoreInfoScreenState();
}

class StoreInfoScreenState extends State<StoreInfoScreen> {
  
  late EcommerceProvider ecommerceProvider;

  Future<void> getData() async {
    if(!mounted) return;
      await ecommerceProvider.getStore();

    if(!mounted) return;
      await ecommerceProvider.fetchAllProductSeller(search: "", storeId: widget.storeId);
  }

  @override
  void initState() {
    super.initState();

    ecommerceProvider = context.read<EcommerceProvider>();

    Future.microtask(() => getData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.sync(() {
            getData();
          });
        },
        child: Consumer<EcommerceProvider>(
          builder: (__, notifier, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [

                if(notifier.getStoreStatus == GetStoreStatus.loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: CircularProgressIndicator.adaptive()
                      )
                    )
                  ),

                if(notifier.getStoreStatus == GetStoreStatus.error)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text("Hmm... Mohon tunggu yaa",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      )
                    )
                  ),
                  
                if(notifier.getStoreStatus == GetStoreStatus.loaded)
                  SliverAppBar(
                    title: Text("Info Toko",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.black
                      ),
                    ),
                    toolbarHeight: 120.0,
                    centerTitle: true,
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        NS.pop();
                      },
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 12.0
                        ),
                        child: IconButton(
                          splashRadius: 20.0,
                          onPressed: () {
                            NS.push(context, const CreateStoreOrUpdateScreen());
                          },
                          icon: const Icon(Icons.edit)
                        )
                      )
                    ],
                    bottom: PreferredSize(
                     preferredSize: const Size.fromHeight(80.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ColorResources.purple,
                        ),
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                                    
                            Expanded(
                              flex: 6,
                              child: CachedNetworkImage(
                                imageUrl: notifier.store!.data?.logo ?? "-",
                                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                  return CircleAvatar(
                                    maxRadius: 30.0,
                                    backgroundImage: imageProvider,
                                  );
                                },
                                errorWidget: (BuildContext context, String url, Object error) {
                                  return const CircleAvatar(
                                    maxRadius: 30.0,
                                    backgroundImage: AssetImage('assets/images/default_image.png'),
                                  );
                                },
                                placeholder: (BuildContext context, String url) {
                                  return const CircleAvatar(
                                    maxRadius: 30.0,
                                    backgroundImage: AssetImage('assets/images/default_image.png'),
                                  );
                                },
                              ),
                            ),

                            const Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),

                            Expanded(
                              flex: 28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                              
                                  SelectableText(notifier.store!.data?.name ?? "-",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.white
                                    ),
                                  ),

                                  const SizedBox(height: 8.0),

                                  SelectableText(notifier.store!.data?.address ?? "-",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.white
                                    ),
                                  ),

                                  const SizedBox(height: 8.0),

                                  SelectableText(notifier.store!.data?.phone ?? "-",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.white
                                    ),
                                  ),

                                  const SizedBox(height: 8.0),

                                   SelectableText(notifier.store!.data?.email ?? "-",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.white
                                    ),
                                  ),
                                      
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
            
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                      const Divider(
                        height: 1.0,
                        color: ColorResources.black,
                      ),
                              
                      ListTile(
                        dense: true,
                        title: Text("Daftar Produk",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),
                        leading: const Icon(Icons.list),
                        onTap: () {
                          NS.push(context, ProductsSellerScreen(storeId: notifier.store!.data?.id ?? "-"));
                        },
                      ),

                      const Divider(
                        height: 1.0,
                        color: ColorResources.black,
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          
                          Expanded(
                            flex: 14,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0
                              ),
                              child: CheckboxListTile(
                                value: notifier.selectedAllProduct,
                                onChanged: (bool? val) {
                                  notifier.onSelectedAllProduct(val!);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text("Pilih semua",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black
                                  ),
                                ),
                              ),
                            ),
                          ),

                          notifier.productSellers.isEmpty 
                          ? const Flexible(
                              flex: 2,
                              child: SizedBox()
                            ) 
                          : Flexible(
                              flex: 2,
                              child: SizedBox(
                              width: 28.0,
                              height: 28.0,
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: notifier.selectedAllProduct 
                                  ? ColorResources.error 
                                  : ColorResources.grey,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0)
                                  )
                                ),
                                child: GestureDetector(
                                  onTap: notifier.selectedAllProduct 
                                  ? () async {
                                      showGeneralDialog(
                                        context: context,
                                        barrierLabel: "Barrier",
                                        barrierDismissible: true,
                                        barrierColor: Colors.black.withOpacity(0.5),
                                        transitionDuration: const Duration(milliseconds: 700),
                                        pageBuilder: (BuildContext context, Animation<double> double, _) {
                                          return Center(
                                            child: Material(
                                              color: ColorResources.transparent,
                                              child: Container(
                                                margin: const EdgeInsets.all(20.0),
                                                height: 250.0,
                                                decoration: BoxDecoration(
                                                  color: ColorResources.purple, 
                                                  borderRadius: BorderRadius.circular(20.0)
                                                ),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                                                    
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text("Apakah kamu yakin ingin hapus Produk ?",
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.bold,
                                                          color: ColorResources.white
                                                        ),
                                                      )
                                                    ),
                                                                                    
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              top: 20.0,
                                                              bottom: 20.0
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Expanded(child: SizedBox()),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: CustomButton(
                                                                    isBorderRadius: true,
                                                                    isBoxShadow: false,
                                                                    btnColor: ColorResources.white,
                                                                    btnTextColor: ColorResources.black,
                                                                    onTap: () {
                                                                      NS.pop();
                                                                    }, 
                                                                    btnTxt: "Batal"
                                                                  ),
                                                                ),
                                                                const Expanded(child: SizedBox()),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Consumer<EcommerceProvider>(
                                                                    builder: (_, notifier, __) {
                                                                      return CustomButton(
                                                                        isBorderRadius: true,
                                                                        isBoxShadow: false,
                                                                        isLoading: notifier.deleteProductStatus == DeleteProductStatus.loading 
                                                                        ? true 
                                                                        : false,
                                                                        btnColor: ColorResources.error,
                                                                        btnTextColor: ColorResources.white,
                                                                        onTap: () async {
                                                                          await notifier.deleteProductSelect();
                                                                          NS.pop();
                                                                        }, 
                                                                        btnTxt: "OK"
                                                                      );
                                                                    },
                                                                  )
                                                                ),
                                                                const Expanded(child: SizedBox()),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ) 
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          );
                                        },
                                        transitionBuilder: (_, anim, __, child) {
                                          Tween<Offset> tween;
                                          if (anim.status == AnimationStatus.reverse) {
                                            tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                                          } else {
                                            tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                                          }
                                          return SlideTransition(
                                            position: tween.animate(anim),
                                            child: FadeTransition(
                                              opacity: anim,
                                              child: child,
                                            ),
                                          );
                                        },
                                      );
                                    } 
                                  : () {},
                                  child: const Icon(
                                    Icons.delete,
                                    size: 15.0,
                                    color: ColorResources.white,
                                  ),
                                )
                              )
                            ),
                          )

                        ],
                      ),

                      if(notifier.listProductStatus == ListProductStatus.loading)
                        const SizedBox(
                          height: 300.0,
                          child: Center(
                            child: SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                color: ColorResources.purple,
                              )
                            )
                          ),
                        ),

                      if(notifier.listProductStatus == ListProductStatus.empty)
                        SizedBox(
                          height: 300.0,
                          child: Center(
                            child: Text("Yaa.. Produk tidak ditemukan",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            )
                          ),
                        ),

                      if(notifier.listProductStatus == ListProductStatus.error)
                        SizedBox(
                          height: 300.0,
                          child: Center(
                            child: Text("Hmm... Mohon tunggu yaa",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            )
                          )
                        ),

                      if(notifier.listProductStatus == ListProductStatus.loaded)
                        ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            bottom: 20.0,                           
                            left: 8.0,
                            right: 8.0
                          ),
                          itemCount: notifier.productSellers.length,
                          itemBuilder: (BuildContext context, int i) {
                            return CheckboxListTile(
                              value: notifier.productSellers[i].selected,
                              onChanged: (bool? val) {
                                notifier.onSelectedProduct(
                                  id: notifier.productSellers[i].id, 
                                  val: val!
                                );
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                              
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                              
                                      CachedNetworkImage(
                                        imageUrl: notifier.productSellers[i].medias.isNotEmpty 
                                        ? notifier.productSellers[i].medias.first.path 
                                        : '-',
                                        imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                          return Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(6.0)
                                              ),
                                              image: DecorationImage(image: imageProvider)
                                            ),
                                          );
                                        },
                                        placeholder: (BuildContext context, String url) {
                                          return Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0)
                                              ),
                                              image: DecorationImage(image: AssetImage('assets/images/default_image.png'))
                                            ),
                                          );
                                        },
                                        errorWidget: (BuildContext context, String url, dynamic error) {
                                          return Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0)
                                              ),
                                              image: DecorationImage(image: AssetImage('assets/images/default_image.png'))
                                            ),
                                          );
                                        },
                                      ),
                              
                                      const SizedBox(width: 10.0),
                              
                                      Text(notifier.productSellers[i].title,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                              
                                    ],
                                  ),
                              
                              
                              
                                ],
                              ),
                            );                   
                          },
                        )
                              
                    ])
                  ),
                )
            
              ],
            );
          }
        ),
      )
    );
  }
}