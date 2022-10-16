import 'package:dio/dio.dart';
import 'news_dio.dart';

Future<Map<String, dynamic>> getTopHeadLines(String country, String categoryName) async {
  try {
    var response = await dio.get('top-headlines?country=$country&category=$categoryName&apiKey=c4f5f082fb13483f87ebf13c7fb69b6d');
     return {'status': 'success', 'data': response.data};
  } on DioError catch (e) {
    return getErrorResponse(e);
  }
}