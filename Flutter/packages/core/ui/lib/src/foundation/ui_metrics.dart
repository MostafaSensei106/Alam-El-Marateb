/// Component metrics that belong to the UI layer (not app constants).
///
/// Mapped 1:1 from the old monolith's `AppConfig` values so visuals stay
/// pixel-identical after the port.
final class UiMetrics {
  UiMetrics._();

  /// Standard button height (was `AppConfig.buttonHeight`).
  static const double buttonHeight = 50;

  /// OTP field box size (was `AppConfig.otpFieldSize`).
  static const double otpFieldSize = 50;
}
