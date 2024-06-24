import 'package:flutter/material.dart';

class LoadingModalWidget extends StatefulWidget {
  const LoadingModalWidget({super.key, this.onInit});
  final Function(BuildContext ctx)? onInit;

  static show(BuildContext context,
      {Function(BuildContext ctx)? onInit}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return LoadingModalWidget(
            onInit: onInit,
          );
        });
  }

  @override
  State<LoadingModalWidget> createState() => _LoadingModalWidgetState();
}

class _LoadingModalWidgetState extends State<LoadingModalWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onInit?.call(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      ),
    );
  }
}
