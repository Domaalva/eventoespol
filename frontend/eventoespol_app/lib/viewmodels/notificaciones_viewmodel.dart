import 'package:flutter/foundation.dart';

import '../models/notificacion.dart';
import '../services/api_service.dart';

/// Maneja el estado de la pantalla de Notificaciones.
///
/// Funcionalidades:
/// - Consultar notificaciones de un usuario.
/// - Generar una notificación de prueba.
/// - Mostrar estados de carga, error y éxito.
class NotificacionesViewModel extends ChangeNotifier {
  List<Notificacion> notificaciones = [];

  bool cargando = false;
  String? error;
  String? mensajeExito;

  Future<void> cargarNotificaciones(String usuario) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      notificaciones = await ApiService.getNotificaciones(usuario);
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> generarNotificacion(
    String usuario,
    String mensaje,
    String tipo,
  ) async {
    error = null;
    mensajeExito = null;

    try {
      await ApiService.generarNotificacion(
        usuario,
        mensaje,
        tipo,
      );

      mensajeExito = "Notificación generada correctamente";

      await cargarNotificaciones(usuario);

      return true;
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
}
