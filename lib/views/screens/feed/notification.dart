// import 'package:timeago/timeago.dart' as timeago;

// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:hp3ki/services/navigation.dart';

// import 'package:hp3ki/utils/dimensions.dart';
// import 'package:hp3ki/utils/color_resources.dart';
// import 'package:hp3ki/utils/constant.dart';
// import 'package:hp3ki/utils/custom_themes.dart';

// import 'package:hp3ki/views/screens/feed/reply_detail.dart';

// import 'package:hp3ki/data/models/feed/notification.dart';

// import 'package:hp3ki/localization/language_constraints.dart';

// import 'package:hp3ki/providers/feed/feed.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key}) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {


//   Future<void> getData() async {
//     if(mounted) {
//       // context.read<FeedProvider>().fetchAllNotification(context); 
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     getData();
//   }

//   @override 
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildUI();
//   }

//   Widget buildUI() {
//     return Scaffold(
      
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
//           return [
//             buildAppBar(context),
//           ];
//         },
//         body: buildBodyContent()
//       ),
//     );
//   }

//   SliverAppBar buildAppBar(BuildContext context) {
//     return SliverAppBar(
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//             backgroundColor: ColorResources.white,
//             title: Text(getTranslated("NOTIFICATION", context), 
//               style: poppinsRegular.copyWith(
//                 color: ColorResources.black,
//                 fontSize: Dimensions.fontSizeLarge,
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//             elevation: 0.0,
//             pinned: false,
//             centerTitle: true,
//             floating: true,
//             leading: Padding(
//               padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
//               child: IconButton(
//                 onPressed: () {
//                   NS.pop(context);
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   size: Dimensions.iconSizeExtraLarge,
//                   color: ColorResources.black,
//                 )
//               ),
//             ),
//           );
//   }

//   Consumer<FeedProvider> buildBodyContent() {
//     return Consumer<FeedProvider>(
//         builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
//           if (feedProvider.notificationStatus == NotificationStatus.loading) {
//             return const Center(
//               child: SpinKitThreeBounce(
//                 size: 20.0,
//                 color: ColorResources.primary
//               )
//             );
//           }
//           if(feedProvider.notificationStatus == NotificationStatus.empty) {
//             return Center(
//               child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context), 
//                 style: poppinsRegular
//               )
//             );
//           }
//           return NotificationListener<ScrollNotification>(
//             child: ListView.separated(
//               separatorBuilder: (BuildContext context, int i) {
//                 return Container(
//                   color: Colors.blueGrey[50],
//                   height: 20.0,
//                 );
//               },
//               physics: const BouncingScrollPhysics(),
//               itemCount: feedProvider.notification.nextCursor != null
//               ? feedProvider.notificationList.length + 1
//               : feedProvider.notificationList.length,
//               itemBuilder: (BuildContext context, int i) {
//                 if (feedProvider.notificationList.length == i) {
//                   return const Center(
//                     child: SpinKitThreeBounce(
//                       size: 20.0,
//                       color: ColorResources.primary
//                     )
//                   );
//                 }
//                 return InkWell(
//                   onTap: () {
//                     if (feedProvider.notificationList[i].targetType == TargetType.reply) {
//                       Navigator.push(context,
//                         MaterialPageRoute(
//                           builder: (context) => ReplyDetailScreen(
//                             replyId: feedProvider.notificationList[i].targetId!,
//                           ),
//                         ),
//                       );
//                     }
//                     if (feedProvider.notificationList[i].targetType == TargetType.comment) {
//                       // Navigator.push(context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => CommentDetailScreen(
//                       //        postId: "",
//                       //        commentId: feedProvider.notificationList[i].targetId!,
//                       //      ),
//                       //   ),
//                       // );
//                     }
//                     if (feedProvider.notificationList[i].targetType == TargetType.post) {
//                       //FIXME:
//                       // Navigator.push(context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => PostDetailScreen(
//                       //       postId: feedProvider.notificationList[i].targetId!,
//                       //     ),
//                       //   ),
//                       // );
//                     }
//                   },
//                   child: ListTile(
//                     dense: true,
//                     leading: CircleAvatar(
//                       backgroundColor: ColorResources.black,
//                       backgroundImage: NetworkImage("${AppConstants.baseUrlImg}/${feedProvider.notificationList[i].refUser!.profilePic!.path}"),
//                       radius: 20.0,
//                     ),
//                     title: Text(
//                       feedProvider.notificationList[i].message!,
//                       style: robotoRegular.copyWith(
//                         fontSize: Dimensions.fontSizeDefault
//                       ),
//                     ),
//                     subtitle: Text(
//                       timeago.format(DateTime.parse(feedProvider.notificationList[i].created!).toLocal(),locale: getTranslated('LOCALE', context)),
//                       style: robotoRegular.copyWith(
//                         fontSize: Dimensions.fontSizeDefault
//                       )
//                     ),
//                   ),
//                 );
//               },
//             ),
//             onNotification: (ScrollNotification scrollInfo) {
//               if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//                 //FIXME:
//                 // if (feedProvider.notification.nextCursor != null) {
//                 //   feedProvider.fetchAllNotificationLoad(context, feedProvider.notification.nextCursor!);
//                 // }
//               }
//               return false;
//             },
//           );
//         },
//       );
//   }
// }