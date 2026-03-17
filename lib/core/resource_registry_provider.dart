import 'package:rank_hub/core/data_definition.dart';
import 'package:rank_hub/core/game_resource.dart';
import 'package:rank_hub/core/resource_key.dart';

/// 资源注册表实现
/// 管理所有游戏资源和工具的定义
class ResourceRegistryProvider implements ResourceRegistry {
  final Map<String, GameResourceDefinition> _resources = {};
  final Map<String, GameToolDefinition> _tools = {};

  /// 注册资源定义
  void registerResource<T>(GameResourceDefinition<T> definition) {
    final key = definition.key.fullKey;
    if (_resources.containsKey(key)) {
      throw Exception('Resource already registered: $key');
    }
    _resources[key] = definition;
  }

  /// 注册工具定义
  void registerTool<T>(GameToolDefinition<T> definition) {
    final key = definition.key.fullKey;
    if (_tools.containsKey(key)) {
      throw Exception('Tool already registered: $key');
    }
    _tools[key] = definition;
  }

  /// 批量注册资源
  void registerResources(List<GameResourceDefinition> definitions) {
    for (final def in definitions) {
      registerResource(def);
    }
  }

  /// 批量注册工具
  void registerTools(List<GameToolDefinition> definitions) {
    for (final def in definitions) {
      registerTool(def);
    }
  }

  /// 查找资源定义
  @override
  GameResourceDefinition<T>? find<T>(ResourceKey key) {
    final def =
        _resources[key.fullKey] ??
        (key.scope != null
            ? _resources[ResourceKey(namespace: key.namespace, name: key.name).fullKey]
            : null);
    if (def == null) return null;

    // 类型检查
    if (def is! GameResourceDefinition<T>) {
      throw Exception(
        'Type mismatch for resource ${key.fullKey}: '
        'expected GameResourceDefinition<$T>, got ${def.runtimeType}',
      );
    }

    return def;
  }

  /// 查找工具定义
  GameToolDefinition<T>? findTool<T>(ResourceKey key) {
    final def = _tools[key.fullKey];
    if (def == null) return null;

    // 类型检查
    if (def is! GameToolDefinition<T>) {
      throw Exception(
        'Type mismatch for tool ${key.fullKey}: '
        'expected GameToolDefinition<$T>, got ${def.runtimeType}',
      );
    }

    return def;
  }

  /// 检查资源是否已注册
  bool hasResource(ResourceKey key) {
    return _resources.containsKey(key.fullKey);
  }

  /// 检查工具是否已注册
  bool hasTool(ResourceKey key) {
    return _tools.containsKey(key.fullKey);
  }

  /// 获取所有资源定义
  List<GameResourceDefinition> getAllResources() {
    return _resources.values.toList();
  }

  /// 获取所有工具定义
  List<GameToolDefinition> getAllTools() {
    return _tools.values.toList();
  }

  /// 根据命名空间获取资源
  List<GameResourceDefinition> getResourcesByNamespace(String namespace) {
    return _resources.values
        .where((def) => def.key.namespace == namespace)
        .toList();
  }

  /// 根据命名空间获取工具
  List<GameToolDefinition> getToolsByNamespace(String namespace) {
    return _tools.values
        .where((def) => def.key.namespace == namespace)
        .toList();
  }

  /// 清空所有注册
  void clear() {
    _resources.clear();
    _tools.clear();
  }

  /// 移除指定资源
  void unregisterResource(ResourceKey key) {
    _resources.remove(key.fullKey);
  }

  /// 移除指定工具
  void unregisterTool(ResourceKey key) {
    _tools.remove(key.fullKey);
  }

  /// 获取资源统计信息
  Map<String, int> getStats() {
    return {
      'total_resources': _resources.length,
      'total_tools': _tools.length,
      'unique_namespaces': {
        ..._resources.values.map((def) => def.key.namespace),
        ..._tools.values.map((def) => def.key.namespace),
      }.length,
    };
  }
}
