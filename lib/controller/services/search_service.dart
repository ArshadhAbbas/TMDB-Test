import 'package:flutter/material.dart';

class SearchService extends ChangeNotifier
{
  String query='';
  void changeQuery(String searchQuery)
  {
    query=searchQuery;
    notifyListeners();
  }
}