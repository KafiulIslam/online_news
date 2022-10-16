import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ArticleState extends GetxController{

  final TextEditingController controller = TextEditingController();
    String _searchController = 'us';
    String get searchController => _searchController;

    changeLocation ( String value){
  _searchController = value;
  update();
  }

  String _categoryName = 'general';
  String get categoryName => _categoryName;

  void changeCategory (){
    _categoryName = 'business';
    update();
  }


  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;
  void modeToggle (){
    _isDarkMode = !_isDarkMode;
    var index = 0;
    if (!_isDarkMode) {
      index = 1;
    }
    update();
  }

  bool isLoading = false;
  void getCircular (){
    isLoading = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading = false;
    });
  }

}