import 'package:flutter/foundation.dart';

import '../models/evento.dart';
import '../services/api_service.dart';

/// Responsable: Henry Olvera
/// Maneja el catálogo de eventos y la creación de nuevos eventos.
class EventosViewModel extends ChangeNotifier {
  List<Evento> eventos = [];
  List<String> categorias = [];
  bool cargando = false;
  String? error;
  String? mensajeExito;
  String categoriaSeleccionada = "Todas";

  Future<void> cargarEventos({String? categoria}) async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      final categoriaFiltro =
          categoria != null && categoria != "Todas" ? categoria : null;

      eventos = await ApiService.getEventos(categoria: categoriaFiltro);

      categorias = [
        "Todas",
        ...{for (final evento in eventos) evento.categoria}
      ];

      if (!categorias.contains(categoriaSeleccionada)) {
        categoriaSeleccionada = "Todas";
      }
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> crearEvento(Evento evento) async {
    error = null;
    mensajeExito = null;

    try {
      await ApiService.crearEvento(evento);
      mensajeExito = "Evento creado correctamente";
      await cargarEventos(categoria: categoriaSeleccionada == "Todas" ? null : categoriaSeleccionada);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
}
