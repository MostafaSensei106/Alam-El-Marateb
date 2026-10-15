// Canonical failure types now live in `alam_el_marateb_result` (Layer 0)
// so both `Result` and `Failure` share one dependency-free home.
// This re-export keeps existing `package:alam_el_marateb_utils` imports
// working during the migration. New code should import failures from
// `package:alam_el_marateb_result/result.dart` directly.
export 'package:alam_el_marateb_result/result.dart'
    show
        Failure,
        ServerFailure,
        CacheFailure,
        CooldownFailure,
        NetworkFailure,
        OfflineFailure,
        TimeoutFailure,
        LocalStorageFailure,
        BadResponseParsingFailure,
        UnknownFailure;
