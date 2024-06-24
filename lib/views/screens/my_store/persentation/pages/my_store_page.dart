import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/my_store/data/my_store_model.dart';
import 'package:hp3ki/views/screens/my_store/domain/my_store_repository.dart';
import 'package:hp3ki/views/screens/my_store/persentation/providers/my_store_provider.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/pages/my_store_add_product_page.dart';
import 'package:hp3ki/views/screens/my_store_edit/persentation/pages/my_store_edit_page.dart';
import 'package:hp3ki/views/screens/my_store_order/persentation/pages/my_store_order_page.dart';
import 'package:hp3ki/views/screens/my_store_product_list/persentation/pages/my_store_product_list_page.dart';
import 'package:hp3ki/widgets/custom_select_map_location.dart';
import 'package:provider/provider.dart';

class MyStorePage extends StatelessWidget {
  const MyStorePage({super.key});

  static Route go() => MaterialPageRoute(builder: (_) => const MyStorePage());

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, nProfile, child) {
      return MultiProvider(providers: [
        ChangeNotifierProvider<MyStoreProvider>(
          create: (_) => MyStoreProvider(
            storeId: nProfile.user?.storeId ?? '-',
            repo: MyStoreRepository(
              client: DioManager.shared.getClient(),
            ),
          )..init(),
        )
      ], child: const MyStoreView());
    });
  }
}

class MyStoreView extends StatelessWidget {
  const MyStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreProvider>(builder: (context, notifier, child) {
      Widget body;
      if (notifier.loading) {
        body = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (notifier.store == null) {
        body = const Center(
          child: Text('Please check your connection'),
        );
      } else {
        body = _hasStore(context, notifier.store!, notifier.pendingOrderCount);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            getTranslated("TXT_MY_STORE", context),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        body: body,
      );
    });
  }

  Widget _hasStore(BuildContext context, MyStoreModel store, int pendingCount) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 1,
                        color: Colors.black.withOpacity(.3),
                        offset: const Offset(1, 1),
                      )
                    ],
                    color: Colors.grey.shade200,
                  ),
                  child: store.picture == '-'
                      ? const Center(
                          child: Icon(
                            Icons.store,
                            size: 38,
                          ),
                        )
                      : Image.network(
                          store.picture,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder(
                          future: geocodeParsing(LatLng(double.parse(store.lat),
                              double.parse(store.lng))),
                          builder: (context, snap) {
                            var text = snap.data ?? '-';
                            return Text(
                              text,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            );
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MyStoreEditPage.go(context, store));
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(context, MyStoreAddProductPage.go());
                },
                leading: const Icon(
                  Icons.production_quantity_limits,
                ),
                title: Text(
                  '${getTranslated("TXT_ADD", context)} ${getTranslated(
                    "TXT_PRODUCT",
                    context,
                  )}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  getTranslated('TXT_DESCRIPTION_ADD_PRODUCT', context),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(
                height: 4,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MyStoreProductListPage.go());
                },
                leading: const Icon(
                  Icons.list_alt,
                ),
                title: Text(
                  '${getTranslated(
                    "TXT_LIST",
                    context,
                  )} ${getTranslated(
                    "TXT_PRODUCT",
                    context,
                  )}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  getTranslated(
                    'TXT_DESCRIPTION_REGISTER_PRODUCT',
                    context,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MyStoreOrderPage.go());
                },
                leading: const Icon(
                  Icons.list,
                ),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${getTranslated("TXT_LIST", context)} ${getTranslated(
                          "TXT_ORDER",
                          context,
                        )}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Badge(
                      alignment: Alignment.center,
                      isLabelVisible: pendingCount == 0 ? false : true,
                      label: Text(pendingCount.toString()),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.notifications_none),
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  getTranslated('TXT_DESCRIPTION_LIST_ORDER', context),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
