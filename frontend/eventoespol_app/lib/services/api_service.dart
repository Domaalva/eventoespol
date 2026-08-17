import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/evento.dart';
import '../models/inscripcion.dart';
import '../models/notificacion.dart';

/// Servicio compartido: centraliza todas las llamadas HTTP a la API de
/// EventoESPOL (FastAPI). Cada ViewModel usa esta clase para leer/escribir
/// datos, sin conocer los detalles de la conexión HTTP.
///
/// NOTA: Usa /api/ que es interceptado por el servidor proxy frontend_server.py
/// que redirecciona a localhost:8000 internamente.
class ApiService {
  static const String baseUrl = "";

  // ---------- Eventos (Henry Olvera) ----------
  static Future<List<Evento>> getEventos({String? categoria}) async {
    final uri = Uri.parse("/api/eventos").replace(
      queryParameters: categoria != null ? {"categoria": categoria} : null,
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Error al cargar eventos: ${res.body}");
    }
    final List data = jsonDecode(utf8.decode(res.bodyBytes));
    return data.map((e) => Evento.fromJson(e)).toList();
  }

  static Future<Evento> crearEvento(Evento evento) async {
    final res = await http.post(
      Uri.parse("/api/eventos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(evento.toJson()),
    );
    if (res.statusCode != 201) {
      throw Exception("Error al crear evento: ${res.body}");
    }
    return Evento.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
  }

  // ---------- Inscripciones (Domenika Arboleda) ----------
  static Future<Inscripcion> inscribirse(int eventoId, String usuario) async {
    final res = await http.post(
      Uri.parse("/api/inscripciones"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"evento_id": eventoId, "usuario": usuario}),
    );
    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)["detail"] ?? "Error al inscribirse");
    }
    return Inscripcion.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
  }

  static Future<List<Inscripcion>> getMisInscripciones(String usuario) async {
    final res = await http.get(Uri.parse("/api/inscripciones/$usuario"));
    if (res.statusCode != 200) {
      throw Exception("Error al cargar inscripciones: ${res.body}");
    }
    final List data = jsonDecode(utf8.decode(res.bodyBytes));
    return data.map((e) => Inscripcion.fromJson(e)).toList();
  }

  // ---------- Notificaciones (Enrique Rosado) ----------
  static Future<List<Notificacion>> getNotificaciones(String usuario) async {
    final res = await http.get(Uri.parse("/api/notificaciones/$usuario"));
    if (res.statusCode != 200) {
      throw Exception("Error al cargar notificaciones: ${res.body}");
    }
    final List data = jsonDecode(utf8.decode(res.bodyBytes));
    return data.map((e) => Notificacion.fromJson(e)).toList();
  }

  static Future<Notificacion> generarNotificacion(
      String usuario, String mensaje, String tipo) async {
    final res = await http.post(
      Uri.parse("/api/notificaciones"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"usuario": usuario, "mensaje": mensaje, "tipo": tipo}),
    );
    if (res.statusCode != 201) {
      throw Exception("Error al generar notificación: ${res.body}");
    }
    return Notificacion.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
  }
}
