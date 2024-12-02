import 'package:flutter/material.dart';
import 'build_create.dart';
import '/Models/items_data_base.dart';
import '/Models/champions_data_base.dart';
import '/Models/builds_data_base.dart';
import 'package:league_of_builds/main.dart';
import 'package:share_plus/share_plus.dart';

// Página Builds
class Builds extends StatefulWidget {
  const Builds({super.key, required this.title});

  final String title;

  @override
  State<Builds> createState() => _BuildsState();
}

class _BuildsState extends State<Builds> {
  bool _canNavigate = false;
  //List<Map<String, dynamic>> _builds = [];
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  late Future<List<Map<String, dynamic>>> _championsFuture;

  // Método para comprobar si las bases de datos tienen datos
  Future<void> _checkDatabases() async {
    // Obtener los items y campeones desde la base de datos
    _itemsFuture = ItemsDataBase.instance.fetchItems();
    _championsFuture = ChampionsDataBase.instance.fetchChampions();
    
    // Verificar si ambas bases de datos tienen registros
    _itemsFuture.then((items) {
      _championsFuture.then((champions) {
        setState(() {
          _canNavigate = items.isNotEmpty && champions.isNotEmpty;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkDatabases();
  }

  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  
  // Recargar builds si se recibe un 'true' al regresar de la pantalla BuildCreate
  ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {}));
}

  // Método para obtener la URL de la imagen del campeón
  Future<String> _getChampionImageUrl(String championName) async {
    List<Map<String, dynamic>> champions = await _championsFuture;
    // Buscar el campeón por nombre
    var champion = champions.firstWhere(
      (champion) => champion['name'] == championName,
      orElse: () => {},
    );

    // Si se encuentra el campeón, obtener la imagen
    if (champion.isNotEmpty) {
      String imageFull = champion['image_full'];  // Obtener el nombre de la imagen
      return 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/champion/$imageFull';
    } else {
      return '';  // Si no se encuentra el campeón, retornar una cadena vacía
    }
  }

  // Método para obtener la URL de la imagen de los ítems
  Future<String> _getItemImageUrl(String itemName) async {
    List<Map<String, dynamic>> items = await _itemsFuture;
    // Buscar el ítem por nombre
    var item = items.firstWhere(
      (item) => item['name'] == itemName,
      orElse: () => {},
    );

    // Si se encuentra el ítem, obtener la imagen
    if (item.isNotEmpty) {
      String imageFull = item['image_full'];  // Obtener el nombre de la imagen
      return 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/item/$imageFull';
    } else {
      return '';  // Si no se encuentra el ítem, retornar una cadena vacía
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D334A),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: BuildsDataBase.instance.fetchBuilds(), // Utilizamos el Future directo
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> builds = snapshot.data ?? [];
          return ListView.builder(
            itemCount: builds.length,
            itemBuilder: (context, index) {
              var build = builds[index];

              // Obtener la URL de la imagen del campeón usando FutureBuilder
              return FutureBuilder<String>( 
                future: _getChampionImageUrl(build['champion']),
                builder: (context, championSnapshot) {
                  if (championSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!championSnapshot.hasData || championSnapshot.data!.isEmpty) {
                    return const Text("Imagen no encontrada");
                  }

                  List<String> itemKeys = [
                    'item1', 'item2', 'item3', 'item4', 'item5', 'item6',
                    'additionalItem1', 'additionalItem2', 'additionalItem3', 'additionalItem4', 'additionalItem5', 'additionalItem6'
                  ];

                  return FutureBuilder<List<String>>(
                    future: Future.wait(itemKeys.map((key) => _getItemImageUrl(build[key]))),
                    builder: (context, itemSnapshot) {
                      if (itemSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      List<String> itemUrls = itemSnapshot.data ?? [];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: const Color(0xFF15242F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  hasInternet
                                      ? Image.network(
                                          championSnapshot.data!,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Image.asset(
                                          'assets/images/defaultChampion.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                  const SizedBox(width: 10),
                                  Text(
                                    build['name_buil'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Ícono de eliminar build
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFFC79B3B),
                                    ),
                                    onPressed: () async {
                                      // Mostrar cuadro de confirmación
                                      bool? confirmDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: const Color(0xFFC79B3B),
                                            title: const Text(
                                              'Confirmar eliminación',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            content: const Text(
                                              '¿Estás seguro de que deseas eliminar esta build?',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: const Text(
                                                  'Sí',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // Si el usuario confirma la eliminación
                                      if (confirmDelete == true) {
                                        // Llamar al método de eliminación de la base de datos
                                        await BuildsDataBase.instance.deleteBuild(build['id']);
                                        
                                        // Mostrar snackbar con el mensaje de confirmación
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Build eliminada',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Color(0xFFC79B3B),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  // Botón de compartir
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Color(0xFFC79B3B),
                                    ),
                                    onPressed: () {
                                      // Construir el texto a compartir
                                      String buildDetails = "Build: ${build['name_buil']}\n"
                                          "Campeón: ${build['champion']}\n"
                                          "Items:\n";

                                      // Añadir los items al texto
                                      for (var i = 0; i < itemKeys.length; i++) {
                                        var itemName = build[itemKeys[i]] ?? '';
                                        if (itemName.isNotEmpty) {
                                          buildDetails += "- $itemName\n";
                                        }
                                      }

                                      // Usar el paquete `share_plus` para compartir el texto
                                      Share.share(buildDetails);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Items de Build
                              const Text(
                                'Items de Build:',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Wrap(
                                spacing: 8,
                                children: itemUrls.take(6).map((itemUrl) {
                                  return hasInternet
                                      ? Image.network(
                                          itemUrl,
                                          width: 40,
                                          height: 40,
                                        )
                                      : Image.asset(
                                          'assets/images/defaultItem.png',
                                          width: 40,
                                          height: 40,
                                        );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              // Items Adicionales
                              const Text(
                                'Items Adicionales:',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Wrap(
                                spacing: 8,
                                children: itemUrls.skip(6).map((itemUrl) {
                                  return hasInternet
                                      ? Image.network(
                                          itemUrl,
                                          width: 40,
                                          height: 40,
                                        )
                                      : Image.asset(
                                          'assets/images/defaultItem.png', // Imagen local predeterminada
                                          width: 40,
                                          height: 40,
                                        );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
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
                  content: const SizedBox(
                    width: 250,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Todavía no has ingresado a la aplicación con acceso a internet, aunque sea una vez.'
                        'Prueba ingresar nuevamente a la aplicación para desbloquear esta función',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Center(
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
