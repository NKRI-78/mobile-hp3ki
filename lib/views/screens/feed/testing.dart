import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:hp3ki/providers/feedv2/feedDetail.dart';

class TestingScreen extends StatefulWidget {
  final dynamic data;
  final String from;
  const TestingScreen({
    required this.data,
    required this.from,
    super.key
  });

  @override
  State<TestingScreen> createState() => TestingScreenState();
}

class TestingScreenState extends State<TestingScreen> {

  Future<void> getData() async {
    if(!mounted) return;
      await context.read<FeedDetailProviderV2>().getFeedDetail(context, widget.data["forum_id"]);
  }

  @override 
  void initState() {
    super.initState();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FeedDetailProviderV2>(
        builder: (BuildContext context, FeedDetailProviderV2 notifier, Widget? child) {
          
          if(notifier.feedDetailStatus == FeedDetailStatus.loading) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }

          if(notifier.feedDetailStatus == FeedDetailStatus.error) {
            return const Center(
              child: Text("Oops there was problem")
            );
          }

          return Center(
            child: Text("from (${widget.from}) - ${notifier.feedDetailData.forum!.comment!.comments.toString()}")
          );

        },
      )
    );
  }
}