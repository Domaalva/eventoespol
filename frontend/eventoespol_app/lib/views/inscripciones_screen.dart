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
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.how_to_reg, color: AppTheme.accent),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text("Inscribirme a un evento")),
            ],
          ),
          content: vm.eventosDisponibles.isEmpty
              ? const Text(
                  "Todavía no hay eventos publicados. Vuelve a intentarlo cuando exista alguno en el catálogo.",
                  style: TextStyle(color: AppTheme.textSecondary),
                )
              : DropdownButtonFormField<int>(
                  dropdownColor: AppTheme.surfaceCardLight,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: "Evento"),
                  hint: const Text("Selecciona un evento", style: TextStyle(color: AppTheme.textSecondary)),
                  items: vm.eventosDisponibles
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: Text("${e.titulo}  ·  ${e.cupoDisponible} cupos",
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => eventoSeleccionado = v),
                ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar", style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: eventoSeleccionado == null
                  ? null
                  : () async {
                      final ok = await vm.inscribirse(eventoSeleccionado!, usuario);
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ok ? vm.mensajeExito! : vm.error!)),
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("EVENTOESPOL"),
        leading: const Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.surfaceCardLight,
              child: const Icon(Icons.person, size: 18, color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirDialogoInscripcion,
        icon: const Icon(Icons.add),
        label: const Text("Inscribirme"),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EyebrowLabel(text: "MI PERFIL"),
                    const SizedBox(height: 14),
                    Text("Mis\nInscripciones", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 34)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 6),
                        Text(usuario, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: vm.cargando
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
                    : vm.misInscripciones.isEmpty
                        ? const EmptyState(
                            icon: Icons.assignment_turned_in_outlined,
                            titulo: "Todavía no tienes inscripciones",
                            subtitulo: "Toca \"Inscribirme\" para unirte a tu primer evento.",
                          )
                        : RefreshIndicator(
                            color: AppTheme.accent,
                            backgroundColor: AppTheme.surfaceCard,
                            onRefresh: () => vm.cargarMisInscripciones(usuario),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                              itemCount: vm.misInscripciones.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 14),
                              itemBuilder: (context, i) {
                                final ins = vm.misInscripciones[i];
                                final confirmado = ins.estado == "confirmado";
                                final color = confirmado ? AppTheme.success : AppTheme.danger;
                                final fecha = _partesFecha(ins.fechaInscripcion);

                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceCard,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border(left: BorderSide(color: AppTheme.accent, width: 4)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 52,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceCardLight,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(fecha.$1,
                                                style: const TextStyle(
                                                    color: AppTheme.accent, fontSize: 11, fontWeight: FontWeight.w800)),
                                            Text(fecha.$2,
                                                style: const TextStyle(
                                                    color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Evento #${ins.eventoId}",
                                                style: const TextStyle(
                                                    color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w800)),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 13, color: AppTheme.textSecondary),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(_formatearFecha(ins.fechaInscripcion),
                                                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: AppTheme.surfaceCardLight,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 7,
                                                    height: 7,
                                                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(confirmado ? "Confirmado" : "Cancelado",
                                                      style: TextStyle(
                                                          color: color, fontWeight: FontWeight.w700, fontSize: 11.5)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: const BoxDecoration(color: AppTheme.surfaceCardLight, shape: BoxShape.circle),
                                        child: const Icon(Icons.arrow_forward, size: 16, color: AppTheme.textPrimary),
                                      ),
                                    ],
                                  ),
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

  /// Devuelve (mes en mayúsculas, día) para el badge de fecha, ej. ("AGO", "17").
  (String, String) _partesFecha(String iso) {
    try {
      final d = DateTime.parse(iso);
      const meses = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
      return (meses[d.month - 1], d.day.toString().padLeft(2, '0'));
    } catch (_) {
      return ("--", "--");
    }
  }

  String _formatearFecha(String iso) {
    try {
      final d = DateTime.parse(iso);
      const meses = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"];
      return "Inscrito el ${d.day} de ${meses[d.month - 1]}, ${d.year}";
    } catch (_) {
      return iso;
    }
  }
}
