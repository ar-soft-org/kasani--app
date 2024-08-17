import 'package:products_api/products_api.dart';

class ProductData {
  final String productId;
  final double quantity;
  final double price;
  final String observation;

  ProductData({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.observation,
  });

  static ProductData initialValue(String productId, String price) {
    return ProductData(
      productId: productId,
      quantity: 0,
      price: num.parse(price).toDouble(),
      observation: '',
    );
  }

  ProductData copyWith({
    String? productId,
    double? quantity,
    double? price,
    String? observation,
  }) =>
      ProductData(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        observation: observation ?? this.observation,
      );

  factory ProductData.fromJson(JsonMap json) => ProductData(
        productId: json['id_producto'],
        quantity: num.parse(json['cantidad']).toDouble(),
        price: num.parse(json['precio']).toDouble(),
        observation: json['observacion'] != null ? json['observacion'] : '',
      );

  JsonMap toJson() => {
        'id_producto': productId,
        'cantidad': quantity.toString(),
        'precio': price.toString(),
        'observacion': observation,
      };

  bool get greaterThanZero => quantity > 0;

  bool get hasNotQuantity => quantity == 0;
}
