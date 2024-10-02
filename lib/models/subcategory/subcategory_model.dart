class SubCategoria {
  final String idSubCategoria;
  final String nombreSubCategoria;
  final String imagenSubCategoria;

  SubCategoria({
    required this.idSubCategoria,
    required this.nombreSubCategoria,
    required this.imagenSubCategoria,
  });

  SubCategoria copyWith({
    String? idSubCategoria,
    String? nombreSubCategoria,
    String? imagenSubCategoria,
  }) =>
      SubCategoria(
        idSubCategoria: idSubCategoria ?? this.idSubCategoria,
        nombreSubCategoria: nombreSubCategoria ?? this.nombreSubCategoria,
        imagenSubCategoria: imagenSubCategoria ?? this.imagenSubCategoria,
      );

  factory SubCategoria.fromJson(Map<String, dynamic> json) => SubCategoria(
        idSubCategoria: json["id_sub_categoria"],
        nombreSubCategoria: json["nombre_sub_categoria"],
        imagenSubCategoria: json["imagen_sub_categoria"],
      );

  Map<String, dynamic> toJson() => {
        "id_sub_categoria": idSubCategoria,
        "nombre_sub_categoria": nombreSubCategoria,
        "imagen_sub_categoria": imagenSubCategoria,
      };
}
