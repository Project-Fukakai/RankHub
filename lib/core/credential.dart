import 'dart:convert';

const Duration kDefaultExpiryBuffer = Duration(minutes: 5);

enum CredentialType {
  apiKey,
  jwt,
  cookie,
  unknown,
}

typedef CredentialRefresher = Future<Credential> Function(Credential current);

class CredentialRefreshException implements Exception {
  final String message;
  CredentialRefreshException(this.message);

  @override
  String toString() => message;
}

abstract class Credential {
  CredentialType get type;
  DateTime? get expiresAt;
  bool get canRefresh;

  bool get isExpired {
    final expiry = expiresAt;
    if (expiry == null) return false;
    return DateTime.now().toUtc().isAfter(expiry.toUtc());
  }

  bool isExpiringSoon([Duration buffer = kDefaultExpiryBuffer]) {
    final expiry = expiresAt;
    if (expiry == null) return false;
    return DateTime.now().toUtc().add(buffer).isAfter(expiry.toUtc());
  }

  bool get shouldRefresh => isExpired || isExpiringSoon();

  Future<Credential> refreshWith(CredentialRefresher refresher) async {
    if (!canRefresh) {
      throw CredentialRefreshException('凭据不支持刷新');
    }
    return await refresher(this);
  }

  Future<Credential> ensureValid(
    CredentialRefresher refresher, {
    Duration buffer = kDefaultExpiryBuffer,
  }) async {
    if (!isExpired && !isExpiringSoon(buffer)) return this;
    return refreshWith(refresher);
  }

  Map<String, dynamic> toJson();

  static Credential fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return UnknownCredential(const {});
    }

    final type = json['type'];
    if (type is String) {
      switch (type) {
        case 'api_key':
          return ApiKeyCredential(
            apiKey: json['api_key'] as String? ?? '',
            expiresAt: _parseExpiry(json),
          );
        case 'jwt':
          return JwtCredential(
            token: json['token'] as String? ?? '',
            refreshToken: json['refresh_token'] as String?,
            expiresAt: _parseExpiry(json),
          );
        case 'cookie':
          return CookieCredential(
            cookie: json['cookie'] as String? ?? '',
            refreshToken: json['refresh_token'] as String?,
            expiresAt: _parseExpiry(json),
          );
        default:
          return UnknownCredential(Map<String, dynamic>.from(json));
      }
    }

    if (json['api_key'] is String) {
      return ApiKeyCredential(
        apiKey: json['api_key'] as String,
        expiresAt: _parseExpiry(json),
      );
    }

    final jwtToken = json['jwt_token'] as String?;
    final accessToken = json['access_token'] as String?;
    if ((jwtToken ?? accessToken) is String) {
      return JwtCredential(
        token: jwtToken ?? accessToken ?? '',
        refreshToken: json['refresh_token'] as String?,
        expiresAt: _parseExpiry(json),
      );
    }

    if (json['cookie'] is String || json['cookie_header'] is String) {
      return CookieCredential(
        cookie: (json['cookie'] as String?) ?? (json['cookie_header'] as String? ?? ''),
        refreshToken: json['refresh_token'] as String?,
        expiresAt: _parseExpiry(json),
      );
    }

    return UnknownCredential(Map<String, dynamic>.from(json));
  }

  static DateTime? _parseExpiry(Map<String, dynamic> json) {
    final value = json['expires_at'] ?? json['token_expiry'] ?? json['expiry'];
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000, isUtc: true);
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

class ApiKeyCredential extends Credential {
  final String apiKey;
  @override
  final DateTime? expiresAt;

  ApiKeyCredential({required this.apiKey, this.expiresAt});

  @override
  CredentialType get type => CredentialType.apiKey;

  @override
  bool get canRefresh => false;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'api_key',
      'api_key': apiKey,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }
}

class JwtCredential extends Credential {
  final String token;
  final String? refreshToken;
  final DateTime? _expiresAt;

  JwtCredential({
    required this.token,
    this.refreshToken,
    DateTime? expiresAt,
  }) : _expiresAt = expiresAt;

  @override
  CredentialType get type => CredentialType.jwt;

  @override
  DateTime? get expiresAt => _expiresAt ?? _parseJwtExpiry(token);

  @override
  bool get canRefresh => refreshToken != null && (refreshToken?.isNotEmpty ?? false);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'jwt',
      'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }
}

class CookieCredential extends Credential {
  final String cookie;
  final String? refreshToken;
  @override
  final DateTime? expiresAt;

  CookieCredential({
    required this.cookie,
    this.refreshToken,
    this.expiresAt,
  });

  @override
  CredentialType get type => CredentialType.cookie;

  @override
  bool get canRefresh => refreshToken != null && (refreshToken?.isNotEmpty ?? false);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'cookie',
      'cookie': cookie,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }
}

class UnknownCredential extends Credential {
  final Map<String, dynamic> data;

  UnknownCredential(this.data);

  @override
  CredentialType get type => CredentialType.unknown;

  @override
  DateTime? get expiresAt => Credential._parseExpiry(data);

  @override
  bool get canRefresh => false;

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(data);
}

DateTime? _parseJwtExpiry(String token) {
  if (token.isEmpty) return null;
  final parts = token.split('.');
  if (parts.length != 3) return null;

  try {
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadJson = jsonDecode(payload);
    final exp = payloadJson is Map<String, dynamic> ? payloadJson['exp'] : null;
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }
    if (exp is num) {
      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
    }
  } catch (_) {
    return null;
  }
  return null;
}
