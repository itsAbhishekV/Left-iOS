import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/enum.dart';

final dotTypeStateProvider = StateProvider<DotsType>(
  (ref) => DotsType.month,
);
