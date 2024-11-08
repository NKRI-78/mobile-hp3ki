import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:date_count_down/date_count_down.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/currency.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/helper.dart';

import 'package:hp3ki/views/screens/ecommerce/order/detail.dart';

class ListOrderScreen extends StatefulWidget {
  const ListOrderScreen({super.key});

  @override
  State<ListOrderScreen> createState() => ListOrderScreenState();
}

class ListOrderScreenState extends State<ListOrderScreen> with SingleTickerProviderStateMixin {

  late TabController tabC;
  late EcommerceProvider ep;

  Future<void> getData() async {
    if(!mounted) return;  
      await ep.listOrder(orderStatus: "WAITING_PAYMENT");
  }
  
  @override 
  void initState() {
    super.initState();

    tabC = TabController(length: 6, vsync: this);

    tabC.addListener(() {
      if(tabC.indexIsChanging) {
        if(tabC.index == 0) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "WAITING_PAYMENT");
          });
        }
        if(tabC.index == 1) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "PAID");
          });
        }
        if(tabC.index == 2) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "PACKING");
          });
        }
        if(tabC.index == 3) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "ON PROCESS");
           });
        }
        if(tabC.index == 4) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "DELIVERED");
          });
        }
        if(tabC.index == 5) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await ep.listOrder(orderStatus: "REFUND");
          });
        }
      }
    });
    
    ep = context.read<EcommerceProvider>();

    Future.delayed(Duration.zero, () => getData());
  }

  @override 
  void dispose() {
    tabC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Daftar Pesanan",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.bold,
            color: ColorResources.black
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.black,
          onPressed: () {
            NS.pop();
          },
        ),
        bottom: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          controller: tabC,
          labelStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeExtraSmall,
            color: ColorResources.black
          ),
          tabs: const [
            Tab(text: 'Belum bayar'),
            Tab(text: 'Dibayar'),
            Tab(text: 'Dikemas'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
            Tab(text: 'Batal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabC,
        children: [
          paymentContent('WAITING_PAYMENT'),
          paymentContent('PAID'),
          paymentContent('PACKING'),
          paymentContent('ON PROCESS'),
          paymentContent('DELIVERED'),
          paymentContent('REFUND'),
        ],
      ),
    );
  }

  Widget paymentContent(String orderStatusParam) {
    return Consumer<EcommerceProvider>(
      builder: (_, notifier, __) {
        if(notifier.listOrderStatus == ListOrderStatus.loading) {
          return const Center(
            child: SizedBox(
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator.adaptive()
            )
          );
        }
        if(notifier.listOrderStatus == ListOrderStatus.empty) {
          return Center(
            child: Text('Belum ada transaksi',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            )
          );
        }
        if(notifier.listOrderStatus == ListOrderStatus.error) {
          return Center(
            child: Text("Hmm... Mohon tunggu yaa",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            )
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () {
            return Future.sync(() {
              ep.listOrder(orderStatus: orderStatusParam);
            });
          },
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: 16.0,
              right: 16.0
            ),
            itemCount: notifier.orders.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0
                ),
                child: Card(
                  elevation: 0.30,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      NS.push(context, DetailOrder(transactionId: notifier.orders[i].transactionId));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    
                                    Text(notifier.orders[i].invoice,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: notifier.detailOrders[i].waybill));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(notifier.detailOrders[i].waybill,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault
                                            ),
                                          )),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.copy,
                                          size: 12.0,
                                        ),
                                      ),
                                    ) 

                                  ],
                                ),
                                
                                notifier.orders[i].expire == null 
                                ? const SizedBox() 
                                : notifier.orders[i].orderStatus == "WAITING_PAYMENT"
                                ? Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.countdown,
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: CountDownText(
                                      due: DateTime.parse(notifier.orders[i].expire),
                                      finishedText: "Kedaluwarsa",
                                      showLabel: false,
                                      longDateName: true,
                                      daysTextLong: " Hari ",
                                      hoursTextLong: " Jam ",
                                      minutesTextLong: " Menit ",
                                      secondsTextLong: " Detik ",
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeSmall
                                      ),
                                    ),
                                  )  
                                : const SizedBox()
                            
                              ],
                            ),
                          ),
                                        
                          const SizedBox(height: 15.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                             
                              Text(CurrencyHelper.formatCurrency(notifier.orders[i].totalPrice),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.purple
                                ),
                              )

                            ],
                          ),
                                        
                          const SizedBox(height: 10.0),
                                        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                        
                              Text(Helper.formatDate(notifier.orders[i].createdAt),
                                style: robotoRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.black,
                                ),
                              ),
                                        
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: ColorResources.purple,
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Text(orderStatus(notifier.orders[i].orderStatus),
                                  style: robotoRegular.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.white,
                                  ),
                                )
                              )
                                        
                            ],
                          )
                      
                        ],
                      ),
                    ),
                  )
                )
              );
            },
          ),
        );
      },
    );
  }

  String orderStatus(String val) {
    String orderStatus = "";

    switch (val) {
      case "REFUND":
        orderStatus = "Batal"; 
      break;
      case "WAITING_PAYMENT":
        orderStatus = "Belum bayar"; 
      break;
      case "PAID":
        orderStatus = "Dibayar"; 
      break;
      case "PACKING":
        orderStatus = "Dikemas"; 
      break;
      case "ON PROCESS": 
        orderStatus = "Dikirim";
      break;
      case "DELIVERED": 
        orderStatus = "Selesai";
      break;
      default:
    }

    return orderStatus;
  }
}