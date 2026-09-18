# RankHub CI（GitHub Actions）

> ⚠️ **本仓库只放 `.github/` 一棵树。** 源码、构建定义（`docker-bake.hcl`）、编排脚本
> （`scripts/ci/*.sh`）、Dockerfile、部署脚本都在 Codeup 的 `RankHub-NET`；
> workflow 经**只读 SSH deploy key** 把它们检出到 `codeup/` 子目录再执行。
> 所以「改这里能改构建」是**错的**，改这里只改「谁在什么时候跑」。

## 目录

```
.github/
├── actions/
│   ├── checkout-source/    # 取码 + 把 ref 解析成不可变 commit（三种流水线共用）
│   ├── fetch-baseline/     # 保证 origin/main 存在（契约/护栏的 merge-base 依赖它）
│   └── setup-node-pnpm/    # Node/pnpm 版本与缓存（两条流水线共用的两处「踩过的坑」）
└── workflows/
    ├── rankhub-release.yml         # 发布：门禁 → 计划 → 构建 5 镜像推 TCR → 发布清单
    ├── rankhub-pr-gate.yml         # 合并请求门禁：lint/单测、契约零 diff、静态护栏
    ├── validate-workflows.yml      # 本仓库自检（只放 workflow / action 钉 SHA / runs-on 走变量）
    └── rankhub-probe.yml.disabled  # 已归档的一次性探针（GitHub 不加载 .disabled）
```

## 从哪开始

**落地手册：[`webhook-setup.md`](./webhook-setup.md)** —— 凭据、Webhook、首次验证顺序、
已知风险（跨境推镜像）、切换到国内自建 runner、回滚回云效，都在那一个文件里。

设计说明在 Codeup 仓库的 `docs/CI_CD_PIPELINE.zh-CN.md`（§0.2 迁移说明 / §20 GitHub Actions 形态）。

## 三条不要破的规矩

1. **`runs-on` 必须写 `${{ vars.CI_RUNNER || 'ubuntu-24.04' }}`。**
   跨境外推镜像的退路就是「换 runner 只改一个仓库变量」，写死字面量等于把这条退路删了。
   `validate-workflows.yml` 会硬拦。
2. **第三方 action 必须 pin 到 40 位 commit SHA，并带版本注释。** 浮动 tag 可被上游改写。
3. **不要在这里加人工审批（Environment / required reviewers）。**
   生产闸门是**部署动作**（admin 改 `DEPLOY_TARGET_TAG`，必填 reason + 审计），
   2026-09-18 的既有决定，云效版已同样取消。

## 改 workflow 之后

本仓库的改动**不改构建定义**，但要改 Codeup 侧两个守卫测试的镜像副本：
`testing/deploy/build-args.test.ts` 与 `testing/deploy/release-artifact.test.ts` 读的是
Codeup 仓库里 `.github/workflows/rankhub-release.yml` 的**副本**（它们的注释里写明了原因）。
改了构建步骤的 build arg / 制品步骤，请同步那份副本，否则门禁会红 —— 那是**故意的**：
它让「构建参数漏传」这类静默 bug 在 Codeup 的 MR 门禁里就暴露。
