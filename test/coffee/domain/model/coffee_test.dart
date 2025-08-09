import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Coffee, () {
    test('coffee should be comparable', () {
      const coffee1 = Coffee(url: 'https://example.com/coffee1.jpg');
      const coffee2 = Coffee(url: 'https://example.com/coffee1.jpg');

      expect(coffee1 == coffee2, isTrue);
    });

    test('coffee should be mapped to JSON', () {
      const coffee = Coffee(url: 'https://example.com/coffee1.jpg');
      final json = coffee.toJson();

      expect(json, {'url': 'https://example.com/coffee1.jpg'});
    });

    test('coffee should be created from JSON', () {
      final json = {'url': 'https://example.com/coffee1.jpg'};
      final coffee = Coffee.fromJson(json);

      expect(coffee.url, 'https://example.com/coffee1.jpg');
    });
  });
}
