// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/shipping_address/data/shipping_address_model.dart';
import 'package:hp3ki/views/screens/shipping_address/persentation/providers/shipping_address_provider.dart';
import 'package:hp3ki/views/screens/shipping_address_add/persentation/pages/shipping_address_add_page.dart';
import 'package:hp3ki/widgets/custom_select_map_location.dart';
import 'package:provider/provider.dart';

class ShippingAddressPage extends StatelessWidget {
  const ShippingAddressPage({super.key});

  static Route go() =>
      MaterialPageRoute(builder: (_) => const ShippingAddressPage());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ShippingAddressProvider>.value(
          value: context.read<ShippingAddressProvider>()
            ..fetchAllShippingAddress())
    ], child: const ShippingAddressView());
  }
}

class ShippingAddressView extends StatelessWidget {
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShippingAddressProvider>(
        builder: (context, notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            getTranslated("TXT_SHIPPING_ADDRESS", context),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            if (notifier.list.isEmpty)
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      ShippingAddressAddPage.go(),
                    );
                  },
                  icon: const Icon(Icons.add))
          ],
        ),
        body: SizedBox.expand(
          child: notifier.list.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Belum Ada Alamat.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: InkWell(
                    //     onTap: () {
                    // Navigator.push(
                    //   context,
                    //   ShippingAddressAddPage.go(),
                    // );
                    //     },
                    //     child: Container(
                    //       width: double.infinity,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //             width: 2,
                    //             color: Colors.grey,
                    //           ),
                    //           borderRadius: BorderRadius.circular(
                    //             6,
                    //           )),
                    //       child: Center(
                    //         child: Text(
                    //           '${getTranslated("TXT_ADD", context)} ${getTranslated("ADDRESS", context)}',
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      if (notifier.list.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Belum ada alamat",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      else
                        ...List.generate(notifier.list.length, (index) {
                          final sa = notifier.list[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  sa.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) =>
                                          ShowShippingAddressOptions(data: sa),
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert),
                                ),
                                subtitle: FutureBuilder(
                                  future: geocodeParsing(
                                    LatLng(
                                      double.parse(sa.lat),
                                      double.parse(sa.lng),
                                    ),
                                  ),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data ?? '-'),
                                          Row(
                                            children: [
                                              if (sa.label.isNotEmpty)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 6, right: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      6,
                                                    ),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  child: Text(
                                                    sa.label,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              if (sa.defaultLocation)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      6,
                                                    ),
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  child: Text(
                                                    getTranslated(
                                                        'TXT_DEFAULT', context),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Divider(
                                height: 1,
                              ),
                            ],
                          );
                        }),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              ShippingAddressAddPage.go(),
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
                                '${getTranslated("TXT_ADD", context)} ${getTranslated("ADDRESS", context)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );
    });
  }
}

class ShowShippingAddressOptions extends StatelessWidget {
  const ShowShippingAddressOptions({
    Key? key,
    required this.data,
  }) : super(key: key);
  final ShippingAddressModel data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close)),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    getTranslated("TXT_CHOOSE_OTHER", context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  onTap: () async {
                    context
                        .read<ShippingAddressProvider>()
                        .setPrimaryAddress(data);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  title: Text(
                    getTranslated(
                      "TXT_SET_ADDRESS_DEFAULT_AND_CHOOSE",
                      context,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Divider(
                  height: 1,
                )
              ],
            ),
            if (!data.defaultLocation)
              Column(
                children: [
                  ListTile(
                    onTap: () async {
                      context
                          .read<ShippingAddressProvider>()
                          .deleteShippingAddress(data);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    title: Text(
                      getTranslated("TXT_DELETE_ADDRESS", context),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
