// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://192.168.1.9:8080';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<LoginResponseData>> login(LoginRequestBody body) async {
    final _extra = <String, dynamic>{'requireToken': false};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<LoginResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/auth/login',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<LoginResponseData> _value;
    try {
      _value = ApiResponse<LoginResponseData>.fromJson(
        _result.data!,
        (json) => LoginResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<LoginResponseData>> refreshToken(
    RefreshTokenRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': false};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<LoginResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/auth/refresh',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<LoginResponseData> _value;
    try {
      _value = ApiResponse<LoginResponseData>.fromJson(
        _result.data!,
        (json) => LoginResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AuthProfileResponseData>> authMe() async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AuthProfileResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/auth/me',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AuthProfileResponseData> _value;
    try {
      _value = ApiResponse<AuthProfileResponseData>.fromJson(
        _result.data!,
        (json) =>
            AuthProfileResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<AccountResponseData>>> getAccounts() async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<AccountResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/chart-of-accounts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<AccountResponseData>> _value;
    try {
      _value = ApiResponse<List<AccountResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<AccountResponseData>(
                    (i) =>
                        AccountResponseData.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AccountResponseData>> createAccount(
    CreateAccountRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<AccountResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/chart-of-accounts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AccountResponseData> _value;
    try {
      _value = ApiResponse<AccountResponseData>.fromJson(
        _result.data!,
        (json) => AccountResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AccountResponseData>> getAccount(
    String accountCode,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<AccountResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/chart-of-accounts/${accountCode}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AccountResponseData> _value;
    try {
      _value = ApiResponse<AccountResponseData>.fromJson(
        _result.data!,
        (json) => AccountResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<AccountResponseData>> updateAccount(
    String accountCode,
    UpdateAccountRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<AccountResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/chart-of-accounts/${accountCode}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<AccountResponseData> _value;
    try {
      _value = ApiResponse<AccountResponseData>.fromJson(
        _result.data!,
        (json) => AccountResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<JournalResponseData>>> getJournalEntries({
    String? branchId,
    String? from,
    String? to,
    String? source,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{
      r'branchId': branchId,
      r'from': from,
      r'to': to,
      r'source': source,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<JournalResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/journal-entries',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<JournalResponseData>> _value;
    try {
      _value = ApiResponse<List<JournalResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<JournalResponseData>(
                    (i) =>
                        JournalResponseData.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<JournalResponseData>> postJournalEntry(
    PostJournalRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<JournalResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/journal-entries',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<JournalResponseData> _value;
    try {
      _value = ApiResponse<JournalResponseData>.fromJson(
        _result.data!,
        (json) => JournalResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<JournalResponseData>> getJournalEntry(
    String journalId,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<JournalResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/journal-entries/${journalId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<JournalResponseData> _value;
    try {
      _value = ApiResponse<JournalResponseData>.fromJson(
        _result.data!,
        (json) => JournalResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<LedgerLineResponseData>>> getGeneralLedger({
    String? accountCode,
    String? from,
    String? to,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{
      r'accountCode': accountCode,
      r'from': from,
      r'to': to,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<LedgerLineResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/general-ledger',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<LedgerLineResponseData>> _value;
    try {
      _value = ApiResponse<List<LedgerLineResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<LedgerLineResponseData>(
                    (i) => LedgerLineResponseData.fromJson(
                      i as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<TreasuryResponseData>>> getTreasuries({
    String? branchId,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'branchId': branchId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<TreasuryResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<TreasuryResponseData>> _value;
    try {
      _value = ApiResponse<List<TreasuryResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<TreasuryResponseData>(
                    (i) => TreasuryResponseData.fromJson(
                      i as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TreasuryResponseData>> createTreasury(
    CreateTreasuryRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<TreasuryResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TreasuryResponseData> _value;
    try {
      _value = ApiResponse<TreasuryResponseData>.fromJson(
        _result.data!,
        (json) => TreasuryResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TreasuryResponseData>> getTreasury(
    String treasuryId,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<TreasuryResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries/${treasuryId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TreasuryResponseData> _value;
    try {
      _value = ApiResponse<TreasuryResponseData>.fromJson(
        _result.data!,
        (json) => TreasuryResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TreasuryResponseData>> updateTreasury(
    String treasuryId,
    UpdateTreasuryRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<TreasuryResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries/${treasuryId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TreasuryResponseData> _value;
    try {
      _value = ApiResponse<TreasuryResponseData>.fromJson(
        _result.data!,
        (json) => TreasuryResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<TransferResponseData>>> getTransfers({
    String? treasuryId,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'treasuryId': treasuryId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<TransferResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries/transfers',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<TransferResponseData>> _value;
    try {
      _value = ApiResponse<List<TransferResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<TransferResponseData>(
                    (i) => TransferResponseData.fromJson(
                      i as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TransferResponseData>> createTransfer(
    TransferRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<TransferResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries/transfers',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TransferResponseData> _value;
    try {
      _value = ApiResponse<TransferResponseData>.fromJson(
        _result.data!,
        (json) => TransferResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TransferResponseData>> getTransfer(
    String transferId,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<TransferResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/treasuries/transfers/${transferId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TransferResponseData> _value;
    try {
      _value = ApiResponse<TransferResponseData>.fromJson(
        _result.data!,
        (json) => TransferResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<ExpenseResponseData>>> getExpenses({
    String? branchId,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'branchId': branchId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<ExpenseResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/expenses',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<ExpenseResponseData>> _value;
    try {
      _value = ApiResponse<List<ExpenseResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<ExpenseResponseData>(
                    (i) =>
                        ExpenseResponseData.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ExpenseResponseData>> createExpense(
    ExpenseRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<ExpenseResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/expenses',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ExpenseResponseData> _value;
    try {
      _value = ApiResponse<ExpenseResponseData>.fromJson(
        _result.data!,
        (json) => ExpenseResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ExpenseResponseData>> getExpense(String expenseId) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<ExpenseResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/expenses/${expenseId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ExpenseResponseData> _value;
    try {
      _value = ApiResponse<ExpenseResponseData>.fromJson(
        _result.data!,
        (json) => ExpenseResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ExpenseResponseData>> updateExpense(
    String expenseId,
    UpdateExpenseRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<ExpenseResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/expenses/${expenseId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ExpenseResponseData> _value;
    try {
      _value = ApiResponse<ExpenseResponseData>.fromJson(
        _result.data!,
        (json) => ExpenseResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<List<CheckResponseData>>> getChecks({
    String? status,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'status': status};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<List<CheckResponseData>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/checks',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<List<CheckResponseData>> _value;
    try {
      _value = ApiResponse<List<CheckResponseData>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<CheckResponseData>(
                    (i) =>
                        CheckResponseData.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CheckResponseData>> createCheck(
    CheckRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<CheckResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/checks',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CheckResponseData> _value;
    try {
      _value = ApiResponse<CheckResponseData>.fromJson(
        _result.data!,
        (json) => CheckResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CheckResponseData>> getCheck(String checkId) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<CheckResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/checks/${checkId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CheckResponseData> _value;
    try {
      _value = ApiResponse<CheckResponseData>.fromJson(
        _result.data!,
        (json) => CheckResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CheckResponseData>> updateCheck(
    String checkId,
    UpdateCheckRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<CheckResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/checks/${checkId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CheckResponseData> _value;
    try {
      _value = ApiResponse<CheckResponseData>.fromJson(
        _result.data!,
        (json) => CheckResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<CheckResponseData>> updateCheckStatus(
    String checkId,
    CheckStatusRequestBody body,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<ApiResponse<CheckResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/checks/${checkId}/status',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<CheckResponseData> _value;
    try {
      _value = ApiResponse<CheckResponseData>.fromJson(
        _result.data!,
        (json) => CheckResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<ProfitLossResponseData>> getProfitLoss({
    String? from,
    String? to,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'from': from, r'to': to};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<ProfitLossResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/reports/profit-loss',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<ProfitLossResponseData> _value;
    try {
      _value = ApiResponse<ProfitLossResponseData>.fromJson(
        _result.data!,
        (json) => ProfitLossResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<TaxReportResponseData>> getTaxReport({
    String? from,
    String? to,
  }) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'from': from, r'to': to};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<TaxReportResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/reports/tax',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<TaxReportResponseData> _value;
    try {
      _value = ApiResponse<TaxReportResponseData>.fromJson(
        _result.data!,
        (json) => TaxReportResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiResponse<BalanceSheetResponseData>> getBalanceSheet(
    String to,
  ) async {
    final _extra = <String, dynamic>{'requireToken': true};
    final queryParameters = <String, dynamic>{r'to': to};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApiResponse<BalanceSheetResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.1.9:8080/api/v1/accounting/reports/balance-sheet',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<BalanceSheetResponseData> _value;
    try {
      _value = ApiResponse<BalanceSheetResponseData>.fromJson(
        _result.data!,
        (json) =>
            BalanceSheetResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
