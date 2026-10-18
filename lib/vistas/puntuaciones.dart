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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B2874), // Morado superior
            Color(0xFF6C5CE7), // Morado brillante
            Color(0xFF2A1B54), // Morado oscuro inferior
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Mejores Puntuaciones',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              tooltip: 'Borrar historial',
              onPressed: () async {
                await Almacenamiento.borrarPuntajes();
                setState(() {});
              },
            )
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Chips de filtro con visto en color negro al seleccionar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChip('Fácil', 'facil', const Color(0xFF55EFC4)),
                    const SizedBox(width: 10),
                    _buildChip('Medio', 'medio', const Color(0xFFFFEAA7)),
                    const SizedBox(width: 10),
                    _buildChip('Difícil', 'dificil', const Color(0xFFFF7675)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<EntradaPuntaje>>(
                    future: Almacenamiento.obtenerPuntajes(_dificultadFiltro),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay marcas registradas en esta dificultad.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        );
                      }

                      final lista = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          final p = lista[index];
                          return Card(
                            color: Colors.white.withOpacity(0.12),
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _obtenerColorMedalla(index),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E272C),
                                  ),
                                ),
                              ),
                              title: Text(
                                'Movimientos: ${p.movimientos}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Tiempo: ${p.tiempoSegundos} s',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Text(
                                p.fecha,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, String clave, Color colorActivo) {
    bool selected = _dificultadFiltro == clave;
    return ChoiceChip(
      checkmarkColor: const Color(0xFF1E272C), // 👈 Visto en color oscuro legible
      label: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFF1E272C) : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selected,
      selectedColor: colorActivo,
      backgroundColor: Colors.white.withOpacity(0.12),
      side: BorderSide(
        color: selected ? colorActivo : Colors.white24,
        width: 1.5,
      ),
      onSelected: (_) => setState(() => _dificultadFiltro = clave),
    );
  }

  Color _obtenerColorMedalla(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Oro
      case 1:
        return const Color(0xFFC0C0C0); // Plata
      case 2:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return const Color(0xFF55EFC4); // Verde neón
    }
  }
}