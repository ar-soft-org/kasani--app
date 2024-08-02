

import 'package:dio/dio.dart';
import 'package:products_api/products_api.dart';
import 'dart:convert';

class ProductService{

  const ProductService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;



  Future<List<FavoriteProduct>> fetchFavoriteProducts(FavoriteProductsRequest data) async {
    const path = 'http://108.174.198.156:4501/api/producto/favoritos';
    try{
      final response = await _dio.post(path, data: data.toJson());
      return favoriteProductFromJson(json.encode(response.data));
      
    } catch(e){
      throw Exception('Error al obtener los productos favoritos');
    }
  }



} 