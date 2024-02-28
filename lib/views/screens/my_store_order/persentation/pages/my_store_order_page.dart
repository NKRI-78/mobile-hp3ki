import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/my_store_order/domain/my_store_order_repository.dart';
import 'package:hp3ki/views/screens/my_store_order/persentation/providers/my_store_order_provider.dart';
import 'package:hp3ki/views/screens/my_store_order/persentation/widgets/show_order_option.dart';
import 'package:hp3ki/views/screens/order_detail/persentation/pages/order_detail_page.dart';
import 'package:provider/provider.dart';

class MyStoreOrderPage extends StatelessWidget {
  const MyStoreOrderPage({super.key});

  static Route go() {
    return MaterialPageRoute(builder: (_) => const MyStoreOrderPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<MyStoreOrderProvider>(
        create: (_) => MyStoreOrderProvider(
          repo: MyStoreOrderRepository(
            client: DioManager.shared.getClient(),
          ),
        )..init(),
      )
    ], child: const MyStoreOrderView());
  }
}

class MyStoreOrderView extends StatelessWidget {
  const MyStoreOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreOrderProvider>(builder: (context, notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${getTranslated("TXT_LIST", context)} ${getTranslated("TXT_ORDER", context)}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: Row(
                    children: OrderStatus.values
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<MyStoreOrderProvider>()
                                    .changeStatus(e);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: e == notifier.status
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                child: Text(
                                  e.name.toUpperCase() == 'CONFIRM'
                                      ? 'PACKING'
                                      : e.name.toUpperCase(),
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              if (notifier.order.isEmpty)
                const Expanded(
                    child: Center(
                  child: Text(
                    'No data found',
                  ),
                ))
              else
                Expanded(
                  child: ListView(
                    children: List.generate(notifier.order.length, (index) {
                      final order = notifier.order[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                OrderDetailPage.go(order.orderId,
                                    isSeller: true),
                              );
                            },
                            title: Text(
                              order.orderId,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: order.status == 'PENDING'
                                ? InkWell(
                                    onTap: () {
                                      ShowOtherOption.show(context, order);
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                    ),
                                  )
                                : null,
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: order.productPicture == null
                                  ? const Icon(Icons.image)
                                  : Image.network(
                                      order.productPicture!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (order.status != 'CONFIRM' ||
                                    order.status != 'PENDING') ...[
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Total (${order.productCount} barang)",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                if (order.status == 'CONFIRM') ...[
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: order.shippingTracking,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: order
                                                          .shippingTracking))
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Nomor cnote di copy ke papan ketik"),
                                                  ),
                                                );
                                              });
                                            },
                                            child: const Icon(
                                              Icons.copy_outlined,
                                              size: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Text(
                                    "Harap berikan nomor resi ke JNE terdekat sebelum 24 jam",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          )
                        ],
                      );
                    }),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
