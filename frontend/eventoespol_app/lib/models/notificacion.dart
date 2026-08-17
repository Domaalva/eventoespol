class Notificacion {
  final int id;
  final String usuario;
  final String mensaje;
  final String tipo;
  final String fecha;
  final int leido;

  Notificacion({
    required this.id,
    required this.usuario,
    required this.mensaje,
    required this.tipo,
    required this.fecha,
    required this.leido,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'],
      usuario: json['usuario'],
      mensaje: json['mensaje'],
      tipo: json['tipo'],
      fecha: json['fecha'],
      leido: json['leido'],
    );
  }
}
