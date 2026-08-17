import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/evento.dart';
import '../viewmodels/eventos_viewmodel.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final List<String> _categoriasBase = const [
    "Tecnología",
    "Cultural",
    "Académico",
    "Deportivo",
    "Social",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventosViewModel>().cargarEventos();
    });
  }

  Future<void> _abrirDialogoEvento() async {
    final vm = context.read<EventosViewModel>();
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final ubicacionController = TextEditingController();
    final cupoController = TextEditingController(text: "50");

    String categoriaSeleccionada = _categoriasBase.first;
    DateTime? fechaSeleccionada = DateTime.now();

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, setStateDialog) {
            return AlertDialog(
              title: const Text("Crear evento"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      decoration: const InputDecoration(
                        labelText: "Título",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descripcionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ubicacionController,
                      decoration: const InputDecoration(
                        labelText: "Ubicación",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: categoriaSeleccionada,
                      decoration: const InputDecoration(
                        labelText: "Categoría",
                        border: OutlineInputBorder(),
                      ),
                      items: _categoriasBase
                          .map((categoria) => DropdownMenuItem(
                                value: categoria,
                                child: Text(categoria),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setStateDialog(() => categoriaSeleccionada = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cupoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Cupo máximo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: contextDialog,
                          initialDate: fechaSeleccionada ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (fecha != null) {
                          setStateDialog(() => fechaSeleccionada = fecha);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Fecha del evento"),
                            Text(
                              fechaSeleccionada == null
                                  ? "Seleccionar"
                                  : "${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final titulo = tituloController.text.trim();
                    final descripcion = descripcionController.text.trim();
                    final ubicacion = ubicacionController.text.trim();
                    final cupo = int.tryParse(cupoController.text.trim());

                    if (titulo.isEmpty || ubicacion.isEmpty || fechaSeleccionada == null || cupo == null || cupo <= 0) {
                      return;
                    }

                    final evento = Evento(
                      id: 0,
                      titulo: titulo,
                      descripcion: descripcion.isEmpty ? null : descripcion,
                      fecha: fechaSeleccionada!.toIso8601String().split("T").first,
                      ubicacion: ubicacion,
                      categoria: categoriaSeleccionada,
                      cupoMaximo: cupo,
                      cupoDisponible: cupo,
                    );

                    Navigator.pop(dialogContext, true);
                    _guardarEvento(evento, vm);
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );

    if (ok == true && mounted) {
      final mensaje = vm.mensajeExito ?? "Evento creado";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  Future<void> _guardarEvento(Evento evento, EventosViewModel vm) async {
    final ok = await vm.crearEvento(evento);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.mensajeExito ?? "Evento creado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? "No se pudo crear el evento")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EventosViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo de eventos"),
        actions: [
          IconButton(
            onPressed: () => vm.cargarEventos(categoria: vm.categoriaSeleccionada == "Todas" ? null : vm.categoriaSeleccionada),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirDialogoEvento,
        icon: const Icon(Icons.add),
        label: const Text("Nuevo evento"),
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(vm.error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => vm.cargarEventos(
                            categoria: vm.categoriaSeleccionada == "Todas" ? null : vm.categoriaSeleccionada,
                          ),
                          child: const Text("Reintentar"),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...[
                              "Todas",
                              ...vm.categorias.where((categoria) => categoria != "Todas").toList(),
                              ..._categoriasBase.where((categoria) => !vm.categorias.contains(categoria))
                            ].map((categoria) {
                              final seleccionada = vm.categoriaSeleccionada == categoria;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(categoria),
                                  selected: seleccionada,
                                  onSelected: (_) {
                                    vm.categoriaSeleccionada = categoria;
                                    vm.cargarEventos(
                                      categoria: categoria == "Todas" ? null : categoria,
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: vm.eventos.isEmpty
                          ? const Center(child: Text("No hay eventos para esta categoría."))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                              itemCount: vm.eventos.length,
                              itemBuilder: (context, index) {
                                final evento = vm.eventos[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ExpansionTile(
                                    title: Text(evento.titulo),
                                    subtitle: Text(evento.categoria),
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      child: Icon(
                                        _iconoCategoria(evento.categoria),
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (evento.descripcion != null && evento.descripcion!.isNotEmpty)
                                              Text(evento.descripcion!),
                                            const SizedBox(height: 8),
                                            _InfoEvento(icon: Icons.calendar_today, texto: evento.fecha),
                                            _InfoEvento(icon: Icons.location_on, texto: evento.ubicacion),
                                            _InfoEvento(icon: Icons.people, texto: "${evento.cupoDisponible} / ${evento.cupoMaximo} cupos disponibles"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  IconData _iconoCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case "tecnología":
      case "tecnologia":
        return Icons.computer;
      case "cultural":
        return Icons.palette;
      case "académico":
      case "academico":
        return Icons.school;
      case "deportivo":
        return Icons.sports_soccer;
      default:
        return Icons.event;
    }
  }
}

class _InfoEvento extends StatelessWidget {
  final IconData icon;
  final String texto;

  const _InfoEvento({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
