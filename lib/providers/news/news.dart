import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/news/news.dart';
import 'package:hp3ki/data/models/news/single_news.dart';
import 'package:hp3ki/data/repository/news/news.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/views/screens/news/detail.dart';

enum NewsStatus { idle, loading, loaded, error, empty }
enum NewsDetailStatus { idle, loading, loaded, error, empty }

class NewsProvider with ChangeNotifier {
  final NewsRepo nr;

  NewsProvider({
    required this.nr
  });

  NewsStatus _newsStatus = NewsStatus.loading;
  NewsStatus get newsStatus => _newsStatus;

  NewsDetailStatus _newsDetailStatus = NewsDetailStatus.loading;
  NewsDetailStatus get newsDetailStatus => _newsDetailStatus;

  List<NewsData>? _news = [];
  List<NewsData>? get news => _news;

  SingleNewsData? _newsDetail;
  SingleNewsData? get newsDetail => _newsDetail; 

  void setStateNewsStatus(NewsStatus newsStatus) {
    _newsStatus = newsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateNewsDetailStatus(NewsDetailStatus newsDetailStatus) {
    _newsDetailStatus = newsDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<List<NewsData>> getNews(BuildContext context) async {
    setStateNewsStatus(NewsStatus.loading);
    try {   
      _news = [];
      NewsModel? nm = await nr.getNews();
      if(nm!.data!.isNotEmpty) {
        _news!.addAll(nm.data!);
        setStateNewsStatus(NewsStatus.loaded);
      } else {
        setStateNewsStatus(NewsStatus.empty);
      }
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateNewsStatus(NewsStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateNewsStatus(NewsStatus.error);
    }
    return [];
  }

  Future<void> getNewsDetail(BuildContext context, {required String newsId}) async {
    setStateNewsDetailStatus(NewsDetailStatus.loading);
    try {   
      SingleNewsModel? snm = await nr.getNewsDetail(newsId: newsId);
      _newsDetail = snm!.data!;
      NS.push(context, const DetailNewsScreen());
      setStateNewsDetailStatus(NewsDetailStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateNewsDetailStatus(NewsDetailStatus.error);
    }catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateNewsDetailStatus(NewsDetailStatus.error);
    }
  }
}