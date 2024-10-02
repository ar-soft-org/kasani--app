import 'dart:convert';

import 'package:kasanipedido/models/subcategory/subcategory_model.dart';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  final String idCategoria;
  final String nombreCategoria;
  final String imagenCategoria;
  final List<SubCategoria> subCategorias;

  CategoryModel({
    required this.idCategoria,
    required this.nombreCategoria,
    required this.imagenCategoria,
    required this.subCategorias,
  });

  CategoryModel copyWith({
    String? idCategoria,
    String? nombreCategoria,
    String? imagenCategoria,
    List<SubCategoria>? subCategorias,
  }) =>
      CategoryModel(
        idCategoria: idCategoria ?? this.idCategoria,
        nombreCategoria: nombreCategoria ?? this.nombreCategoria,
        imagenCategoria: imagenCategoria ?? this.imagenCategoria,
        subCategorias: subCategorias ?? this.subCategorias,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        idCategoria: json["id_categoria"],
        nombreCategoria: json["nombre_categoria"],
        imagenCategoria: json["imagen_categoria"],
        subCategorias: List<SubCategoria>.from(
            json["sub_categorias"].map((x) => SubCategoria.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_categoria": idCategoria,
        "nombre_categoria": nombreCategoria,
        "imagen_categoria": imagenCategoria,
        "sub_categorias":
            List<dynamic>.from(subCategorias.map((x) => x.toJson())),
      };
}
