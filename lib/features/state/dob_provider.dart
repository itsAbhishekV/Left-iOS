import 'package:flutter_riverpod/flutter_riverpod.dart';

final dobProvider = StateProvider<String>(
  (ref) => DateTime.now().toIso8601String(),
);
