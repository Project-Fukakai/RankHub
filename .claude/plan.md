# RankHub 架构重构计划

## 目标

将 RankHub 从"平台/账号优先"架构迁移到"游戏优先"架构，采用渐进式迁移策略。在现有 `core/` 层基础上完善，将 UI Shell 迁移到 Riverpod，旧 GetX 代码暂时保留并逐步迁移。

## 核心设计变更

**现状**: 用户选账号 → 决定平台 → 决定可用游戏 → 展示内容
**目标**: 用户选游戏 → 游戏通过 Descriptor 自描述页面/资源/工具 → 按需关联账号

## 分层架构

```
UI Shell (Riverpod + GoRouter)
  ↓
ViewModel (Riverpod Notifier/AsyncNotifier)
  ↓
GameDescriptor / UseCase
  ↓
Repository / PlatformAdapter
  ↓
Platform / Isar / SharedPreferences
```

---

## Phase 1: 核心基础设施完善

在现有 `core/` 基础上补充缺失的层。

### 1.1 完善 GameDescriptor 体系

现有 `core/geme_descriptor.dart` 已有 `GameDescriptor`（含 libraryPages / scorePages / toolboxPages / profilePages / resources / tools），基本满足需求。需要补充：

**修改文件**:
- `lib/core/geme_descriptor.dart` → 重命名为 `lib/core/game_descriptor.dart`（修正拼写）
- 在 `GameDescriptor` 中增加可选字段：
  - `String? iconUrl` — 游戏图标
  - `Color? themeColor` — 游戏主题色
  - `List<String> supportedPlatformIds` — 支持的平台 ID 列表

**修改文件**:
- `lib/core/page_descriptor.dart` — 增加可选字段：
  - `bool requiresAccount` — 该页面是否需要登录账号（默认 false）
  - `List<Widget> Function(BuildContext)? actionsBuilder` — AppBar 操作按钮
  - `Widget Function(BuildContext)? fabBuilder` — FAB

### 1.2 新增 ViewModel 层

创建 Riverpod 化的 ViewModel 替代 GetX Controller。

**新建文件**:
- `lib/core/viewmodels/main_view_model.dart` — 替代 `MainController`
  - `currentTabIndex` 状态
  - `changeTab(int index)` 方法

- `lib/core/viewmodels/game_selection_view_model.dart` — 替代 `GameController`
  - `selectedGame` 状态（全局唯一，不再区分 Wiki/Rank）
  - `availableGames` — 所有已注册游戏列表（不依赖账号）
  - `selectGame(Game game)` — 切换游戏，持久化到 SharedPreferences
  - `restoreLastGame()` — 恢复上次选择

- `lib/core/viewmodels/account_view_model.dart` — 替代 `AccountController`
  - `accounts` — 所有账号列表
  - `currentAccount` — 当前游戏下的活跃账号
  - `accountsForCurrentGame` — 当前游戏支持的平台的账号
  - `bindAccount(...)` / `unbindAccount(...)` / `switchAccount(...)`
  - 依赖 `gameSelectionViewModel` — 游戏切换时自动更新可用账号

### 1.3 新增 Repository 层

**新建文件**:
- `lib/core/repositories/account_repository.dart`
  - 封装 `AccountService`（Isar）和 `SharedPreferences` 的账号持久化
  - 提供纯数据操作，不含 UI 逻辑（不再有 `Get.snackbar`）

- `lib/core/repositories/game_repository.dart`
  - 封装游戏选择的持久化（SharedPreferences）
  - 提供游戏列表查询（从 GameRegistry）

### 1.4 完善 CoreProvider 初始化

**修改文件**: `lib/core/core_provider.dart`
- 增加 `registerPlatformModule(...)` 便捷方法，一次性注册平台、游戏、适配器、凭据提供者、登录处理器
- 增加 `initializeFromRegistry()` — 从 `PlatformRegistry`（旧）批量导入到新注册表

---

## Phase 2: UI Shell 迁移（MainPage → Riverpod）

### 2.1 新建 Riverpod 版 MainPage

**新建文件**: `lib/pages/main_page_v2.dart`
- 使用 `ConsumerWidget` 替代 `GetView<MainController>`
- 读取 `mainViewModelProvider` 获取 tab 状态
- 保持现有 5 Tab 布局（社区/资料库/成绩/工具箱/我的）
- 保持宽屏 NavigationRail / 窄屏 NavigationBar 的响应式布局
- 保持 blur 效果和 AnimatedSwitcher 过渡动画

### 2.2 新建 Riverpod 版内容页面

**新建文件**:
- `lib/pages/wiki_v2.dart` — ConsumerWidget
  - 从 `gameSelectionViewModel` 获取当前游戏
  - 从 `game.descriptor.libraryPages` 获取页面列表
  - 游戏选择器从 `availableGames` 获取列表（不再依赖账号）
  - 单页面直接展示，多页面自动 TabView

- `lib/pages/rank_v2.dart` — ConsumerWidget
  - 从 `game.descriptor.scorePages` 获取页面列表
  - 需要账号的页面（`requiresAccount == true`）在未登录时显示引导

- `lib/pages/toolbox_v2.dart` — ConsumerWidget
  - 从 `game.descriptor.toolboxPages` 获取页面列表

- `lib/pages/mine_v2.dart` — ConsumerWidget
  - 从 `game.descriptor.profilePages` 获取页面列表
  - 账号管理区域：显示当前游戏支持的平台的账号
  - 账号切换不再切换游戏

- `lib/pages/community_v2.dart` — ConsumerWidget
  - 基本保持不变，去除 GetX 依赖

