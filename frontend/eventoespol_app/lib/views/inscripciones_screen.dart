import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodels/inscripciones_viewmodel.dart';
import '../viewmodels/session_viewmodel.dart';

/// Responsable: Domenika Arboleda
/// Pantalla "Mis inscripciones": lista las inscripciones del usuario
/// (lectura) y permite inscribirse a un nuevo evento validando cupo
/// (escritura, el backend responde con error si no hay cupo disponible).
class InscripcionesScreen extends StatefulWidget {
  const InscripcionesScreen({super.key});

  @override
  State<InscripcionesScreen> createState() => _InscripcionesScreenState();
}

class _InscripcionesScreenState extends State<InscripcionesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuario = context.read<SessionViewModel>().usuario;
      context.read<InscripcionesViewModel>().cargarMisInscripciones(usuario);
    });
  }

  void _abrirDialogoInscripcion() {
    final vm = context.read<InscripcionesViewModel>();
    final usuario = context.read<SessionViewModel>().usuario;
    int? eventoSeleccionado;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.how_to_reg, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text("Inscribirme a un evento", style: TextStyle(fontSize: 17))),
            ],
          ),
          content: vm.eventosDisponibles.isEmpty
              ? const Text(
                  "Todavía no hay eventos publicados. Vuelve a intentarlo cuando exista alguno en el catálogo.",
                  style: TextStyle(color: Colors.grey),
                )
              : DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: "Evento"),
                  hint: const Text("Selecciona un evento"),
                  items: vm.eventosDisponibles
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(
                              "${e.titulo}  ·  ${e.cupoDisponible} cupos",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => eventoSeleccionado = v),
                ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: eventoSeleccionado == null
                  ? null
                  : () async {
                      final ok = await vm.inscribirse(eventoSeleccionado!, usuario);
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok ? vm.mensajeExito! : vm.error!),
                            backgroundColor: ok ? AppTheme.success : AppTheme.danger,
                          ),
                        );
                      }
                    },
              child: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InscripcionesViewModel>();
    final usuario = context.watch<SessionViewModel>().usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis inscripciones"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(34),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                usuario,
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirDialogoInscripcion,
        icon: const Icon(Icons.add),
        label: const Text("Inscribirme"),
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.misInscripciones.isEmpty
              ? const EmptyState(
                  icon: Icons.assignment_turned_in_outlined,
                  titulo: "Todavía no tienes inscripciones",
                  subtitulo: "Toca \"Inscribirme\" para unirte a tu primer evento.",
                )
              : RefreshIndicator(
                  onRefresh: () => vm.cargarMisInscripciones(usuario),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
                    itemCount: vm.misInscripciones.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final ins = vm.misInscripciones[i];
                      final confirmado = ins.estado == "confirmado";
                      final color = confirmado ? AppTheme.success : AppTheme.danger;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  confirmado ? Icons.check_circle_outline : Icons.cancel_outlined,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Evento #${ins.eventoId}",
                                        style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatearFecha(ins.fechaInscripcion),
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  confirmado ? "Confirmado" : "Cancelado",
                                  style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _formatearFecha(String iso) {
    try {
      final d = DateTime.parse(iso);
      const meses = [
        "ene", "feb", "mar", "abr", "may", "jun",
        "jul", "ago", "sep", "oct", "nov", "dic"
      ];
      return "Inscrito el ${d.day} de ${meses[d.month - 1]}, ${d.year}";
    } catch (_) {
      return iso;
    }
  }
}
