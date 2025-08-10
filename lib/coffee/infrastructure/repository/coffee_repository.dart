import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Repository for managing coffee data, including fetching random coffee data,
/// saving and removing favorite coffees, and streaming favorite coffees.
@lazySingleton
class CoffeeRepository {
  CoffeeRepository(this._client, this._getStorage);

  final http.Client _client;
  final GetStorage _getStorage;

  final _key = 'favorite_coffees';

  /// Fetches random coffee data from an external API.
  /// Returns a [Map<String, dynamic>] containing coffee data.
  /// Throws an [Exception] if the request fails.
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

  /// Saves a coffee to the favorites list.
  /// If the coffee is already in the favorites, it will not be added again.
  /// The coffee is stored as a JSON string in the GetStorage.
  /// Throws an [Exception] if the operation fails.
  ///
  /// [coffee] is a [Map<String, dynamic>] representing the coffee data.
  /// Example: `{'url': 'https://example.com/coffee.jpg'}`
  Future<void> saveFavoriteCoffee(Map<String, dynamic> coffee) async {
    final encodedCoffee = jsonEncode(coffee);
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    if (!favoriteCoffees.contains(encodedCoffee)) {
      favoriteCoffees.add(encodedCoffee);
      await _getStorage.write(_key, favoriteCoffees);
    }
  }

  /// Removes a coffee from the favorites list.
  /// If the coffee is not in the favorites, it will not be removed.
  /// The coffee is identified by its JSON string representation.
  /// Throws an [Exception] if the operation fails.
  Future<void> removeFavoriteCoffee(Map<String, dynamic> coffee) async {
    final encodedCoffee = jsonEncode(coffee);
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    if (favoriteCoffees.contains(encodedCoffee)) {
      favoriteCoffees.remove(encodedCoffee);
      await _getStorage.write(_key, favoriteCoffees);
    }
  }

  /// Streams the list of favorite coffees.
  /// The stream emits a list of coffees, where each coffee is represented as a
  /// [Map<String, dynamic>].
  /// The list is updated whenever a favorite coffee is added or removed.
  /// The coffees are stored as JSON strings in the GetStorage.
  /// Example of a coffee map: `{'url': 'https://example.com/coffee.jpg'}`
  /// Returns a [Stream] of lists of coffee maps.
  /// Each map contains the coffee data,
  /// such as the URL of the coffee image.
  /// The stream will emit an empty list if there are no favorite coffees.
  /// The stream will automatically close when the controller is canceled.
  /// Throws an [Exception] if the stream cannot be created.
  ///
  /// Example of a list of coffee maps:
  /// `[{'url': 'https://example.com/coffee1.jpg'}, {'url': 'https://example.com/coffee2.jpg'}]`
  Stream<List<Map<String, dynamic>>> getFavoriteCoffees() {
    final controller = StreamController<List<Map<String, dynamic>>>();
    void emitFavorites(_) {
      controller.add(_getFavoriteCoffeesList());
    }

    emitFavorites(null);

    _getStorage.listenKey(_key, emitFavorites);

    controller.onCancel = controller.close;
    return controller.stream;
  }

  /// Retrieves the list of favorite coffees from the GetStorage.
  /// The coffees are stored as JSON strings and are decoded into a list of maps
  /// Each map contains the coffee data, such as the URL of the coffee image.
  /// Returns a [List<Map<String, dynamic>]> containing the favorite coffees.
  /// If there are no favorite coffees, an empty list is returned.
  /// Throws an [Exception] if the data cannot be retrieved.
  List<Map<String, dynamic>> _getFavoriteCoffeesList() {
    final favoriteCoffees = _getStorage.read<List<dynamic>>(_key) ?? [];
    return favoriteCoffees
        .map((coffee) => jsonDecode(coffee as String) as Map<String, dynamic>)
        .toList();
  }
}
