import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_order/data/order_model.dart';
import 'package:hp3ki/views/screens/my_store_order/persentation/providers/my_store_order_provider.dart';
import 'package:provider/provider.dart';

class ShowOtherOption extends StatelessWidget {
  const ShowOtherOption({super.key, required this.order});
  final OrderModel order;

  static void show(BuildContext ctx, OrderModel order) {
    showModalBottomSheet(
      context: ctx,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider<MyStoreOrderProvider>.value(
            value: ctx.read<MyStoreOrderProvider>(),
          ),
        ],
        child: ShowOtherOption(
          order: order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                context
                    .read<MyStoreOrderProvider>()
                    .confirmOrder(order.orderId);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.check),
              title: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () async {
                final msg = await CancelOrderReason.show(context);
                if (msg != null && context.mounted) {
                  context
                      .read<MyStoreOrderProvider>()
                      .cancelOrder(order.orderId, msg);
                  Navigator.pop(context);
                }
              },
              leading: const Icon(Icons.delete_outline),
              title: const Text(
                'Cancel Order',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CancelOrderReason extends StatelessWidget {
  const CancelOrderReason({super.key});

  static Future<String?> show(
    BuildContext ctx,
  ) async {
    return await showModalBottomSheet<String?>(
      context: ctx,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const CancelOrderReason(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context, 'Stok habis');
            },
            title: const Text(
              'Stok Habis',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, 'Tempat pengiriman bermasalah');
            },
            trailing: const Icon(Icons.chevron_right),
            title: const Text(
              'Tempat pengiriman bermasalah',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
