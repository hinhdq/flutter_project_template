import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../models/issue_model.dart';

class ReadingStateManager extends ChangeNotifier {
  static final ReadingStateManager _instance = ReadingStateManager._internal();
  factory ReadingStateManager() => _instance;
  ReadingStateManager._internal();

  ArticleModel? _currentArticle;
  IssueModel? _currentIssue;
  bool _isVisible = false;
  bool _isBarHidden = false;

  ArticleModel? get currentArticle => _currentArticle;
  IssueModel? get currentIssue => _currentIssue;
  bool get isVisible => _isVisible && !_isBarHidden;
  int get currentPage => _currentPage;

  int _currentPage = 0;

  void show(ArticleModel article, [IssueModel? issue]) {
    _currentArticle = article;
    if (issue != null) {
      _currentIssue = issue;
    }

    _currentPage = 0;
    _isVisible = true;
    _isBarHidden = false; // Reset
    notifyListeners();
  }

  void updatePage(int page) {
    _currentPage = page;
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  void hideBar() {
    _isBarHidden = true;
    notifyListeners();
  }

  void showBar() {
    _isBarHidden = false;
    notifyListeners();
  }

  void updateArticle(ArticleModel article) {
    _currentArticle = article;
    notifyListeners();
  }
}
