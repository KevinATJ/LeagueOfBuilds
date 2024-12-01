import 'package:flutter/material.dart';
import 'about.dart';
import 'builds.dart';
import 'home.dart';

// Página Navegation
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
        return const Home(title: 'Inicio');
      case 1:
        return const Builds(title: 'Builds');
      case 2:
        return const About(title: 'Acerca');
      default:
        return const Home(title: 'Inicio');
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
          backgroundColor: const Color(0xFF15242F),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFFFFFFFF)
            ),
          ),
        ),
        body: _buildPage(), // Solo muestra la página seleccionada
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF15242F),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Builds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Acerca',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFFFFFFF),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