### 2.3 GoRouter 路由配置

**新建文件**: `lib/core/router.dart`
- 使用 GoRouter 定义路由
- 主路由 `/` → MainPageV2，子路由为 5 个 Tab
- 保留旧路由文件 `lib/routes/` 不删除（渐进式迁移）

---

## Phase 3: 游戏模块适配

### 3.1 为现有游戏实现新 Descriptor

每个游戏需要从旧的 `IGame.buildWikiViews()` / `buildRankViews()` 模式迁移到 `GameDescriptor` 模式。

**修改文件**（以 LXNS/maimai 为例）:
- `lib/modules/lxns/maimai_dx_game.dart`
  - 实现 `core/game.dart` 的 `Game` 抽象类（新）
  - 构建 `GameDescriptor`，将现有的 `buildWikiViews()` 中的 Tab 转为 `PageDescriptor` 列表
  - 将 `buildRankViews()` 中的 Tab 转为 scorePages
  - 将 `LxnsPlatform.getCustomFeatures()` 中的工具转为 toolboxPages
  - 将 `buildPlayerInfoCard()` 转为 profilePages

**同样处理**:
- `lib/modules/divingfish/` — DivingFish maimai 游戏
- `lib/modules/musedash/` — MuseDash 游戏
- `lib/modules/phigros/` — Phigros 游戏
- `lib/modules/osu/` — osu! 游戏

### 3.2 平台模块注册桥接

**新建文件**: `lib/core/bootstrap.dart`
- `bootstrapCore()` 函数：
  1. 初始化 `CoreProvider`
  2. 遍历旧 `PlatformRegistry` 的所有平台
  3. 将每个平台的游戏注册到新 `GameRegistryProvider`
  4. 将平台注册到新 `PlatformRegistryProvider`
  5. 建立平台-游戏关联（`PlatformGameRegistry`）
  6. 注册凭据提供者和登录处理器

---

## Phase 4: 入口切换

### 4.1 修改 App 入口

**修改文件**: `lib/main.dart`
- 在 `main()` 中调用 `bootstrapCore()`
- 用 `ProviderScope` 包裹整个 App
- 将根 Widget 从 `GetMaterialApp` 改为 `MaterialApp.router`（使用 GoRouter）
- 保留 `Get.put()` 注册旧 Controller（兼容未迁移的模块页面）

### 4.2 兼容层

**新建文件**: `lib/core/compat/getx_bridge.dart`
- 提供 `GetxBridge` 工具类
- 允许旧 GetX 页面通过桥接访问新 Riverpod 状态
- 允许新 Riverpod 页面通过桥接访问旧 GetX Controller（如 DataSyncController）

---

## 文件变更清单

### 新建文件（约 12 个）
```
lib/core/game_descriptor.dart          (重命名自 geme_descriptor.dart)
lib/core/viewmodels/main_view_model.dart
lib/core/viewmodels/game_selection_view_model.dart
lib/core/viewmodels/account_view_model.dart
lib/core/repositories/account_repository.dart
lib/core/repositories/game_repository.dart
lib/core/router.dart
lib/core/bootstrap.dart
lib/core/compat/getx_bridge.dart
lib/pages/main_page_v2.dart
lib/pages/wiki_v2.dart
lib/pages/rank_v2.dart
lib/pages/toolbox_v2.dart
lib/pages/mine_v2.dart
lib/pages/community_v2.dart
```

### 修改文件（约 8 个）
```
lib/core/page_descriptor.dart           (增加 requiresAccount / actionsBuilder / fabBuilder)
lib/core/core_provider.dart             (增加批量注册方法)
lib/main.dart                           (切换入口)
lib/modules/lxns/maimai_dx_game.dart    (适配新 Game 接口)
lib/modules/divingfish/...              (适配)
lib/modules/musedash/...                (适配)
lib/modules/phigros/...                 (适配)
lib/modules/osu/...                     (适配)
```

### 不删除的文件（兼容保留）
```
lib/controllers/*                       (旧 GetX Controller，逐步废弃)
lib/routes/*                            (旧路由，逐步废弃)
lib/pages/main_page.dart                (旧主页，保留备用)
lib/pages/wiki.dart, rank.dart, etc.    (旧页面，保留备用)
lib/models/game.dart                    (旧 IGame 接口，保留兼容)
lib/models/platform.dart                (旧 IPlatform 接口，保留兼容)
```

---

## 实施顺序

1. **Phase 1** (核心基础设施) — 纯新增，不影响现有功能
2. **Phase 2** (UI Shell) — 新建 v2 页面，切换入口
3. **Phase 3** (游戏适配) — 逐个模块适配，每个模块独立可测
4. **Phase 4** (入口切换) — 最后一步，切换 main.dart

每个 Phase 完成后 App 都应该可以正常运行。Phase 1 完成后旧代码完全不受影响；Phase 2-3 通过 v2 后缀的新文件隔离；Phase 4 才真正切换入口。

---

## 关键设计决策

1. **游戏不再区分 Wiki/Rank 选择** — 全局只有一个 `selectedGame`，游戏通过 Descriptor 自行决定在每个 Tab 展示什么内容
2. **游戏列表不依赖账号** — 所有注册的游戏都可浏览（公共资源如曲库不需要登录）
3. **账号跟随游戏** — 切换游戏后，自动选择该游戏支持的平台的账号
4. **PageDescriptor.requiresAccount** — 标记需要登录的页面，未登录时显示引导而非空白
5. **渐进式迁移** — 旧代码保留，新旧共存，通过 bootstrap 桥接
