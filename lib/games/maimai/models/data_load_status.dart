/// 数据加载状态
enum DataLoadStatus {
  /// 空闲状态(未开始加载)
  idle,

  /// 从数据库加载中
  loadingFromDb,

  /// 从 API 加载中
  loadingFromApi,

  /// 加载成功
  success,

  /// 加载失败
  error,
}
