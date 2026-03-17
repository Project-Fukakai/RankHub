import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/credential.dart';
import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/services/core_log_service.dart';

class MaimaiDivingFishCredentialProvider extends UserPasswordCredentialProvider {
  static const String baseUrl = 'https://www.diving-fish.com/api';
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  MaimaiDivingFishCredentialProvider() {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  @override
  PlatformId get platformId => const PlatformId('divingfish');

  Dio getDioWithCookies(Account account) {
    _applyToken(account);
    return _dio;
  }

  @override
  Future<bool> validateCredential(Account account) async {
    final username = account.username;
    final password = account.password;
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      return false;
    }

    try {
      await _performLogin(account);
      return true;
    } catch (e) {
      CoreLogService.w(
        '验证水鱼凭据失败: $e',
        scope: 'MAIMAI',
        platform: 'DIVINGFISH',
      );
      return false;
    }
  }

  @override
  Future<Account> getCredential(Account account) async {
    final username = account.username;
    final password = account.password;
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      throw CredentialExpiredException(account, '缺少用户名或密码');
    }

    if (_isTokenMissingOrExpired(account)) {
      await _performLogin(account);
    } else {
      _applyToken(account);
    }

    return account;
  }

  @override
  Future<Account> refreshCredential(Account account) async {
    await _performLogin(account);
    return account;
  }

  @override
  Future<void> createCredential(
    Account account,
    Map<String, dynamic> data,
  ) async {
    account.metadata['username'] = data['username'];
    account.metadata['password'] = data['password'];
    account.metadata['display_name'] = data['display_name'] ?? data['username'];
    account.metadata['external_id'] = data['external_id'] ?? data['username'];

    await _performLogin(account);
  }

  @override
  Future<void> revokeCredential(Account account) async {
    account.credentials.clear();
    account.metadata.remove('password');
    await _cookieJar.deleteAll();
  }

  bool _isTokenMissingOrExpired(Account account) {
    final token = account.cookie;
    if (token == null || token.isEmpty) {
      return true;
    }

    final credential = account.credential;
    if (credential.expiresAt == null) {
      return false;
    }
    return credential.isExpired;
  }

  void _applyToken(Account account) {
    final token = account.cookie;
    if (token == null || token.isEmpty) {
      return;
    }

    final cookie = Cookie('jwt_token', token);
    final expiry = account.credential.expiresAt;
    if (expiry != null) {
      cookie.expires = expiry;
    }
    _cookieJar.saveFromResponse(Uri.parse(baseUrl), [cookie]);
  }

  Future<void> _performLogin(Account account) async {
    final username = account.username;
    final password = account.password;
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      throw CredentialExpiredException(account, '缺少用户名或密码');
    }

    final response = await _dio.post(
      '$baseUrl/maimaidxprober/login',
      options: Options(
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
      data: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      throw CredentialExpiredException(account, '登录失败: 用户名或密码错误');
    }

    final cookies = await _cookieJar.loadForRequest(
      Uri.parse('$baseUrl/maimaidxprober/login'),
    );
    final jwtCookie = cookies.firstWhere(
      (cookie) => cookie.name == 'jwt_token',
      orElse: () => Cookie('jwt_token', ''),
    );
    if (jwtCookie.value.isEmpty) {
      throw CredentialExpiredException(account, '未获取到 JWT token');
    }

    final credential = CookieCredential(
      cookie: jwtCookie.value,
      expiresAt: jwtCookie.expires,
    );
    account.credentials
      ..clear()
      ..addAll(credential.toJson())
      ..['credential_updated_at'] = DateTime.now().toIso8601String();

    account.metadata['display_name'] =
        account.metadata['display_name'] ?? username;
    account.metadata['external_id'] =
        account.metadata['external_id'] ?? username;

    _applyToken(account);
  }
}
