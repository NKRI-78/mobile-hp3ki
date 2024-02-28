// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/product_reviews/domain/product_review_repository.dart';
import 'package:hp3ki/views/screens/product_reviews/persentation/providers/product_review_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductReviewsPage extends StatelessWidget {
  const ProductReviewsPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  static Route go(String productId) => MaterialPageRoute(
      builder: (_) => ProductReviewsPage(productId: productId));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ProductReviewProvider>(
        create: (_) => ProductReviewProvider(
          productId: productId,
          repo: ProductReviewRepository(
            client: DioManager.shared.getClient(),
          ),
        )..fetchReviews(),
      )
    ], child: const ProductReviewsView());
  }
}

class ProductReviewsView extends StatelessWidget {
  const ProductReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body:
          Consumer<ProductReviewProvider>(builder: (context, notifier, child) {
        if (notifier.loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (notifier.reviews.isEmpty) {
          return const Center(
            child: Text('No Reviews'),
          );
        }
        return SizedBox.expand(
          child: ListView(
            children: List.generate(notifier.reviews.length, (index) {
              final review = notifier.reviews[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              width: 44,
                              height: 44,
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                review.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    DateFormat().format(review.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: double.parse(review.rating),
                                    itemSize: 20,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      ///
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Text(review.caption),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: List.generate(review.reviewPictures.length,
                              (index) {
                            final picture = review.reviewPictures[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 6.0, bottom: 16),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ShowImageFull(avatar: picture)));
                                },
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ),
                                  ),
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                    picture,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      )),
                  Divider(
                    height: 3,
                    thickness: 6,
                    color: Colors.grey.shade200,
                  )
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}

class ShowImageFull extends StatelessWidget {
  const ShowImageFull({
    Key? key,
    required this.avatar,
  }) : super(key: key);
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          avatar,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
