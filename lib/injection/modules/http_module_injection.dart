import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class HttpModuleInjection {
  http.Client get client => http.Client();
}
