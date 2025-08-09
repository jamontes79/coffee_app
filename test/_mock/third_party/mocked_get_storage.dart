import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockedGetStorage extends Mock implements GetStorage {
  void mockWrite({required String key, required List<dynamic> value}) {
    when(
      () => write(key, value),
    ).thenAnswer((_) async {});
  }

  void mockRead({required String key, required List<dynamic>? expected}) {
    when(
      () => read<List<dynamic>>(key),
    ).thenReturn(expected);
  }
}
