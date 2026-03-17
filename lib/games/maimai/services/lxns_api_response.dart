/// Lxns API 响应结构
///
/// 所有 lxns API 遵循统一的响应格式：
/// ```json
/// {
///   "success": bool,     // 请求是否成功处理
///   "code": int,         // HTTP 状态码，通常为 200
///   "message": string?,  // 值可空，请求失败理由
///   "data": dynamic      // 值可空，请求结果 (dict 或 list)
/// }
/// ```
class LxnsApiResponse<T> {
  /// 请求是否成功处理
  final bool success;

  /// HTTP 状态码
  final int code;

  /// 请求失败理由（可空）
  final String? message;

  /// 请求结果（可空）
  final T? data;

  const LxnsApiResponse({
    required this.success,
    required this.code,
    this.message,
    this.data,
  });

  /// 从 JSON 解析响应
  ///
  /// 如果响应不遵循标准格式（没有 success/code/data 字段），
  /// 则将整个响应作为 data，并组装为标准响应格式
  factory LxnsApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? dataParser,
  }) {
    // 检查是否为标准响应格式
    final hasSuccessField = json.containsKey('success');
    final hasCodeField = json.containsKey('code');
    final hasDataField = json.containsKey('data');

    // 如果是标准格式，直接解析
    if (hasSuccessField || hasCodeField || hasDataField) {
      return LxnsApiResponse<T>(
        success: json['success'] as bool? ?? false,
        code: json['code'] as int? ?? 0,
        message: json['message'] as String?,
        data: json['data'] != null && dataParser != null
            ? dataParser(json['data'])
            : json['data'] as T?,
      );
    }

    // 如果不是标准格式，将整个 JSON 作为 data，组装为标准响应
    return LxnsApiResponse<T>(
      success: true, // 假设能成功获取到响应就是成功的
      code: 200,
      message: null,
      data: dataParser != null ? dataParser(json) : json as T?,
    );
  }

  /// 是否成功并有数据
  bool get hasData => success && data != null;

  /// 获取数据或抛出异常
  T get dataOrThrow {
    if (!success) {
      throw LxnsApiException(message: message ?? 'API 请求失败', code: code);
    }
    if (data == null) {
      throw LxnsApiException(message: '响应数据为空', code: code);
    }
    return data as T;
  }

  @override
  String toString() {
    return 'LxnsApiResponse(success: $success, code: $code, message: $message, data: $data)';
  }
}

/// Lxns API 异常
class LxnsApiException implements Exception {
  final String message;
  final int? code;
  final dynamic originalError;

  const LxnsApiException({
    required this.message,
    this.code,
    this.originalError,
  });

  /// 是否为404错误(玩家档案不存在)
  bool get isNotFound => code == 404;

  @override
  String toString() {
    if (code != null) {
      return 'LxnsApiException($code): $message';
    }
    return 'LxnsApiException: $message';
  }
}
