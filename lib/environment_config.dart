import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  // Add api key by running 'flutter run --dart-define=movieApiKey=07f7859ba2562267346cd7f26d9538f6'
  final movieApiKey =
      '07f7859ba2562267346cd7f26d9538f6'; //const String.fromEnvironment("movieApiKey");
}

// Riverpod provider
final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
