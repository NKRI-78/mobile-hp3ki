import 'package:flutter/material.dart';

class GeneralModal {
  static Future<void> error(BuildContext context,
      {required String msg, Widget? topContent, Function? onOk}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
            width: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                topContent ?? const SizedBox.shrink(),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        if (onOk == null) {
                          Navigator.pop(context);
                        } else {
                          onOk.call();
                        }
                      },
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          )),
        );
      },
    );
  }

  static Future<void> confirm(BuildContext context,
      {required String title, required String msg, Function? onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                      color: Color(0xfff7f7f7),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/avatar/avatar-fulfill.png',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff417baa),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                    8,
                                  ))),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Tidak',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor: context.getCurrentTheme,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                    8,
                                  ))),
                                  onPressed: () {
                                    if (onConfirm == null) {
                                      Navigator.pop(context);
                                    } else {
                                      onConfirm.call();
                                    }
                                  },
                                  child: const Text(
                                    'YA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
