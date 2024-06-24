import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:provider/provider.dart';

class ProductNameWidget extends StatelessWidget {
  const ProductNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  text: "${getTranslated(
                    "NAME",
                    context,
                  )} ${getTranslated(
                    "TXT_PRODUCT",
                    context,
                  )}",
                ),
                const TextSpan(
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    text: " *")
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
              height: 50,
              child: TextFormField(
                initialValue: notifier.productName,
                onChanged: (value) {
                  context
                      .read<MyStoreAddProductProvider>()
                      .setState(productNameState: value);
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "${getTranslated(
                      "TXT_PRODUCT",
                      context,
                    )} ${getTranslated(
                      "NAME",
                      context,
                    )} ${getTranslated(
                      "TXT_REQUIRED",
                      context,
                    )}";
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 14),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  hintText: "${getTranslated(
                    "TXT_INPUT",
                    context,
                  )} ${getTranslated("TXT_PRODUCT", context)} ${getTranslated(
                    "NAME",
                    context,
                  )}",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
