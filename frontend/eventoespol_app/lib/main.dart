import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/session_viewmodel.dart';
import 'viewmodels/eventos_viewmodel.dart';
import 'viewmodels/inscripciones_viewmodel.dart';
import 'viewmodels/notificaciones_viewmodel.dart';

import 'views/eventos_screen.dart';
import 'views/inscripciones_screen.dart';
import 'views/notificaciones_screen.dart';

void main() {
  runApp(const EventoEspolApp());
}

class EventoEspolApp extends StatelessWidget {
  const EventoEspolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
        ChangeNotifierProvider(create: (_) => EventosViewModel()),
        ChangeNotifierProvider(create: (_) => InscripcionesViewModel()),
        ChangeNotifierProvider(create: (_) => NotificacionesViewModel()),
      ],
      child: MaterialApp(
        title: 'EventoESPOL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1F3864),
          useMaterial3: true,
        ),
        home: const HomeShell(),
      ),
    );
  }
}

/// Contenedor con navegación inferior entre los 3 módulos del equipo.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indiceActual = 0;

  final _pantallas = const [
    EventosScreen(),
    InscripcionesScreen(),
    NotificacionesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indiceActual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual,
        onDestinationSelected: (i) => setState(() => _indiceActual = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: "Eventos"),
          NavigationDestination(icon: Icon(Icons.assignment_turned_in), label: "Inscripciones"),
          NavigationDestination(icon: Icon(Icons.notifications), label: "Notificaciones"),
        ],
      ),
    );
  }
}
