import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:provider/provider.dart';

import 'package:hp3ki/data/models/ecommerce/product/category.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/button/bounce.dart';

import 'package:hp3ki/views/screens/ecommerce/cart/cart.dart';
import 'package:hp3ki/views/screens/ecommerce/order/list.dart';
import 'package:hp3ki/views/screens/ecommerce/product/widget/product_item.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {

  Timer? debounce;

  late TextEditingController searchC;
  late FocusNode searchFn;

  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return; 
      await ep.fetchAllProduct(search: "");

    if(!mounted) return;
      await ep.fetchAllProductCategory(isFromCreateProduct: false);

    if(!mounted) return;
      await ep.getCart();
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
            ep.fetchAllProduct(search: searchC.text);
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
                    title: Text("Toko HP3KI",
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
                            child: GestureDetector(
                              onTap: () {
                                NS.push(context, const ListOrderScreen());
                              },
                              child: const Icon(Icons.list)
                            )
                          ),
            
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
                  
                          const SizedBox(width: 15.0),
            
                          if(notifier.getCartStatus == GetCartStatus.loading)
                            Bouncing(
                              onPress: () {
                                NS.push(context, const CartScreen());
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 20.0
                              ),
                            ),
            
                          if(notifier.getCartStatus == GetCartStatus.error)
                            Bouncing(
                              onPress: () {
                                NS.push(context, const CartScreen());
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 20.0
                              ),
                            ),
            
                          if(notifier.getCartStatus == GetCartStatus.empty)
                            Bouncing(
                              onPress: () {
                                NS.push(context, const CartScreen());
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 20.0
                              ),
                            ),
                        
                          if(notifier.getCartStatus == GetCartStatus.loaded)
                            Bouncing(
                              onPress: () {
                                NS.push(context, const CartScreen());
                              },
                              child: Badge(
                                label: Text(notifier.cartData.totalItem.toString(),
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart,
                                  size: 20.0
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
                            if (i < notifier.products.length) {
                              final product = notifier.products[i];
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
                          ? notifier.products.length + 1 
                          : notifier.products.length,
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