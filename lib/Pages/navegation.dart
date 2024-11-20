import 'package:flutter/material.dart';

class Navegation extends StatefulWidget {
  const Navegation({super.key, required this.title});

  final String title;

  @override
  State<Navegation> createState() => _NavegationState();
}

class _NavegationState extends State<Navegation> {
  int _selectedIndex = 0;

  // Método que cambia la pestaña
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget que construye la página seleccionada
  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Aquí van a crearse cards con las builds.'));//Reemplazar esto por pantallas a crear
      case 1:
        return const Center(child: Text('Aquí se mostrarán las builds recientes.'));//Reemplazar esto por pantallas a crear
      case 2:
        return const Center(child: Text('Aquí se encontrará la información de la aplicación.'));//Reemplazar esto por pantallas a crear
      default:
        return const Center(child: Text('Aquí van a crearse cards con las builds.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); 
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 171, 158, 48),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: _buildPage(), // Solo muestra la página seleccionada
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 171, 158, 48),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Mis Builds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Builds Recientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Sobre',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
