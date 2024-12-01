import 'package:flutter/material.dart';
import 'build_create.dart';
import '/Models/items_data_base.dart';
import '/Models/champions_data_base.dart';

// Página Builds
class Builds extends StatefulWidget {
  const Builds({super.key, required this.title});

  final String title;

  @override
  State<Builds> createState() => _BuildsState();
}

class _BuildsState extends State<Builds> {
  bool _canNavigate = false;

  // Método para comprobar si las bases de datos tienen datos
  Future<void> _checkDatabases() async {
    // Obtener los items desde la base de datos
    List<Map<String, dynamic>> items = await ItemsDataBase.instance.fetchItems();
    // Obtener los campeones desde la base de datos
    List<Map<String, dynamic>> champions = await ChampionsDataBase.instance.fetchChampions();

    // Verificar si ambas bases de datos tienen registros
    setState(() {
      _canNavigate = items.isNotEmpty && champions.isNotEmpty;
    });
  }
  
  @override
  void initState() {
    super.initState();
    // Llamar a la comprobación al inicio
    _checkDatabases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D334A),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto principal
            Text(
              'Aquí se ven las builds',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Comprobar si se puede navegar antes de hacer la transición
          if (_canNavigate) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BuildCreate(title: 'Create build')),
            );
          } else {
            // Si no se puede navegar, mostrar el cuadro de diálogo con el mensaje
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFFC79B3B),
                  title: const Center(
                    child: Text(
                      'Acceso Bloqueado',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  content: SizedBox(
                    width: 250, // Ajusta el ancho del cuadro de mensaje
                    height: 100,
                    child: const Center(
                      child: Text(
                        'Todavía no has ingresado a la aplicación con acceso a internet, aunque sea una vez. '
                        'Prueba ingresar nuevamente a la aplicación para desbloquear esta función.',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        textAlign: TextAlign.center, // Centrado del texto
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Center( // Centrado del botón de cerrar
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        backgroundColor: const Color(0xFFC79B3B),
        child: const Icon(Icons.add),
      ),
    );
  }
}
