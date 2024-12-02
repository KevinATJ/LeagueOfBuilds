import 'package:flutter/material.dart';
import '/Models/builds_data_base.dart';
import '/Models/items_data_base.dart';
import '/Models/champions_data_base.dart';
import 'package:league_of_builds/main.dart';

// Página Home
class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _buildsFuture;
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  late Future<List<Map<String, dynamic>>> _championsFuture;

  @override
  void initState() {
    super.initState();
    _buildsFuture = BuildsDataBase.instance.fetchBuilds();
    _itemsFuture = ItemsDataBase.instance.fetchItems();
    _championsFuture = ChampionsDataBase.instance.fetchChampions();
  }

  Future<String> _getChampionImageUrl(String championName) async {
    List<Map<String, dynamic>> champions = await _championsFuture;
    var champion = champions.firstWhere(
      (champion) => champion['name'] == championName,
      orElse: () => {},
    );
    return champion.isNotEmpty
        ? 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/champion/${champion['image_full']}'
        : '';
  }

  Future<String> _getItemImageUrl(String itemName) async {
    List<Map<String, dynamic>> items = await _itemsFuture;
    var item = items.firstWhere(
      (item) => item['name'] == itemName,
      orElse: () => {},
    );
    return item.isNotEmpty
        ? 'https://ddragon.leagueoflegends.com/cdn/$latestApiVersion/img/item/${item['image_full']}'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1D334A),
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              // Icono de la aplicación y texto de bienvenida
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFC79B3B), width: 4.0),
                ),
                child: Image.asset(
                  'assets/icons/app_icon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '¡Bienvenido!\n*Ruidos de poro*',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Últimas builds creadas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _buildsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<Map<String, dynamic>> builds = snapshot.data ?? [];
                    if (builds.isEmpty) {
                      return const Center(
                        child: Text(
                          'Todavía no haz creado ninguna build.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFFFF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: builds.length < 3 ? builds.length : 3,
                      itemBuilder: (context, index) {
                        var build = builds.reversed.toList()[index]; // Últimos builds
                        return FutureBuilder<String>(
                          future: _getChampionImageUrl(build['champion']),
                          builder: (context, championSnapshot) {
                            if (!championSnapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return FutureBuilder<List<String>>(
                              future: Future.wait([
                                _getItemImageUrl(build['item1']),
                                _getItemImageUrl(build['item2']),
                                _getItemImageUrl(build['item3']),
                                _getItemImageUrl(build['item4']),
                                _getItemImageUrl(build['item5']),
                                _getItemImageUrl(build['item6']),
                                _getItemImageUrl(build['additionalItem1']),
                                _getItemImageUrl(build['additionalItem2']),
                                _getItemImageUrl(build['additionalItem3']),
                                _getItemImageUrl(build['additionalItem4']),
                                _getItemImageUrl(build['additionalItem5']),
                                _getItemImageUrl(build['additionalItem6']),
                              ]),
                              builder: (context, itemSnapshot) {
                                if (!itemSnapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                List<String> itemUrls = itemSnapshot.data!.sublist(0, 6);
                                List<String> optionalItemUrls = itemSnapshot.data!.sublist(6, 12);

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  color: const Color(0xFF15242F),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Información del campeón y nombre de la build
                                        Row(
                                          children: [
                                            Image.network(
                                              championSnapshot.data!,
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
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        // Ítems de la build
                                        const Text(
                                          'Ítems principales:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          spacing: 8,
                                          children: itemUrls
                                              .map((url) => Image.network(
                                                    url,
                                                    width: 40,
                                                    height: 40,
                                                  ))
                                              .toList(),
                                        ),
                                        const SizedBox(height: 10),

                                        // Ítems opcionales
                                        const Text(
                                          'Ítems opcionales:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          spacing: 8,
                                          children: optionalItemUrls
                                              .map((url) => Image.network(
                                                    url,
                                                    width: 40,
                                                    height: 40,
                                                  ))
                                              .toList(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

