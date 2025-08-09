import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class CoffeeRepository {
  CoffeeRepository(this._client, this._getStorage);

  final http.Client _client;
  final GetStorage _getStorage;

  final _key = 'favorite_coffees';

  Future<Map<String, dynamic>> fetchCoffeeData() async {
    final response = await _client.get(
      Uri.parse('https://coffee.alexflipnote.dev/random.json'),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } else {
      throw Exception('Failed to load coffee data');
    }
  }

  Future<void> saveFavoriteCoffee(Map<String, dynamic> coffee) async {
    final encodedCoffee = jsonEncode(coffee);
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    if (!favoriteCoffees.contains(encodedCoffee)) {
      favoriteCoffees.add(encodedCoffee);
      await _getStorage.write(_key, favoriteCoffees);
    }
  }

  Future<void> removeFavoriteCoffee(Map<String, dynamic> coffee) async {
    final encodedCoffee = jsonEncode(coffee);
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    if (favoriteCoffees.contains(encodedCoffee)) {
      favoriteCoffees.remove(encodedCoffee);
      await _getStorage.write(_key, favoriteCoffees);
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteCoffees() async {
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    return favoriteCoffees
        .map((coffee) => jsonDecode(coffee as String) as Map<String, dynamic>)
        .toList();
  }
}
