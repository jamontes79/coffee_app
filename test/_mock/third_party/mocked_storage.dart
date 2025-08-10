import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockedStorage extends Mock implements Storage {
  void mockWrite() {
    when(
      () => write(any(), any<dynamic>()),
    ).thenAnswer((_) async {});
  }
}
