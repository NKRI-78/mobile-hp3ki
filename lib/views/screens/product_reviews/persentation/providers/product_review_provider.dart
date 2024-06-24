// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/product_reviews/data/product_review.dart';
import 'package:hp3ki/views/screens/product_reviews/domain/product_review_repository.dart';

class ProductReviewProvider with ChangeNotifier {
  final String productId;
  final ProductReviewRepository repo;

  List<ProductReviewModel> reviews = [];

  bool loading = true;

  ProductReviewProvider({
    required this.productId,
    required this.repo,
  });

  void fetchReviews() async {
    try {
      reviews = await repo.fetchReview(productId);
    } catch (e) {
      ///
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
