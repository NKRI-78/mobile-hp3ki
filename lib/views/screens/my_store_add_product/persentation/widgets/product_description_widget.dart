import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:provider/provider.dart';

class ProductDescriptionWidget extends StatelessWidget {
  const ProductDescriptionWidget({super.key});

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
                  text:
                      "${getTranslated("TXT_PRODUCT", context)} ${getTranslated(
                    "TXT_DESCRIPTION",
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
            return Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50),
              child: TextFormField(
                initialValue: notifier.productDescription,
                onChanged: (value) {
                  context
                      .read<MyStoreAddProductProvider>()
                      .setState(productDescriptionState: value);
                },
                minLines: 4,
                maxLines: 4,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "${getTranslated(
                      "TXT_PRODUCT",
                      context,
                    )} ${getTranslated(
                      "TXT_DESCRIPTION",
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
                  )} ${getTranslated(
                    "TXT_PRODUCT",
                    context,
                  )} ${getTranslated(
                    "TXT_DESCRIPTION",
                    context,
                  )}",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
