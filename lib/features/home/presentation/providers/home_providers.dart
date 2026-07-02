import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/providers/data_providers.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_state.dart';

/// Riverpod provider exposing our [HomeController] and its [HomeState].
/// Automatically listens to [homeRepositoryProvider] to inject the mock data source.
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final repository = ref.watch(homeRepositoryProvider);
    return HomeController(repository);
  },
);
