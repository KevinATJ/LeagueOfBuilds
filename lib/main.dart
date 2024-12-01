import 'package:flutter/material.dart';
import 'package:league_of_builds/Pages/navegation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'Models/items_data_base.dart';

String? latestApiVersion;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Comprobar si hay conexión a alguna red y si esta tiene acceso a Internet
  bool hasInternet = await checkInternetConnection();

  if (hasInternet) {
    // Si hay conexión, obtener la última versión de la API
    latestApiVersion = await fetchLatestVersion();
    // ignore: avoid_print
    print('Última versión de la API: $latestApiVersion');
    // Obtener y guardar los datos de los ítems en la base de datos
    await fetchItemsData();
    // Imprimir los ítems almacenados en la base de datos
    await printItemsFromDB();

  } else {
    // ignore: avoid_print
    print('No hay conexión a Internet. Continuando sin obtener la versión.');
  }

  runApp(const MyApp());
}

// Función para verificar conexión a alguna red y si esta tiene acceso a Internet
Future<bool> checkInternetConnection() async {
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  
  // Verificar si hay conexión a alguna red
  if (connectivityResult.contains(ConnectivityResult.none)) {
    // ignore: avoid_print
    print('No hay conexión a ninguna red');
    return false; 
  } else {
    // ignore: avoid_print
    print('Hay conexión a una red');
  }

  // Probar acceso real a Internet
  try {
    final result = await http.get(Uri.parse('https://www.google.com')).timeout(
      const Duration(seconds: 5), // Tiempo de espera para evitar bloqueos
    );
    // ignore: avoid_print
    print('Hay acceso a internet');
    return result.statusCode == 200;
  } catch (e) {
    // ignore: avoid_print
    print('No hay acceso a internet');
    return false;
  }
}

// Función para obtener la última versión de la API
Future<String?> fetchLatestVersion() async {
  const url = 'https://ddragon.leagueoflegends.com/api/versions.json';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> versions = json.decode(response.body);
      return versions.first; // Devuelve la primera versión (más reciente)
    } else {
      // ignore: avoid_print
      print('Error al obtener las versiones. Código de estado: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error al conectarse al API: $e');
    return null;
  }
}

Future<void> fetchItemsData() async {
  if (latestApiVersion != null) {
    final url = 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/data/es_MX/item.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Aseguramos que la respuesta sea decodificada correctamente en UTF-8
        final data = json.decode(utf8.decode(response.bodyBytes));
        final items = data['data'];

        // Recorremos los items y guardamos el nombre y la imagen completa
        items.forEach((key, value) async {
          if (value['gold'] != null && value['gold']['total'] > 0 && value['gold']['purchasable'] == true && !value.containsKey('inStore')) {
            final item = {
              'name': value['name'], // Guardamos el nombre con tildes correctamente
              'image_full': value['image']['full'] // Guardamos el valor de la imagen completa
            };

            // Guardamos el item en la base de datos
            await ItemsDataBase.instance.insertItem(item);
          }
        });
      } else {
        // ignore: avoid_print
        print('Error al obtener los ítems. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al conectarse al API de ítems: $e');
    }
  } else {
    // ignore: avoid_print
    print('No se pudo obtener la versión más reciente de la API');
  }
}

Future<void> printItemsFromDB() async {
  try {
    // Obtener los ítems de la base de datos
    final items = await ItemsDataBase.instance.fetchItems();

    if (items.isNotEmpty) {
      // Imprimir cada item
      items.forEach((item) {
        // ignore: avoid_print
        print('Item: ${item['name']}, Image: ${item['image_full']}');
      });
    } else {
      // ignore: avoid_print
      print('No se encontraron ítems en la base de datos.');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener los ítems desde la base de datos: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League of Builds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Navegation(title: 'League of Builds',), 
    );
  }
}
