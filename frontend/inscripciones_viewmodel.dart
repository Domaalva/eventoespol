import 'package:flutter/foundation.dart';
import '../models/evento.dart';
import '../models/inscripcion.dart';
import '../services/api_service.dart';

/// Responsable: Domenika Arboleda
/// Maneja el estado de "Mis inscripciones": ver el historial (lectura) e
/// inscribirse a un evento (escritura), validando cupo desde el backend.
class InscripcionesViewModel extends ChangeNotifier {
  List<Inscripcion> misInscripciones = [];
  List<Evento> eventosDisponibles = [];
  bool cargando = false;
  String? error;
  String? mensajeExito;

  Future<void> cargarMisInscripciones(String usuario) async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      misInscripciones = await ApiService.getMisInscripciones(usuario);
      eventosDisponibles = await ApiService.getEventos();
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> inscribirse(int eventoId, String usuario) async {
    error = null;
    mensajeExito = null;
    try {
      await ApiService.inscribirse(eventoId, usuario);
      mensajeExito = "¡Inscripción confirmada!";
      await cargarMisInscripciones(usuario);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
}
