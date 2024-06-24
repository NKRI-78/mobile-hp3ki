import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/payment_method/data/payment_method_model.dart';

class SelectPaymentOptionWidget extends StatefulWidget {
  const SelectPaymentOptionWidget({super.key});

  static Future<PaymentMethodModel?> showDialog(BuildContext context) {
    return showModalBottomSheet<PaymentMethodModel?>(
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (_) => const SelectPaymentOptionWidget(),
    );
  }

  @override
  State<SelectPaymentOptionWidget> createState() =>
      _SelectPaymentOptionWidgetState();
}

class _SelectPaymentOptionWidgetState extends State<SelectPaymentOptionWidget> {
  List<PaymentMethodModel> list = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  void init() async {
    try {
      final client = DioManager.shared.getClient();
      Response res =
          await client.get("${AppConstants.baseUrl}/api/v1/payment/channel2");
      list = (res.data['data'] as List)
          .map((e) => PaymentMethodModel.fromJson(e))
          .toList();
      setState(() {});
    } catch (e) {
      ///
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(list.length, (index) {
            final payment = list[index];
            return Column(
              children: [
                ListTile(
                  onTap: payment.status == 0
                      ? null
                      : () {
                          Navigator.pop(context, payment);
                        },
                  leading: Container(
                    foregroundDecoration: payment.status == 0
                        ? const BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                        : null,
                    child: Image.network(
                      payment.paymentLogo,
                      width: 60,
                    ),
                  ),
                  title: Text(
                    payment.name,
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            payment.status == 0 ? Colors.grey.shade500 : null),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: payment.status == 0 ? Colors.grey.shade500 : null,
                  ),
                ),
                const Divider(
                  height: 1,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
