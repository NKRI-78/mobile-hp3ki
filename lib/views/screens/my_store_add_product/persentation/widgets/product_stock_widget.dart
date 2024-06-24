import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:provider/provider.dart';

class ProductStockWidget extends StatelessWidget {
  const ProductStockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreAddProductProvider>(
        builder: (context, notifier, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    text: getTranslated(
                      "TXT_STOCK",
                      context,
                    ),
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
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      initialValue: notifier.stock,
                      onChanged: (value) {
                        context
                            .read<MyStoreAddProductProvider>()
                            .setState(stockState: value);
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id_ID',
                          decimalDigits: 0,
                          symbol: '',
                        ),
                      ],
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        labelText: getTranslated(
                          "TXT_STOCK_READY",
                          context,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: notifier.minOrder,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context
                            .read<MyStoreAddProductProvider>()
                            .setState(minOrderState: value);
                      },
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id_ID',
                          decimalDigits: 0,
                          symbol: '',
                        ),
                      ],
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: getTranslated(
                          "TXT_MIN_ORDER",
                          context,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: notifier.weight,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context
                            .read<MyStoreAddProductProvider>()
                            .setState(weightState: value);
                      },
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id_ID',
                          decimalDigits: 0,
                          symbol: '',
                        ),
                      ],
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: getTranslated(
                          "TXT_WEIGHT",
                          context,
                        ),
                        suffixText: 'Gram',
                        suffixStyle: const TextStyle(fontSize: 12),
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
