import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/pages/my_store_add_product_page.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/providers/my_store_product_list_provider.dart';
import 'package:hp3ki/widgets/loading_modal.dart';
import 'package:provider/provider.dart';

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreProductListProvider>(
      builder: (context, notifier, child) {
        return ListView(
          children: List.generate(notifier.filterProducts.length, (index) {
            final product = notifier.filterProducts[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        child: product.picture == '-'
                            ? const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                ),
                              )
                            : Image.network(
                                product.picture,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Helper.formatCurrency(
                                product.price.toDouble(),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${getTranslated(
                                "TXT_STOCK",
                                context,
                              )}: ${product.stock}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: product.status == 1
                                    ? Colors.green
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Text(
                                product.status == 1
                                    ? getTranslated(
                                        "TXT_ACTIVE",
                                        context,
                                      )
                                    : getTranslated(
                                        "TXT_NON_ACTIVE",
                                        context,
                                      ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: product.status == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: BorderSide(
                                width: 2.5, color: Colors.grey.shade200),
                          ),
                          onPressed: () async {
                            LoadingModalWidget.show(context,
                                onInit: (ctx) async {
                              try {
                                final p = await context
                                    .read<MyStoreProductListProvider>()
                                    .getDetail(product.id);
                                if (!ctx.mounted) return;
                                Navigator.pop(ctx);
                                await Navigator.push(
                                  context,
                                  MyStoreAddProductPage.go(product: p),
                                );
                                if (context.mounted) {
                                  context
                                      .read<MyStoreProductListProvider>()
                                      .fetchProducts();
                                }
                              } catch (e) {
                                if (!ctx.mounted) return;
                                Navigator.pop(ctx);
                              }
                            });
                          },
                          child: Text(
                            '${getTranslated(
                              "EDIT",
                              context,
                            )} ${getTranslated(
                              "TXT_PRODUCT",
                              context,
                            )}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        GeneralModal.confirm(context,
                            title: getTranslated(
                              "ARE_YOU_SURE_WANT_TO_DELETE_PRDOUCT",
                              context,
                            ),
                            msg: "msg", onConfirm: () {
                          context
                              .read<MyStoreProductListProvider>()
                              .deleteProduct(product.id);
                          Navigator.pop(context);
                        });
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
