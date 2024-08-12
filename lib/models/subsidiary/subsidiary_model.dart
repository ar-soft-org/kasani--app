// import 'package:equatable/equatable.dart';

// class SubsidiaryModel extends Equatable {
//   final String idLocal;
//   final String nombreLocal;
//   final String direccionLocal;
//   final String horaEntrega;

//   const SubsidiaryModel({
//     required this.idLocal,
//     required this.nombreLocal,
//     required this.direccionLocal,
//     required this.horaEntrega,
//   });

//   SubsidiaryModel copyWith({
//     String? idLocal,
//     String? nombreLocal,
//     String? direccionLocal,
//     String? horaEntrega,
//   }) =>
//       SubsidiaryModel(
//         idLocal: idLocal ?? this.idLocal,
//         nombreLocal: nombreLocal ?? this.nombreLocal,
//         direccionLocal: direccionLocal ?? this.direccionLocal,
//         horaEntrega: horaEntrega ?? this.horaEntrega,
//       );

//   factory SubsidiaryModel.fromJson(Map<String, dynamic> json) =>
//       SubsidiaryModel(
//         idLocal: json['id_local'],
//         nombreLocal: json['nombre_local'],
//         direccionLocal: json['direccion_local'],
//         horaEntrega: json['hora_entrega'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id_local': idLocal,
//         'nombre_local': nombreLocal,
//         'direccion_local': direccionLocal,
//         'hora_entrega': horaEntrega,
//       };

//   @override
//   List<Object?> get props => [
//         idLocal,
//         nombreLocal,
//         direccionLocal,
//         horaEntrega,
//       ];
// }
