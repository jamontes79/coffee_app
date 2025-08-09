import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockedHttpClient extends Mock implements http.Client {
  void mockGet({required Uri uri, required http.Response expected}) {
    when(
      () => get(uri),
    ).thenAnswer((_) async => expected);
  }
}
