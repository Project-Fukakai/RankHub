import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/game_descriptor.dart';
import 'package:rank_hub/games/maimai/maimai_dx_game.dart';
import 'package:rank_hub/platforms/maimai/divingfish_credential_provider.dart';
import 'package:rank_hub/platforms/maimai/lxns_credential_provider.dart';
import 'package:rank_hub/platforms/maimai/divingfish_login_handler.dart';
import 'package:rank_hub/platforms/maimai/lxns_login_handler.dart';
import 'package:rank_hub/platforms/phigros/phigros_credential_provider.dart';
import 'package:rank_hub/platforms/phigros/phigros_login_handler.dart';
import 'package:rank_hub/platforms/platform_descriptor.dart';
import 'package:rank_hub/games/phigros/phigros_game_v2.dart';
import 'package:rank_hub/modules/musedash/musedash_game_v2.dart';
import 'package:rank_hub/modules/osu/osu_game_v2.dart';

/// 初始化核心服务
/// 从旧的 PlatformRegistry 批量导入到新的 CoreProvider
Future<void> bootstrapCore() async {
  final coreProvider = CoreProvider.instance;

  // 初始化存储服务
  await coreProvider.initialize();

  CoreLogService.i('开始初始化 CoreProvider...');

  // 手动注册新架构的游戏
  // 注意：这里直接注册新的 Game 实现，不依赖旧的 PlatformRegistry
  _registerGames(coreProvider);

  CoreLogService.i('CoreProvider 初始化完成');
  coreProvider.printStats();
}

/// 注册新架构的游戏
void _registerGames(CoreProvider coreProvider) {
  // 注册 maimai DX 游戏（支持多平台：LXNS + DivingFish）
  final maimaiDX = MaimaiDXGameV2();
  coreProvider.gameRegistry.registerGame(maimaiDX);
  coreProvider.resourceRegistry.registerResources(maimaiDX.descriptor.resources);

  List<ResourceKey> _resourcesForPlatform(
    GameDescriptor descriptor,
    PlatformId platformId,
  ) {
    return descriptor.resources
        .where((resource) => resource.providedPlatforms.contains(platformId))
        .map((resource) => resource.key)
        .toList();
  }

  // 注册 LXNS 平台
  coreProvider.platformRegistry.registerPlatform(
    PlatformDescriptor(
      id: const PlatformId('lxns'),
      name: '落雪咖啡屋',
      description: '落雪咖啡屋账号登录',
      iconUrl: 'https://maimai.lxns.net/favicon.webp',
      credentialProvider: LxnsCredentialProvider(),
      loginHandler: LxnsLoginHandler(),
      supportedGames: [maimaiDX.id],
      providedResources: _resourcesForPlatform(
        maimaiDX.descriptor,
        const PlatformId('lxns'),
      ),
    ),
  );

  // 注册 DivingFish 平台
  coreProvider.platformRegistry.registerPlatform(
    PlatformDescriptor(
      id: const PlatformId('divingfish'),
      name: '水鱼查分器',
      description: '水鱼查分器账号登录',
      iconUrl: 'https://www.diving-fish.com/favicon.ico',
      credentialProvider: MaimaiDivingFishCredentialProvider(),
      loginHandler: DivingFishLoginHandler(),
      supportedGames: [maimaiDX.id],
      providedResources: _resourcesForPlatform(
        maimaiDX.descriptor,
        const PlatformId('divingfish'),
      ),
    ),
  );

  // 注册 Phigros 游戏
  final phigros = PhigrosGameV2();
  coreProvider.gameRegistry.registerGame(phigros);
  coreProvider.resourceRegistry.registerResources(phigros.descriptor.resources);

  coreProvider.platformRegistry.registerPlatform(
    PlatformDescriptor(
      id: const PlatformId('phigros'),
      name: 'Phigros',
      description: 'Phigros 账号绑定',
      iconUrl:
          'https://img.tapimg.com/market/images/9000b8b031deabbd424b7f2f530ee162.png',
      credentialProvider: PhigrosCredentialProvider(),
      loginHandler: PhigrosLoginHandler(),
      supportedGames: [phigros.id],
      providedResources: _resourcesForPlatform(
        phigros.descriptor,
        const PlatformId('phigros'),
      ),
    ),
  );

  // 注册 Muse Dash 游戏
  final musedash = MuseDashGameV2();
  coreProvider.gameRegistry.registerGame(musedash);

  coreProvider.platformRegistry.registerPlatform(
    PlatformDescriptor(
      id: const PlatformId('musedash'),
      name: 'Muse Dash',
      description: 'Muse Dash 平台',
      iconUrl: musedash.descriptor.iconUrl,
      supportedGames: [musedash.id],
      providedResources: _resourcesForPlatform(
        musedash.descriptor,
        const PlatformId('musedash'),
      ),
    ),
  );

  // 注册 osu! 游戏
  final osu = OsuGameV2();
  coreProvider.gameRegistry.registerGame(osu);

  coreProvider.platformRegistry.registerPlatform(
    PlatformDescriptor(
      id: const PlatformId('osu'),
      name: 'osu!',
      description: 'osu! 平台',
      iconUrl: osu.descriptor.iconUrl,
      supportedGames: [osu.id],
      providedResources: _resourcesForPlatform(
        osu.descriptor,
        const PlatformId('osu'),
      ),
    ),
  );

  CoreLogService.i(
    '已注册 4 个游戏: Maimai DX (多平台), Phigros, Muse Dash, osu!',
  );
}
