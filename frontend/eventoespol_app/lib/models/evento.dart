class Evento {
  final int id;
  final String titulo;
  final String? descripcion;
  final String fecha;
  final String ubicacion;
  final String categoria;
  final int cupoMaximo;
  final int cupoDisponible;

  Evento({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.categoria,
    required this.cupoMaximo,
    required this.cupoDisponible,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      ubicacion: json['ubicacion'],
      categoria: json['categoria'],
      cupoMaximo: json['cupo_maximo'],
      cupoDisponible: json['cupo_disponible'],
    );
  }

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "descripcion": descripcion,
        "fecha": fecha,
        "ubicacion": ubicacion,
        "categoria": categoria,
        "cupo_maximo": cupoMaximo,
      };
}
