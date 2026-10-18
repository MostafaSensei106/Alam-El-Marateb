abstract final class NetworkTimeouts {
  static const Duration connect = Duration(seconds: 15);
  static const Duration receive = Duration(seconds: 30);
  static const Duration send = Duration(seconds: 30);
}
