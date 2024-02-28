import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:provider/provider.dart';

class ProductConditionWidget extends StatelessWidget {
  const ProductConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  text: getTranslated("TXT_CONDITION", context),
                ),
                const TextSpan(
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    text: " *"),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Consumer<MyStoreAddProductProvider>(
              builder: (context, notifier, child) {
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(notifier.conditions.length, (index) {
                    final condition = notifier.conditions[index];
                    final active = condition.id == notifier.conditionId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<MyStoreAddProductProvider>()
                              .changeCondtion(condition);
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
                              horizontal: 16, vertical: 6),
                          child: Text(
                            condition.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: active ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
