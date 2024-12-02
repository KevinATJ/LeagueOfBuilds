import 'package:flutter/material.dart';

// Página Home
class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1D334A),
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFC79B3B), // Color del borde (dorado)
                    width: 4.0, // Grosor del borde
                  ),
                ),
                child: Image.asset(
                  'assets/icons/app_icon.png', // Ruta de la imagen
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(height: 30), // Espaciado entre la imagen y el texto
              // Texto de bienvenida
              const Text(
                '¡Bienvenido!\n*Ruidos de poro*',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  height: 1.5, // Espaciado entre líneas
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Espaciado entre el texto de bienvenida y el título
              // Título de últimas builds
              const Text(
                'Últimas builds creadas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Espaciado entre el título y el mensaje
              // Mensaje de builds vacías
              const Text(
                'Todavía no haz creado ninguna build.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
