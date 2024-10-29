import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:hp3ki/data/models/ecommerce/product/category.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/screens/ecommerce/product/widget/product_item.dart';
import 'package:hp3ki/views/screens/ecommerce/store/add_product.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';

class ProductsSellerScreen extends StatefulWidget {
  final String storeId;

  const ProductsSellerScreen({
    required this.storeId,
    super.key
  });

  @override
  State<ProductsSellerScreen> createState() => ProductsSellerScreenState();
}

class ProductsSellerScreenState extends State<ProductsSellerScreen> {

  Timer? debounce;

  late TextEditingController searchC;
  late FocusNode searchFn;

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return; 
      await ep.fetchAllProductSeller(search: "", storeId: widget.storeId);

    if(!mounted) return;
      await ep.fetchAllProductCategory(isFromCreateProduct: false);
  }

  @override 
  void initState() {
    super.initState();
    
    searchC = TextEditingController();
    searchFn = FocusNode();

    ep = context.read<EcommerceProvider>();

    searchC.addListener(() {

      if(searchC.text.isNotEmpty) {
        if (debounce?.isActive ?? false) debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 1000), () {
            ep.fetchAllProductSeller(
              search: searchC.text, 
              storeId: widget.storeId
            );
          });
      }

    });

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    debounce?.cancel();

    searchC.dispose();
    searchFn.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Consumer<EcommerceProvider>(
        builder: (_, notifier, __) {
          return NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                notifier.reached = true;

                if(notifier.hasMore) {
                  notifier.loadMoreProduct(); 
                }
              }
              return true;
            },
            child: RefreshIndicator.adaptive(
              onRefresh: () {
                return Future.sync(() {
                  getData();
                });
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
                ),
                slivers: [
              
                  SliverAppBar(
                    title: Text("Daftar Produk",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.black
                      ),
                    ),
                    centerTitle: true,
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        NS.pop();
                      },
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          NS.push(context, AddProductScreen(storeId: widget.storeId));
                        }, 
                        splashRadius: 15.0,
                        icon: const Icon(
                          Icons.add_circle,
                        )
                      )
                    ],
                  ),
              
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 16.0,
                        right: 16.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                  
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: searchC,
                              focusNode: searchFn,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              ),
                              decoration: InputDecoration(
                                labelText: "Cari Produk",
                                labelStyle: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                contentPadding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 16.0,
                                  right: 16.0
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                                )
                              ),
                            ),
                          ),
            
                        ],
                      )
                    )
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 16.0,
                        right: 16.0
                      ),
                      child: Consumer<EcommerceProvider>(
                        builder: (__, notifier, _) {
                          return notifier.getProductCategoryStatus == GetProductCategoryStatus.loading 
                          ? const SizedBox() 
                          : notifier.getProductCategoryStatus == GetProductCategoryStatus.empty 
                          ? const SizedBox() 
                          : notifier.getProductCategoryStatus == GetProductCategoryStatus.error 
                          ? const SizedBox() 
                          : SizedBox(
                              height: 50.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemCount: notifier.productCategories.length,
                                itemBuilder: (BuildContext context, int i) {
                                
                                ProductCategoryData category = notifier.productCategories[i];

                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 8.0,
                                    right: 8.0
                                  ),
                                  decoration: BoxDecoration(
                                    color: notifier.cat == category.name 
                                    ? ColorResources.purpleDark 
                                    : ColorResources.purple,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  child: Material(
                                    color: ColorResources.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: () {
                                        notifier.selectCat(param: category.name);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(category.name,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            fontWeight: FontWeight.bold,
                                            color: ColorResources.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                );
                              },
                            ),
                          );
                        },
                      )
                    )
                  ),

                  if(notifier.listProductStatus == ListProductStatus.loading)
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
              
                  if(notifier.listProductStatus == ListProductStatus.error)
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
                  
                  if(notifier.listProductStatus == ListProductStatus.empty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text("Yaa.. Produk tidak ditemukan",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        )
                      )
                    ),
              
                  if(notifier.listProductStatus == ListProductStatus.loaded)
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width > 400 
                          ? 2.0 / 2.4 
                          : 2.0 / 3.3,
                          mainAxisSpacing: 10.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) {
                            if (i < notifier.productSellers.length) {
                              final product = notifier.productSellers[i];
                              return ProductItem(product: product);
                            } else if (notifier.hasMore) {
                              if(notifier.reached) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return const SizedBox();
                            } else {
                              return const SizedBox.shrink(); 
                            }
                          },
                          childCount: notifier.hasMore
                          ? notifier.productSellers.length + 1 
                          : notifier.productSellers.length,
                        ),
                      ),
                    ),
              
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}