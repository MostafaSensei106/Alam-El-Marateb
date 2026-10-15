import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Platform connectivity primitives for the network graph.
@module
abstract class NetworkModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
