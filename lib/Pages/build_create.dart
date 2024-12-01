import 'package:flutter/material.dart';

// Página BuildCreate
class BuildCreate extends StatefulWidget {
  const BuildCreate({super.key, required this.title});

  final String title;

  @override
  State<BuildCreate> createState() => _BuildCreateState();
}

class _BuildCreateState extends State<BuildCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D334A),
      appBar: AppBar(
        title: const Text(
          "Crear Build",
          style: TextStyle(
            color: Color(0xFFFFFFFF), // Título en blanco
          ),
        ),
        backgroundColor: const Color(0xFF15242F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFFFFF), // Color blanco para la flecha
          ),
          onPressed: () {
            Navigator.pop(context); // Vuelve a la pantalla anterior
          },
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto principal
            Text(
              'Aquí se crean las Builds',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
