import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supadots/core/enum.dart';

final dotTypeStateProvider = StateProvider<DotsType>(
  (ref) => DotsType.month,
);
