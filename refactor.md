## 当前问题

目前的 RankHub 架构存在以下核心问题：

1. **游戏入口被账号绑死**  
   - 目前 App 是“平台/账号优先”，用户必须切换账号才能切换游戏。  
   - 公共资源（曲库、分类、部分工具）也依赖账号，导致查阅不方便。  

2. **旧架构耦合严重**  
   - UI 直接依赖 platform / account Provider / legacy Service。  
   - 切换功能容易牵一发而动全身。  

3. **平台多样性**  
   - 多平台可能支持同一个游戏，但提供数据结构不同。  
   - UI 和业务逻辑难以统一。  

4. **迁移风险大**  
   - “我的/账号切换页”控制全局状态，是与新架构冲突最严重的页面。  
   - 如果直接改 UI 或相关 Controller，会导致未迁移部分不可用。


## 新架构核心设计原则

### 游戏是业务的最小单位

- 每个游戏**自行定义**：
  - 有哪些资源（曲库 / 藏品 / 角色 / 精灵等）
  - 有哪些成绩
  - 有哪些个人信息
  - 有哪些工具
  - 页面如何组织与展示（UI Descriptor）

> 框架不尝试抽象“乐曲 / 谱面”等共性，避免伪通用带来的复杂性。


### 平台是能力提供者，而非业务主体

平台只负责：

- 登录流程
- 凭据获取 / 刷新 / 校验
- 提供**部分**数据能力（能力存在差异）

平台 **不拥有**：
- 页面
- 游戏结构
- UI 逻辑


### 同一游戏可由多个平台聚合数据（Adapter）

- 不同平台可能：
  - 支持同一游戏
  - 提供不同维度的数据
- 游戏通过 Adapter 聚合这些数据，形成完整视图


### UI = Descriptor + WidgetBuilder

- 游戏提供 `PageDescriptor`
- UI Shell 负责组装（TabView / Scaffold）
- 页面内容可为：
  - 单页面
  - 多页面（自动 Tab）

## 技术栈与模式

- **架构模式**：MVVM
- **状态管理**：Riverpod
- **路由**：go_router
- **持久化**：
  - Isar：资源 / 成绩 /个人信息数据
  - SharedPreferences：上一次选择的游戏 / 账号
- **平台 UI**：支持平台自定义登录页

## 分层结构概览

```text
UI
 ↓
ViewModel (Riverpod)
 ↓
GameDescriptor / GameResource / UseCase
 ↓
Adapter / Repository
 ↓
Platform / Isar / SharedPreferences
```