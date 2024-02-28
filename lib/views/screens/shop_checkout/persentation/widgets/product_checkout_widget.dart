// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/product/data/models/product_checkout_model.dart';
import 'package:hp3ki/views/screens/shipping_address/persentation/providers/shipping_address_provider.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/raja_ongkir_cost_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:provider/provider.dart';

class ProductCheckoutWidget extends StatelessWidget {
  const ProductCheckoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCheckoutProvider>(builder: (context, notifier, child) {
      return Column(
        children: List.generate(notifier.productCheckout?.stores.length ?? 0,
            (index) {
          final data = notifier.productCheckout!.stores[index];

          final delivery = notifier.delivery[data.store.id];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  data.store.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                children: List.generate(data.items.length, (i) {
                  final product = data.items[i];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          child: product.picture == '-'
                              ? const Center(
                                  child: Icon(Icons.image),
                                )
                              : Image.network(
                                  product.picture,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${product.cart.quantity.toString()} x ",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    Helper.formatCurrency(
                                      product.price.toDouble(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  );
                }),
              ),
              if (delivery == null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    bottom: 16,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (context
                              .read<ShippingAddressProvider>()
                              .primaryAddress ==
                          null) {
                        GeneralModal.error(context,
                            msg: 'Select address first');
                        return;
                      }
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (_) => ChooseDeliveryList(
                          context: context,
                          data: data,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(
                            6,
                          )),
                      child: Center(
                        child: Text(
                          getTranslated(
                            "TXT_SELECT_SHIPPING",
                            context,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    bottom: 16,
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (_) => ChooseDeliveryList(
                          context: context,
                          data: data,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                delivery.description,
                              ),
                              Text(
                                Helper.formatCurrency(
                                  delivery.cost.first.value.toDouble(),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        const Icon(
                          Icons.chevron_right,
                        )
                      ],
                    ),
                  ),
                ),
              Divider(
                height: 3,
                thickness: 6,
                color: Colors.grey.shade200,
              ),
            ],
          );
        }),
      );
    });
  }
}

class ChooseDeliveryList extends StatefulWidget {
  const ChooseDeliveryList({
    Key? key,
    required this.context,
    required this.data,
  }) : super(key: key);

  final BuildContext context;
  final StoreElement data;

  @override
  State<ChooseDeliveryList> createState() => _ChooseDeliveryListState();
}

class _ChooseDeliveryListState extends State<ChooseDeliveryList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  void init() async {
    rajaOngkir = await widget.context
        .read<ShopCheckoutProvider>()
        .getCostList(widget.data.store.id);
    loading = false;
    setState(() {});
  }

  bool loading = true;

  RajaOngkirCostModel? rajaOngkir;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const CircularProgressIndicator.adaptive()
          else
            ListView(
              shrinkWrap: true,
              children: List.generate(rajaOngkir?.data.length ?? 0, (index) {
                final delivery = rajaOngkir!.data[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(delivery.costs.length, (index) {
                        final service = delivery.costs[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 16,
                            right: 16,
                          ),
                          child: InkWell(
                            onTap: () {
                              widget.context
                                  .read<ShopCheckoutProvider>()
                                  .setDeliveryPerStore(
                                      service, widget.data.store.id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.service,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        delivery.code.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "(etd ${service.cost.first.etd} hari)",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Helper.formatCurrency(
                                      service.cost.first.value.toDouble(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                );
              }),
            ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
