import 'package:rank_hub/core/credential.dart';

class Account {
  final String platformId;
  final Map<String, dynamic> credentials;
  final String? displayName;
  final String? avatarUrl;
  final Map<String, dynamic> metadata;

  Account({
    required this.platformId,
    required this.credentials,
    this.displayName,
    this.avatarUrl,
    Map<String, dynamic>? metadata,
  }) : metadata = Map<String, dynamic>.from(metadata ?? const {});

  Credential get credential => Credential.fromJson(credentials);

  String? get externalId {
    return metadata['external_id'] ??
        metadata['user_id'] ??
        metadata['username'] ??
        credentials['external_id'] ??
        credentials['user_id'] ??
        credentials['username']?.toString();
  }

  String? get username {
    return metadata['username'] ??
        credentials['username']?.toString();
  }

  String? get password {
    return metadata['password'] ??
        credentials['password']?.toString();
  }

  String? get apiKey {
    final cred = credential;
    if (cred is ApiKeyCredential) return cred.apiKey;
    return credentials['api_key']?.toString();
  }

  String? get accessToken {
    final cred = credential;
    if (cred is JwtCredential) return cred.token;
    return credentials['access_token']?.toString();
  }

  String? get cookie {
    final cred = credential;
    if (cred is CookieCredential) return cred.cookie;
    return credentials['cookie']?.toString() ??
        credentials['cookie_header']?.toString();
  }

  String? get resolvedDisplayName {
    return displayName ??
        metadata['display_name'] ??
        metadata['displayName'] ??
        credentials['display_name'] ??
        credentials['displayName'] ??
        credentials['username']?.toString();
  }

  String? get resolvedAvatarUrl {
    return avatarUrl ??
        metadata['avatar_url'] ??
        metadata['avatarUrl'] ??
        credentials['avatar_url'] ??
        credentials['avatarUrl']?.toString();
  }

  Account copyWith({
    String? platformId,
    Map<String, dynamic>? credentials,
    String? displayName,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Account(
      platformId: platformId ?? this.platformId,
      credentials: credentials ?? this.credentials,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
