class OrderHistoryDetail {
    final String fechaEntrega;
    final String horaEntrega;
    final String lugarEntrega;
    final List<OrderDetail> detalle;

    OrderHistoryDetail({
        required this.fechaEntrega,
        required this.horaEntrega,
        required this.lugarEntrega,
        required this.detalle,
    });

    OrderHistoryDetail copyWith({
        String? fechaEntrega,
        String? horaEntrega,
        String? lugarEntrega,
        List<OrderDetail>? detalle,
    }) => 
        OrderHistoryDetail(
            fechaEntrega: fechaEntrega ?? this.fechaEntrega,
            horaEntrega: horaEntrega ?? this.horaEntrega,
            lugarEntrega: lugarEntrega ?? this.lugarEntrega,
            detalle: detalle ?? this.detalle,
        );

    factory OrderHistoryDetail.fromJson(Map<String, dynamic> json) => OrderHistoryDetail(
        fechaEntrega: json['fecha_entrega'],
        horaEntrega: json['hora_entrega'],
        lugarEntrega: json['lugar_entrega'],
        detalle: List<OrderDetail>.from(json['detalle'].map((x) => OrderDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'fecha_entrega': fechaEntrega,
        'hora_entrega': horaEntrega,
        'lugar_entrega': lugarEntrega,
        'detalle': List<dynamic>.from(detalle.map((x) => x.toJson())),
    };
}

class OrderDetail {
    final String idProducto;
    final String codigoProducto;
    final String nombreProducto;
    final String cantidad;
    final String unidadMedida;
    final String stock;
    final String observacion;

    OrderDetail({
        required this.idProducto,
        required this.codigoProducto,
        required this.nombreProducto,
        required this.cantidad,
        required this.unidadMedida,
        required this.stock,
        required this.observacion,
    });

    OrderDetail copyWith({
        String? idProducto,
        String? codigoProducto,
        String? nombreProducto,
        String? cantidad,
        String? unidadMedida,
        String? stock,
        String? observacion,
    }) => 
        OrderDetail(
            idProducto: idProducto ?? this.idProducto,
            codigoProducto: codigoProducto ?? this.codigoProducto,
            nombreProducto: nombreProducto ?? this.nombreProducto,
            cantidad: cantidad ?? this.cantidad,
            unidadMedida: unidadMedida ?? this.unidadMedida,
            stock: stock ?? this.stock,
            observacion: observacion ?? this.observacion,
        );

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        idProducto: json['id_producto'],
        codigoProducto: json['codigo_producto'],
        nombreProducto: json['nombre_producto'],
        cantidad: json['cantidad'],
        unidadMedida: json['unidad_medida'],
        stock: json['stock'],
        observacion: json['observacion'],
    );

    Map<String, dynamic> toJson() => {
        'id_producto': idProducto,
        'codigo_producto': codigoProducto,
        'nombre_producto': nombreProducto,
        'cantidad': cantidad,
        'unidad_medida': unidadMedida,
        'stock': stock,
        'observacion': observacion,
    };
}
