import 'package:flutter/widgets.dart';

enum PaymentStatusEnum { paid, unpaid, partial }

extension PaymentStatusEnumX on PaymentStatusEnum {
  String localizationMessage(BuildContext context) {
    switch (this) {
      case PaymentStatusEnum.paid:
        return context.localizationKeys.paid;
      case PaymentStatusEnum.unpaid:
        return context.localizationKeys.unpaid;
      case PaymentStatusEnum.partial:
        return context.localizationKeys.partial;
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
