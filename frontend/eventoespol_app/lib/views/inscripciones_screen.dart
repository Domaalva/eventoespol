import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          title: const Text("Inscribirme a un evento"),
          content: DropdownButtonFormField<int>(
            hint: const Text("Selecciona un evento"),
            items: vm.eventosDisponibles
                .map((e) => DropdownMenuItem(value: e.id, child: Text("${e.titulo} (${e.cupoDisponible} cupos)")))
                .toList(),
            onChanged: (v) => setStateDialog(() => eventoSeleccionado = v),
          ),
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

    return Scaffold(
      appBar: AppBar(title: const Text("Mis inscripciones")),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirDialogoInscripcion,
        child: const Icon(Icons.add),
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.misInscripciones.isEmpty
              ? const Center(child: Text("Todavía no tienes inscripciones."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vm.misInscripciones.length,
                  itemBuilder: (context, i) {
                    final ins = vm.misInscripciones[i];
                    final confirmado = ins.estado == "confirmado";
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          confirmado ? Icons.check_circle : Icons.cancel,
                          color: confirmado ? Colors.green : Colors.red,
                        ),
                        title: Text("Evento #${ins.eventoId}"),
                        subtitle: Text("Estado: ${ins.estado}\nFecha: ${ins.fechaInscripcion}"),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
