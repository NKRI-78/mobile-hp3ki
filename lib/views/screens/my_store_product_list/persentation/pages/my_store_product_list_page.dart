import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/my_store_product_list/domain/my_store_product_list_repository.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/providers/my_store_product_list_provider.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/widgets/product_category_tab.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/widgets/product_list_widget.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/widgets/product_search_widget.dart';
import 'package:provider/provider.dart';

class MyStoreProductListPage extends StatelessWidget {
  const MyStoreProductListPage({super.key});

  static Route go() {
    return MaterialPageRoute(
      builder: (_) => const MyStoreProductListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<MyStoreProductListProvider>(
        create: (_) => MyStoreProductListProvider(
          repo: MyStoreProductListRepository(
            client: DioManager.shared.getClient(),
          ),
        )..init(),
      ),
    ], child: const MyStoreProductListView());
  }
}

class MyStoreProductListView extends StatelessWidget {
  const MyStoreProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${getTranslated(
            "TXT_LIST",
            context,
          )} ${getTranslated(
            "TXT_PRODUCT",
            context,
          )}",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProductSearchWidget(),
            const ProductCategoryTab(),
            Consumer<MyStoreProductListProvider>(
                builder: (context, notifier, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Text(
                  '${notifier.filterProducts.length} ${getTranslated(
                    "TXT_PRODUCT",
                    context,
                  )}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
            Divider(
              height: 1,
              thickness: 1.4,
              color: Colors.grey.shade300,
            ),
            const Expanded(
              child: ProductsListWidget(),
            )
          ],
        ),
      ),
    );
  }
}
