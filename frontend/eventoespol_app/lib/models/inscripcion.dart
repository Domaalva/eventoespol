class Inscripcion {
  final int id;
  final int eventoId;
  final String usuario;
  final String estado;
  final String fechaInscripcion;

  Inscripcion({
    required this.id,
    required this.eventoId,
    required this.usuario,
    required this.estado,
    required this.fechaInscripcion,
  });

  factory Inscripcion.fromJson(Map<String, dynamic> json) {
    return Inscripcion(
      id: json['id'],
      eventoId: json['evento_id'],
      usuario: json['usuario'],
      estado: json['estado'],
      fechaInscripcion: json['fecha_inscripcion'],
    );
  }
}
