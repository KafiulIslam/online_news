import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widgets/category_tile.dart';
import '../constant/image_path.dart';

class NewsCategoryState extends GetxController{

  String _categoryName = 'general';
  String get categoryName => _categoryName;

  void changeCategory (int paramIndex){
    if(paramIndex == 0){
      _categoryName = 'business';
      update();
    } else if(paramIndex == 1){
      _categoryName = 'entertainment';
      update();
    }else if(paramIndex == 2){
      _categoryName = 'general';
      update();
    }else if(paramIndex == 3){
      _categoryName = 'health';
      update();
    }else if(paramIndex == 4){
      _categoryName = 'science';
      update();
    }else if(paramIndex == 5){
      _categoryName = 'sports';
      update();
    }else{
      _categoryName = 'technology';
      update();
    }
  }

  List <CategoryTile> categories = const [
    CategoryTile(
        categoryName: 'Business',
        imageUrl: business,
    ),
    CategoryTile(
        categoryName: 'Entertainment',
        imageUrl: entertainment,
    ),
    CategoryTile(
        categoryName: 'General',
        imageUrl: generalNews,
    ),
    CategoryTile(
        categoryName: 'Health',
        imageUrl: health,
    ),
    CategoryTile(
        categoryName: 'Science',
        imageUrl: science,
    ),
    CategoryTile(
        categoryName: 'Sports',
        imageUrl: sports,
    ),
    CategoryTile(
        categoryName: 'Technology',
        imageUrl: technology),
  ];

  bool isLoading = false;
  void getCircular (){
    isLoading = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading = false;
    });
  }

}