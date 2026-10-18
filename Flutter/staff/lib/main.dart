/// Alam El Marateb Staff entrypoint.
///
/// Boot order: core DI → authenticated Dio → auth module → prime auth
/// state → router. Every step is shared code; app-specific pieces are
/// the router table and the home page only.
Future<void> main() async {
  runApp(const StaffApp());
}
