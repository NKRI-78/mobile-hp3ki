import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/providers/my_store_product_list_provider.dart';
import 'package:provider/provider.dart';

class ProductCategoryTab extends StatelessWidget {
  const ProductCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreProductListProvider>(
        builder: (context, notifier, child) {
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: List.generate(notifier.categories.length + 1, (index) {
                final active = notifier.categoryIndex == index;
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () {
                        context
                            .read<MyStoreProductListProvider>()
                            .changeCategory(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: active
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: active ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final category = notifier.categories[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<MyStoreProductListProvider>()
                          .changeCategory(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: active
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: active ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
