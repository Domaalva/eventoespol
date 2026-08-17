import 'package:flutter/foundation.dart';

/// Estado compartido muy simple: como el proyecto todavía no tiene login
/// (ver tabla de Implementación, sección "Pendiente"), aquí solo se guarda
/// el nombre de usuario que la persona escribe manualmente para probar la
/// app. Cuando se implemente autenticación real, este archivo se reemplaza.
class SessionViewModel extends ChangeNotifier {
  String usuario = "domenika.arboleda";

  void setUsuario(String value) {
    usuario = value;
    notifyListeners();
  }
}
