import 'package:flutter/widgets.dart';

enum PaymentStatusEnum { paid, unpaid, partial }

extension PaymentStatusEnumX on PaymentStatusEnum {
  /// Stable API key used for backend communication.
  String get apiKey => name;

  /// Decoupled label lookup — the caller passes localized strings
  /// so this package never depends on generated l10n.
  String label({
    required String paid,
    required String unpaid,
    required String partial,
  }) {
    switch (this) {
      case PaymentStatusEnum.paid:
        return paid;
      case PaymentStatusEnum.unpaid:
        return unpaid;
      case PaymentStatusEnum.partial:
        return partial;
    }
  }

  /// Legacy BuildContext helper — only use once l10n keys are available
  /// in the app layer. Kept separate so the enum itself stays pure.
  String localizationMessage(
    BuildContext context,
    String Function(BuildContext context, PaymentStatusEnum status) resolve,
  ) {
    return resolve(context, this);
  }
}

PaymentStatusEnum? paymentStatusFromString(String? status) {
  if (status == null) return null;
  return PaymentStatusEnum.values.firstWhere(
    (e) => e.name == status,
    orElse: () => PaymentStatusEnum.unpaid,
  );
}
