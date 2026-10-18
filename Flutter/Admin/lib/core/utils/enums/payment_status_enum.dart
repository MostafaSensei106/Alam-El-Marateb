import 'package:flutter/widgets.dart';

import '../../../core/extensions/extensions.dart';

enum PaymentStatusEnum { paid, unpaid, partial }

extension PaymentStatusEnumX on PaymentStatusEnum {
  String get apiKey {
    return name;
  }

  String localizationMessage(BuildContext context) {
    switch (this) {
      case PaymentStatusEnum.paid:
        return context.localeKeys.paid;
      case PaymentStatusEnum.unpaid:
        return context.localeKeys.unpaid;
      case PaymentStatusEnum.partial:
        return context.localeKeys.partial;
    }
  }
}

PaymentStatusEnum? paymentStatusFromString(String? status) {
  if (status == null) return null;
  return PaymentStatusEnum.values.firstWhere(
    (e) => e.name == status,
    orElse: () => PaymentStatusEnum.unpaid,
  );
}
