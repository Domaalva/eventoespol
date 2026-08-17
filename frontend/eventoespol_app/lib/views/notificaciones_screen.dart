import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/notificacion.dart';
import '../viewmodels/notificaciones_viewmodel.dart';
import '../viewmodels/session_viewmodel.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState
    extends State<NotificacionesScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarNotificaciones();
    });
  }

  Future<void> _cargarNotificaciones() async {
    final usuario =
        context.read<SessionViewModel>().usuario;

    await context
        .read<NotificacionesViewModel>()
        .cargarNotificaciones(usuario);
  }

  Future<void> _cambiarUsuario() async {
    final session = context.read<SessionViewModel>();

    final controller =
        TextEditingController(text: session.usuario);

    final nuevoUsuario =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Usuario de prueba"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Usuario",
              hintText: "enrique@espol.edu.ec",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final usuario =
                    controller.text.trim();

                if (usuario.isNotEmpty) {
                  Navigator.pop(
                    dialogContext,
                    usuario,
                  );
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted || nuevoUsuario == null) {
      return;
    }

    session.setUsuario(nuevoUsuario);

    await context
        .read<NotificacionesViewModel>()
        .cargarNotificaciones(nuevoUsuario);
  }

  Future<void> _crearNotificacionPrueba() async {
    final mensajeController =
        TextEditingController(
      text: "Se creó un nuevo evento en EventoESPOL",
    );

    String tipoSeleccionado = "info";

    final resultado =
        await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogContext,
            setStateDialog,
          ) {
            return AlertDialog(
              title: const Text(
                "Generar notificación",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller:
                        mensajeController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(
                      labelText: "Mensaje",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tipoSeleccionado,
                    decoration:
                        const InputDecoration(
                      labelText: "Tipo",
                      border:
                          OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "info",
                        child:
                            Text("Información"),
                      ),
                      DropdownMenuItem(
                        value: "recordatorio",
                        child:
                            Text("Recordatorio"),
                      ),
                      DropdownMenuItem(
                        value: "cambio",
                        child:
                            Text("Cambio"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setStateDialog(() {
                          tipoSeleccionado =
                              value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final mensaje =
                        mensajeController.text
                            .trim();

                    if (mensaje.isEmpty) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      {
                        "mensaje": mensaje,
                        "tipo":
                            tipoSeleccionado,
                      },
                    );
                  },
                  child:
                      const Text("Generar"),
                ),
              ],
            );
          },
        );
      },
    );

    mensajeController.dispose();

    if (!mounted || resultado == null) {
      return;
    }

    final usuario =
        context.read<SessionViewModel>().usuario;

    final vm =
        context.read<NotificacionesViewModel>();

    final ok =
        await vm.generarNotificacion(
      usuario,
      resultado["mensaje"]!,
      resultado["tipo"]!,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? vm.mensajeExito ??
                  "Notificación generada"
              : vm.error ??
                  "Ocurrió un error",
        ),
      ),
    );
  }

  String _formatearFecha(String valor) {
    final fecha =
        DateTime.tryParse(valor)?.toLocal();

    if (fecha == null) {
      return valor;
    }

    return DateFormat(
      "dd/MM/yyyy  HH:mm",
    ).format(fecha);
  }

  IconData _iconoTipo(String tipo) {
    switch (tipo) {
      case "recordatorio":
        return Icons.event_available;
      case "cambio":
        return Icons.edit_calendar;
      default:
        return Icons.campaign;
    }
  }

  String _tituloTipo(String tipo) {
    switch (tipo) {
      case "recordatorio":
        return "RECORDATORIO";
      case "cambio":
        return "CAMBIO EN EVENTO";
      default:
        return "NUEVA NOTIFICACIÓN";
    }
  }

  Widget _tarjetaNotificacion(
    Notificacion notificacion,
  ) {
    final noLeida =
        notificacion.leido == 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
        borderRadius:
            BorderRadius.circular(4),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline,
                ),
              ),
              child: Icon(
                _iconoTipo(
                  notificacion.tipo,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Expanded(
                        child: Text(
                          _tituloTipo(
                            notificacion
                                .tipo,
                          ),
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (noLeida)
                        Container(
                          width: 9,
                          height: 9,
                          decoration:
                              const BoxDecoration(
                            color:
                                Colors.black,
                            shape:
                                BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notificacion.mensaje,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatearFecha(
                      notificacion.fecha,
                    ),
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<NotificacionesViewModel>();

    final session =
        context.watch<SessionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EVENTOESPOL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _cambiarUsuario,
            tooltip: "Cambiar usuario",
            icon: const Icon(
              Icons.account_circle_outlined,
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            _crearNotificacionPrueba,
        icon:
            const Icon(Icons.add_alert),
        label: const Text(
          "Notificación",
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "NOTIFICACIONES",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                width: 65,
                height: 4,
                color: Colors.black,
              ),

              const SizedBox(height: 8),

              Text(
                "Usuario: ${session.usuario}",
                style: TextStyle(
                  color:
                      Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 16),

              if (vm.cargando &&
                  vm.notificaciones
                      .isNotEmpty)
                const LinearProgressIndicator(),

              if (vm.error != null &&
                  vm.notificaciones
                      .isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text(
                    vm.error!,
                    style:
                        const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),

              Expanded(
                child: vm.cargando &&
                        vm.notificaciones
                            .isEmpty
                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )
                    : vm.notificaciones
                            .isEmpty
                        ? RefreshIndicator(
                            onRefresh:
                                _cargarNotificaciones,
                            child: ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children:
                                  const [
                                SizedBox(
                                  height:
                                      180,
                                ),
                                Icon(
                                  Icons
                                      .notifications_none,
                                  size: 70,
                                ),
                                SizedBox(
                                  height:
                                      15,
                                ),
                                Center(
                                  child: Text(
                                    "No hay notificaciones todavía.",
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh:
                                _cargarNotificaciones,
                            child:
                                ListView.separated(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemCount: vm
                                  .notificaciones
                                  .length,
                              separatorBuilder:
                                  (_, __) =>
                                      const SizedBox(
                                height: 8,
                              ),
                              itemBuilder:
                                  (context,
                                      index) {
                                return _tarjetaNotificacion(
                                  vm.notificaciones[
                                      index],
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
