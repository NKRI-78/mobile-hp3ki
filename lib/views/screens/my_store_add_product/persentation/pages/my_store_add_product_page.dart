import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/my_store_add_product/domain/my_store_add_product_repository.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_category_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_condition_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_description_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_images_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_name_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_price_widget.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/widgets/product_stock_widget.dart';
import 'package:hp3ki/views/screens/product/data/models/product_detail_model.dart';
import 'package:hp3ki/widgets/keyboard_visibility.dart';
import 'package:provider/provider.dart';

final GlobalKey<FormState> formMyStoreAddProduct = GlobalKey<FormState>();

class MyStoreAddProductPage extends StatelessWidget {
  const MyStoreAddProductPage({
    super.key,
    this.product,
  });

  final ProductDetailModel? product;

  static Route go({ProductDetailModel? product}) {
    return MaterialPageRoute(
        builder: (_) => MyStoreAddProductPage(
              product: product,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<MyStoreAddProductProvider>(
        create: (_) => MyStoreAddProductProvider(
          product: product,
          repo: MyStoreAddProductRepository(
            client: DioManager.shared.getClient(),
          ),
        )..init(),
      )
    ], child: const MyStoreAddProductView());
  }
}

class MyStoreAddProductView extends StatelessWidget {
  const MyStoreAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<MyStoreAddProductProvider>(
            builder: (context, notifier, child) {
          var title = notifier.product == null
              ? getTranslated('TXT_ADD', context)
              : getTranslated('TXT_EDIT', context);
          return Text(
            "$title ${getTranslated('TXT_PRODUCT', context)}",
            style: const TextStyle(
              fontSize: 18,
            ),
          );
        }),
        actions: [
          Consumer<MyStoreAddProductProvider>(
              builder: (context, notifier, child) {
            if (notifier.product == null) {
              return const SizedBox.shrink();
            }
            return Switch.adaptive(
              activeColor: Colors.blue,
              value: notifier.status,
              onChanged: (value) {
                context.read<MyStoreAddProductProvider>().changeStatus(value);
              },
            );
          }),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: Form(
        key: formMyStoreAddProduct,
        child: KeyboardVisibility(builder: (context, vis, height) {
          return Stack(
            children: [
              SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProductImagesWidget(),
                      const ProductNameWidget(),
                      const ProductPriceWidget(),
                      const ProductStockWidget(),
                      const ProductConditionWidget(),
                      const ProductCategoryionWidget(),
                      const ProductDescriptionWidget(),
                      Consumer<MyStoreAddProductProvider>(
                          builder: (context, notifier, child) {
                        var title = notifier.product == null
                            ? getTranslated('TXT_ADD', context)
                            : getTranslated('TXT_EDIT', context);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: notifier.loading
                                  ? null
                                  : () async {
                                      if (!(formMyStoreAddProduct.currentState
                                              ?.validate() ??
                                          false)) return;

                                      if (notifier.conditionId == null) {
                                        GeneralModal.error(context,
                                            msg: "${getTranslated(
                                              "TXT_CONDITION",
                                              context,
                                            )} ${getTranslated(
                                              "TXT_REQUIRED",
                                              context,
                                            )}", onOk: () {
                                          Navigator.pop(context);
                                        });
                                        return;
                                      }
                                      if (notifier.categoryId == null) {
                                        GeneralModal.error(context,
                                            msg: "${getTranslated(
                                              "TXT_CATEGORY",
                                              context,
                                            )} ${getTranslated(
                                              "TXT_REQUIRED",
                                              context,
                                            )}", onOk: () {
                                          Navigator.pop(context);
                                        });
                                        return;
                                      }
                                      if (notifier.images.isEmpty) {
                                        GeneralModal.error(context,
                                            msg:
                                                "${getTranslated("TXT_IMAGE", context)} ${getTranslated("TXT_REQUIRED", context)}",
                                            onOk: () {
                                          Navigator.pop(context);
                                        });
                                        return;
                                      }
                                      if (notifier.product == null) {
                                        await context
                                            .read<MyStoreAddProductProvider>()
                                            .addProduct(context);
                                      } else {
                                        await context
                                            .read<MyStoreAddProductProvider>()
                                            .editProduct(context);
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                              child: notifier.loading
                                  ? const CircularProgressIndicator.adaptive()
                                  : Text(
                                      "$title ${getTranslated('TXT_PRODUCT', context)}",
                                    )),
                        );
                      }),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              if (vis)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            getTranslated(
                              "TXT_DONE",
                              context,
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
