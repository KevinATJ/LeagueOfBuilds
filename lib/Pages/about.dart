import 'package:flutter/material.dart';

// Página About
class About extends StatefulWidget {
  const About({super.key, required this.title});

  final String title;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1D334A),
        padding: const EdgeInsets.all(16.0),
        // Ajusta el alto del contenedor al tamaño de la pantalla
        height: MediaQuery.of(context).size.height, // Esto garantiza que ocupe toda la pantalla
        child: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Acerca de esta aplicación:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espaciado
              Text(
                'Esta aplicación ha sido diseñada para proporcionar a los jugadores de League of Legends una herramienta intuitiva y fácil de usar, que les permita crear y gestionar builds personalizadas para sus campeones favoritos. Con un enfoque en la simplicidad y eficiencia, la aplicación ofrece diversas funcionalidades para optimizar la experiencia del usuario, manteniendo siempre actualizada toda la información relevante sobre objetos y campeones. Así, los usuarios pueden acceder rápidamente a los datos más recientes y construir las mejores combinaciones para mejorar su rendimiento en el juego.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30), // Espaciado más grande
              Text(
                'Creado por:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Eduardo Cabezas y Kevin Troncoso\n'
                'Estudiantes de la carrera Ingeniería en Desarrollo de Videojuegos y Realidad Virtual de la Universidad de Talca.\n',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Espaciado
              Text(
                'Contactos:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Si tienes alguna pregunta o necesitas soporte técnico, no dudes en contactarnos a través de los siguientes medios:\n\n'
                'Correos institucional:\n'
                'Eduardo Cabezas: ecabezas22@alumnos.utalca.cl\n'
                'Kevin Troncoso: *PON TU CORREO*\n\n'
                'Agradecemos tus comentarios y sugerencias.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                  height: 1.5,
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
