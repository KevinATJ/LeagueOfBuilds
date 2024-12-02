import 'package:flutter/material.dart';
import 'package:league_of_builds/Models/items_data_base.dart';
import 'package:league_of_builds/Models/champions_data_base.dart';
import 'package:league_of_builds/Models/builds_data_base.dart';
import 'package:league_of_builds/main.dart';

class BuildCreate extends StatefulWidget {
  const BuildCreate({super.key, required this.title});

  final String title;

  @override
  State<BuildCreate> createState() => _BuildCreateState();
}

class _BuildCreateState extends State<BuildCreate> {
  String? selectedChampion;
  List<String> buildItems = [];
  List<String> additionalItems = [];
  List<Map<String, dynamic>> champions = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredChampions = [];
  List<Map<String, dynamic>> filteredItems = [];
  TextEditingController championSearchController = TextEditingController();
  TextEditingController itemSearchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadData();
    _loadBuilds();
  }

// Cargar datos de campeones e ítems
Future<void> _loadData() async {
  final champData = await ChampionsDataBase.instance.fetchChampions();
  final itemData = await ItemsDataBase.instance.fetchItems();

  // Usar un Set para eliminar duplicados basándonos en una clave única (como 'name')
  final Set<String> uniqueChampionNames = {};
  final Set<String> uniqueItemNames = {};

  // Filtrar duplicados de campeones
  final List<Map<String, dynamic>> uniqueChampions = [];
  for (var champ in champData) {
    if (uniqueChampionNames.add(champ['name'] as String)) {
      uniqueChampions.add(champ);
    }
  }

  // Filtrar duplicados de ítems
  final List<Map<String, dynamic>> uniqueItems = [];
  for (var item in itemData) {
    if (uniqueItemNames.add(item['name'] as String)) {
      uniqueItems.add(item);
    }
  }

  setState(() {
    champions = uniqueChampions;
    items = uniqueItems;
    filteredChampions = uniqueChampions;
    filteredItems = uniqueItems;
  });
}

  // Filtrar campeones
  void _filterChampions(String query) {
    final filtered = champions.where((champion) {
      return champion['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredChampions = filtered;
    });
  }

  // Filtrar ítems
  void _filterItems(String query) {
    final filtered = items.where((item) {
      return item['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredItems = filtered;
    });
  }

  Future<void> _loadBuilds() async {
    List<Map<String, dynamic>> builds = await BuildsDataBase.instance.fetchBuilds();
    
    // Mostrar los builds en la consola de depuración
    // ignore: avoid_print
    print("Builds almacenados en la base de datos:");
    for (var build in builds) {
      // ignore: avoid_print
      print(build);
    }
  }

  // Guardar la build
  Future<void> _saveBuild() async {
    if (selectedChampion == null || buildItems.length < 6 || additionalItems.length < 6) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos de la creación de builds antes de guardar.'),
          backgroundColor: Color(0xFFC79B3B), // Establecer el color de fondo aquí
        ),
      );
      return;
    }

    final build = {
      'name_buil': 'Build de $selectedChampion',
      'champion': selectedChampion!,
      'item1': buildItems[0],
      'item2': buildItems[1],
      'item3': buildItems[2],
      'item4': buildItems[3],
      'item5': buildItems[4],
      'item6': buildItems[5],
      'additionalItem1': additionalItems[0],
      'additionalItem2': additionalItems[1],
      'additionalItem3': additionalItems[2],
      'additionalItem4': additionalItems[3],
      'additionalItem5': additionalItems[4],
      'additionalItem6': additionalItems[5],
    };

    await BuildsDataBase.instance.insertBuild(build);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Build guardada exitosamente.'),
        backgroundColor: Color(0xFFC79B3B),  // Establecer el color de fondo aquí
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  String _getChampionImageUrl(String imageFull) {
    return "https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/champion/$imageFull";
  }

  String _getItemImageUrl(String imageFull) {
    return "https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/item/$imageFull";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D334A),
      appBar: AppBar(
        title: const Text(
          "Crear Build",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: const Color(0xFF15242F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de búsqueda para campeones
              const Text('Buscar campeón:', style: TextStyle(color: Colors.white)),
              TextField(
                controller: championSearchController,
                onChanged: _filterChampions,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar un campeón...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF15242F),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // Mensaje si no hay campeones
              if (filteredChampions.isEmpty && championSearchController.text.isNotEmpty)
                const Text(
                  'No hay campeones con ese nombre.',
                  style: TextStyle(color: Colors.red),
                ),

              // Lista de campeones en un ExpansionTile
              const Text('Selecciona un campeón:', style: TextStyle(color: Colors.white)),
              ExpansionTile(
                title: Container(
                color: const Color(0xFF15242F),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedChampion ?? 'Selecciona un campeón',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
                children: [
                  SizedBox(
                    height: 200, // Tamaño fijo para la lista
                    child: ListView.builder(
                      itemCount: filteredChampions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: const Color(0xFF15242F),
                          child: ListTile(
                            leading: hasInternet
                                ? Image.network(
                                    _getChampionImageUrl(filteredChampions[index]['image_full']),
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.asset(
                                    'assets/images/defaultChampion.png',
                                    width: 40,
                                    height: 40,
                                  ),
                            title: Text(
                              filteredChampions[index]['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                selectedChampion = filteredChampions[index]['name'];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Campo de búsqueda para ítems
              const Text('Buscar ítem:', style: TextStyle(color: Colors.white)),
              TextField(
                controller: itemSearchController,
                onChanged: _filterItems,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar un ítem...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF15242F),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // Mensaje si no hay ítems
              if (filteredItems.isEmpty && itemSearchController.text.isNotEmpty)
                const Text(
                  'No hay ítems con ese nombre.',
                  style: TextStyle(color: Colors.red),
                ),

              // Lista de ítems de la build en un ExpansionTile
              const Text('Selecciona los ítems de la build:', style: TextStyle(color: Colors.white)),
              ExpansionTile(
                title: Container(
                  color: const Color(0xFF15242F),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ítems de Build',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${buildItems.length}/6',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                children: [
                  SizedBox(
                    height: 200, // Tamaño fijo para la lista
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Container(
                            color: const Color(0xFFC79B3B),
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                hasInternet
                                    ? Image.network(
                                        _getItemImageUrl(filteredItems[index]['image_full']),
                                        width: 40,
                                        height: 40,
                                      )
                                    : Image.asset(
                                        'assets/images/defaultItem.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                const SizedBox(width: 10),
                                Text(
                                  filteredItems[index]['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          value: buildItems.contains(filteredItems[index]['name']),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                if (buildItems.length < 6) {
                                  buildItems.add(filteredItems[index]['name']);
                                }
                              } else {
                                buildItems.remove(filteredItems[index]['name']);
                              }
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.deepPurple,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Mostrar los ítems seleccionados
              if (buildItems.isNotEmpty)
                const Text(
                  'Ítems seleccionados para Build:',
                  style: TextStyle(color: Colors.white),
                ),
              Wrap(
                children: buildItems
                    .map((item) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Chip(
                            label: Text(
                              item,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // Lista de ítems opcionales
              const Text('Selecciona los ítems opcionales:', style: TextStyle(color: Colors.white)),
              ExpansionTile(
                title: Container(
                  color: const Color(0xFF15242F),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ítems Opcionales',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${additionalItems.length}/6',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                children: [
                  SizedBox(
                    height: 200, // Tamaño fijo para la lista
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Container(
                            color: const Color(0xFFC79B3B),
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                hasInternet
                                    ? Image.network(
                                        _getItemImageUrl(filteredItems[index]['image_full']),
                                        width: 40,
                                        height: 40,
                                      )
                                    : Image.asset(
                                        'assets/images/defaultItem.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                const SizedBox(width: 10),
                                Text(
                                  filteredItems[index]['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          value: additionalItems.contains(filteredItems[index]['name']),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                if (additionalItems.length < 6) {
                                  additionalItems.add(filteredItems[index]['name']);
                                }
                              } else {
                               additionalItems.remove(filteredItems[index]['name']);
                              }
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.deepPurple,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Mostrar los ítems seleccionados adicionales
              if (additionalItems.isNotEmpty)
                const Text(
                  'Ítems opcionales seleccionados:',
                  style: TextStyle(color: Colors.white),
                ),
              Wrap(
                children: additionalItems
                    .map((item) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Chip(
                            label: Text(
                              item,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // Botón para guardar la build
              Center(
                child: ElevatedButton(
                  onPressed: _saveBuild, 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text(
                    'Guardar Build',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
