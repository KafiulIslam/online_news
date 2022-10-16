import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widgets/category_tile.dart';
import '../constant/image_path.dart';

class NewCategoryState extends GetxController{

  String _categoryName = 'general';
  String get categoryName => _categoryName;

  void changeCategory (){
    _categoryName = 'business';
    update();
  }

  List <CategoryTile> categories = [
    CategoryTile(
        categoryName: 'Business',
        imageUrl: business,
      onTap: (){
          print('one');
      },
    ),
    CategoryTile(
        categoryName: 'Entertainment',
        imageUrl: entertainment,
      onTap: (){
        print('2');
      },),
    CategoryTile(
        categoryName: 'General',
        imageUrl: generalNews,
      onTap: (){
        print('3');
      },),
    CategoryTile(
        categoryName: 'Health',
        imageUrl: health,
      onTap: (){
        print('4');
      },
    ),
    CategoryTile(
        categoryName: 'Science',
        imageUrl: science,
      onTap: (){
        print('5');
      },
    ),
    CategoryTile(
        categoryName: 'Sports',
        imageUrl: sports,
      onTap: (){
        print('6');
      },),
    CategoryTile(
        onTap: (){
          print('7');
        },
        categoryName: 'Technology',
        imageUrl: technology),
  ];

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