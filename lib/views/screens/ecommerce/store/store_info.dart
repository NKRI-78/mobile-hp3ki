import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/views/screens/ecommerce/order/seller/list.dart';
import 'package:hp3ki/views/screens/ecommerce/store/add_product.dart';
import 'package:hp3ki/views/screens/ecommerce/store/bulk_delete_product.dart';
import 'package:hp3ki/views/screens/ecommerce/store/create_update_store.dart';
import 'package:hp3ki/views/screens/ecommerce/store/seller/products.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';


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
                    title: Text("Toko Saya",
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
                    bottom: PreferredSize(
                     preferredSize: const Size.fromHeight(80.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ColorResources.primary,
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

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          IconButton(
                            splashRadius: 20.0,
                            onPressed: () {
                              NS.push(context, const CreateStoreOrUpdateScreen());
                            },
                            icon: const Icon(Icons.edit,
                              color: ColorResources.blue,
                            )
                          ),

                          IconButton(
                            splashRadius: 20.0,
                            onPressed: () {
                              NS.push(context, BulkDeleteProductScreen(storeId: widget.storeId));
                            },
                            icon: const Icon(Icons.delete,
                              color: ColorResources.error,
                            )
                          ),

                          IconButton(
                            splashRadius: 20.0,
                            onPressed: () {
                              NS.push(context, AddProductScreen(storeId: widget.storeId));
                            },
                            icon: const Icon(Icons.add,
                              color: ColorResources.success,
                            )
                          ),

                        ],
                      ),

                      const SizedBox(height: 14.0),
                          
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

                      ListTile(
                        dense: true,
                        title: Text("Daftar Transaksi",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.black
                          ),
                        ),
                        leading: const Icon(Icons.list),
                        onTap: () {
                          NS.push(context, const ListOrderSellerScreen());
                        },
                      ),

                      const Divider(
                        height: 1.0,
                        color: ColorResources.black,
                      ),

                      if(notifier.listProductStatus == ListProductStatus.loading)
                        const SizedBox(
                          height: 300.0,
                          child: Center(
                            child: SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                color: ColorResources.primary,
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