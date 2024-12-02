import 'package:flutter/material.dart';
import 'package:league_of_builds/Pages/navegation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'Models/items_data_base.dart';
import 'Models/champions_data_base.dart';

bool hasInternet = false;

String? latestApiVersion;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Comprobar si hay conexión a alguna red y si esta tiene acceso a Internet
  hasInternet = await checkInternetConnection();

  if (hasInternet) {
    // Si hay conexión, obtener la última versión de la API
    latestApiVersion = await fetchLatestVersion();
    // ignore: avoid_print
    print('Última versión de la API: $latestApiVersion');
    // Obtener y guardar los datos de los items en la base de datos
    await fetchItemsData();
    // Obtener y guardar los datos de los champions en la base de datos
    await fetchChampionsData();
    // Imprimir los items almacenados en la base de datos
    await printItemsFromDB();
    // Imprimir los champions almacenados en la base de datos
    await printChampionsFromDB();

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

// Función para obtener los items y guardarlos en la base de datos
Future<void> fetchItemsData() async {
  if (latestApiVersion != null) {
    final url = 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/data/es_MX/item.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Aseguramos que la respuesta sea decodificada correctamente en UTF-8
        final data = json.decode(utf8.decode(response.bodyBytes));
        final items = data['data'];

        // Recorremos los items y guardar el nombre y la imagen
        for (var key in items.keys) {
          final value = items[key];
          if (value['gold'] != null && value['gold']['total'] > 0 && value['gold']['purchasable'] == true && !value.containsKey('inStore')) {
            // Verificar si el nombre no termina con <br>
            if (!value['name'].toString().startsWith('Objeto') && !value['name'].toString().endsWith('<br>')) {
              final item = {
                'name': value['name'], // Guardar el nombre
                'image_full': value['image']['full'] // Guardar el valor de la imagen
              };

              // Guardar el item en la base de datos
              await ItemsDataBase.instance.insertItem(item);
            } else {
              // ignore: avoid_print
              print('Item descartado debido a su nombre que termina con <br>: ${value['name']}');
            }
          }
        }
      } else {
        // ignore: avoid_print
        print('Error al obtener los items. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al conectarse al API de items: $e');
    }
  } else {
    // ignore: avoid_print
    print('No se pudo obtener la versión más reciente de la API');
  }
}

// Función para obtener los champions y guardarlos en la base de datos
Future<void> fetchChampionsData() async {
  if (latestApiVersion != null) {
    final url = 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/data/es_MX/champion.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Aseguramos que la respuesta sea decodificada correctamente en UTF-8
        final data = json.decode(utf8.decode(response.bodyBytes));
        final champions = data['data'];

        // Recorremos los champions y guardar el nombre y la imagen
        for (var key in champions.keys) {
          final value = champions[key];
          final champion = {
            'name': value['name'], // Guardar el nombre del champion
            'image_full': value['image']['full'] // Guardar la imagen
          };

          // Guardamos el champion en la base de datos
          await ChampionsDataBase.instance.insertChampion(champion);
        }
      } else {
        // ignore: avoid_print
        print('Error al obtener los champions. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al conectarse al API de champions: $e');
    }
  } else {
    // ignore: avoid_print
    print('No se pudo obtener la versión más reciente de la API');
  }
}

// Función para imprimir en la terminal los valores de la base de datos de los items
Future<void> printItemsFromDB() async {
  try {
    // Obtener los items de la base de datos
    final items = await ItemsDataBase.instance.fetchItems();

    if (items.isNotEmpty) {
      // Imprimir cada item
      for (var item in items) {
        // ignore: avoid_print
        print('Item: ${item['name']}, Image: ${item['image_full']}');
      }
    } else {
      // ignore: avoid_print
      print('No se encontraron items en la base de datos.');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener los items desde la base de datos: $e');
  }
}

// Función para imprimir en la terminal los valores de la base de datos de los champions
Future<void> printChampionsFromDB() async {
  try {
    // Obtener los champions de la base de datos
    final champions = await ChampionsDataBase.instance.fetchChampions();

    if (champions.isNotEmpty) {
      // Imprimir cada champion
      for (var champion in champions) {
        // ignore: avoid_print
        print('Champion: ${champion['name']}, Image: ${champion['image_full']}');
      }
    } else {
      // ignore: avoid_print
      print('No se encontraron champions en la base de datos.');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener los champions desde la base de datos: $e');
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
