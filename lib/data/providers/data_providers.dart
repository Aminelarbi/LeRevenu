import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';
import '../repositories/mock_home_repository.dart';

/// Provider that exposes the [HomeRepository] abstraction.
/// By injecting this provider, UI widgets and controllers remain independent
/// of the concrete mock data layer, allowing easy swapping in the future.
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const MockHomeRepository();
});
