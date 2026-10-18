import 'package:flutter/material.dart';
import '../servicios/almacenamiento.dart';

class PuntuacionesView extends StatefulWidget {
  const PuntuacionesView({super.key});

  @override
  State<PuntuacionesView> createState() => _PuntuacionesViewState();
}

class _PuntuacionesViewState extends State<PuntuacionesView> {
  String _dificultadFiltro = 'medio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mejores Puntuaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Borrar historial',
            onPressed: () async {
              await Almacenamiento.borrarPuntajes();
              setState(() {});
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Fácil'),
                  selected: _dificultadFiltro == 'facil',
                  onSelected: (_) => setState(() => _dificultadFiltro = 'facil'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Medio'),
                  selected: _dificultadFiltro == 'medio',
                  onSelected: (_) => setState(() => _dificultadFiltro = 'medio'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Difícil'),
                  selected: _dificultadFiltro == 'dificil',
                  onSelected: (_) => setState(() => _dificultadFiltro = 'dificil'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EntradaPuntaje>>(
              future: Almacenamiento.obtenerPuntajes(_dificultadFiltro),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay marcas registradas en esta dificultad.'),
                  );
                }

                final lista = snapshot.data!;
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final p = lista[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Movimientos: ${p.movimientos}'),
                        subtitle: Text('Tiempo: ${p.tiempoSegundos} s'),
                        trailing: Text(
                          p.fecha,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}