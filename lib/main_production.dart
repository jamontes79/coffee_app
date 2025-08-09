import 'dart:async';

import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/bootstrap.dart';
import 'package:coffee_app/injection/injection.dart';
import 'package:injectable/injectable.dart';

Future<void> main() async {
  await configureInjection(Environment.prod);
  unawaited(bootstrap(() => const App()));
}
