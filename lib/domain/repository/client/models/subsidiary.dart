
class Subsidiary {
  final String idLocal;
  final String nombreLocal;
  final String direccionLocal;
  final String horaEntrega;

  Subsidiary({
    required this.idLocal,
    required this.nombreLocal,
    required this.direccionLocal,
    required this.horaEntrega,
  });

  Subsidiary copyWith({
    String? idLocal,
    String? nombreLocal,
    String? direccionLocal,
    String? horaEntrega,
  }) =>
      Subsidiary(
        idLocal: idLocal ?? this.idLocal,
        nombreLocal: nombreLocal ?? this.nombreLocal,
        direccionLocal: direccionLocal ?? this.direccionLocal,
        horaEntrega: horaEntrega ?? this.horaEntrega,
      );

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
        idLocal: json['id_local'],
        nombreLocal: json['nombre_local'],
        direccionLocal: json['direccion_local'],
        horaEntrega: json['hora_entrega'],
      );

  Map<String, dynamic> toJson() => {
        'id_local': idLocal,
        'nombre_local': nombreLocal,
        'direccion_local': direccionLocal,
        'hora_entrega': horaEntrega,
      };
}
