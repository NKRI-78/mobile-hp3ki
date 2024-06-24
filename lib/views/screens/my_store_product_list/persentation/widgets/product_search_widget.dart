import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/providers/my_store_product_list_provider.dart';
import 'package:provider/provider.dart';

class ProductSearchWidget extends StatelessWidget {
  const ProductSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      child: TextFormField(
        onChanged: context.read<MyStoreProductListProvider>().searchProduct,
        style: const TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          hintText: '${getTranslated("SEARCH", context)} ${getTranslated(
            "TXT_PRODUCT",
            context,
          )}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
