import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:products_api/products_api.dart';

class ProductService {
  const ProductService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<List<Product>> fetchFavoriteProducts(
      FavoriteProductsRequest data) async {
    final path = KasaniEndpoints.favoriteProducts;
    try {
      final response = await _dio.post(path, data: data.toJson());
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener los productos favoritos');
    }
  }
}
