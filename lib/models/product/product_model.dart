import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final String idProducto;
  final String nombreProducto;
  final String unidadMedida;
  final String categoria;
  final String subCategoria;
  final String descripcionProducto;
  final String stock;
  final String precio;

  ProductModel({
    required this.idProducto,
    required this.nombreProducto,
    required this.unidadMedida,
    required this.categoria,
    required this.subCategoria,
    required this.descripcionProducto,
    required this.stock,
    required this.precio,
  });

  ProductModel copyWith({
    String? idProducto,
    String? nombreProducto,
    String? unidadMedida,
    String? categoria,
    String? subCategoria,
    String? descripcionProducto,
    String? stock,
    String? precio,
  }) =>
      ProductModel(
        idProducto: idProducto ?? this.idProducto,
        nombreProducto: nombreProducto ?? this.nombreProducto,
        unidadMedida: unidadMedida ?? this.unidadMedida,
        categoria: categoria ?? this.categoria,
        subCategoria: subCategoria ?? this.subCategoria,
        descripcionProducto: descripcionProducto ?? this.descripcionProducto,
        stock: stock ?? this.stock,
        precio: precio ?? this.precio,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        idProducto: json["id_producto"],
        nombreProducto: json["nombre_producto"],
        unidadMedida: json["unidad_medida"],
        categoria: json["categoria"],
        subCategoria: json["sub_categoria"],
        descripcionProducto: json["descripcion_producto"],
        stock: json["stock"],
        precio: json["precio"],
      );

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "nombre_producto": nombreProducto,
        "unidad_medida": unidadMedida,
        "categoria": categoria,
        "sub_categoria": subCategoria,
        "descripcion_producto": descripcionProducto,
        "stock": stock,
        "precio": precio,
      };
}
