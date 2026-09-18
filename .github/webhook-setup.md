# RankHub CI 在 GitHub Actions 上的落地手册

> 本仓库（`Project-Fukakai/RankHub`）**只放 workflow**，且只放 `.github/` 一棵树
> （由 `validate-workflows.yml` 强制）。源码、构建定义、编排脚本都在 Codeup 的
> `RankHub-NET`，由 workflow 经只读 SSH deploy key 检出到 `codeup/` 子目录。

配套文档在 Codeup 仓库：`docs/CI_CD_PIPELINE.zh-CN.md`（§0.2 / §20）。

---

## 0. 两条流水线

| workflow | 触发 | 作用 |
| --- | --- | --- |
| `rankhub-release.yml` | Codeup push/tag → `repository_dispatch[codeup-push]`，或手动 `workflow_dispatch` | 门禁 → 变更检测 → 构建 5 个镜像推 TCR → 产出 `release-manifest.json` + 发布制品 |
| `rankhub-pr-gate.yml` | Codeup 合并请求 → `repository_dispatch[codeup-mr]`，或手动 | lint / test:unit、契约零 diff（分层）、静态护栏 |
| `validate-workflows.yml` | 本仓库 push / PR | 自检：只放 workflow、YAML 可解析、action 钉 SHA、`runs-on` 走变量 |

发布**不部署**。生产闸门是**部署动作**（admin 改 `DEPLOY_TARGET_TAG`，必填 reason + 审计），
与云效版同一口径 —— 不要在这里加人工审批 Environment。

---

## 1. 一次性配置

### 1.1 Secrets（Settings → Secrets and variables → Actions → Secrets）

| 名称 | 内容 | 怎么生成 |
| --- | --- | --- |
| `CODEUP_SSH_KEY` | **只读** deploy key 的**私钥** | `ssh-keygen -t ed25519 -C 'gha-rankshub-ci' -f ./gha_codeup -N ''`；公钥给 Codeup |
| `CODEUP_KNOWN_HOSTS` | `codeup.aliyun.com` 的主机公钥行 | 见 §1.3（**必须先核对指纹**） |
| `TCR_USERNAME` | 腾讯云账号 ID（TCR「访问凭证」里的用户名） | 与云效变量组 `rankhub-release` 里的同名值一致 |
| `TCR_PASSWORD` | TCR 镜像仓库密码 | 同上 |

`CODEUP_SSH_KEY` 的公钥要加到 **Codeup → `RankHub-NET` → 设置 → 部署公钥（只读）**。
部署公钥是**仓库级、只读**的，比个人 SSH 公钥更适合 CI：不绑定任何个人账号，可单独吊销。

### 1.2 Variables（同一页面的 Variables 标签）

| 名称 | 建议值 | 作用 |
| --- | --- | --- |
| `CI_RUNNER` | `ubuntu-24.04` | 所有 job 的 `runs-on` 都读它 |
| `CI_RUNNER_SELF_HOSTED` | `self-hosted` | 预留给国内自建 runner（见 §4）；当前 workflow 未引用，切换到自建时把 `CI_RUNNER` 改指向它 |

### 1.3 `CODEUP_KNOWN_HOSTS` —— 别抄别人的

```bash
# 1) 取主机公钥（用你自己的网络，别在 CI 里跑）
ssh-keyscan -t rsa codeup.aliyun.com > /tmp/codeup.hostkey 2>/dev/null

# 2) 核对指纹 —— 必须与 Codeup 官方文档公布的值一致：
#    SHA256:yEGmgQNVrc3QAvDvoBrTCF2s07KwmmQ+AbWi9vSt/fE  (RSA)
#    https://help.aliyun.com/zh/yunxiao/user-guide/platform-key-fingerprint-verification
ssh-keygen -lf /tmp/codeup.hostkey
# → 2048 SHA256:yEGmgQNVrc3QAvDvoBrTCF2s07KwmmQ+AbWi9vSt/fE codeup.aliyun.com (RSA)

# 3) 核对通过后，把整行粘进 secret
cat /tmp/codeup.hostkey
```

❗ **不要**在 workflow 里 `ssh-keyscan`（等于信任网络中间人），也**不要**用 `ssh-strict: false`。
本仓库的 `actions/checkout-source/action.yml` 拿的就是这个 secret。

### 1.4 Codeup 侧 Webhook（触发链路的关键，GHA 看不到 Codeup 的仓库事件）

Codeup → `RankHub-NET` → 设置 → **Webhooks** → 新建。目标地址：

```
https://api.github.com/repos/Project-Fukakai/RankHub/dispatches
```

请求头：

| Header | 值 |
| --- | --- |
| `Accept` | `application/vnd.github+json` |
| `Authorization` | `Bearer <PAT>` |
| `Content-Type` | `application/json` |

需要两个 Webhook（事件不同、body 不同）：

**① 发布（push 与 tag）** — 勾「推送事件」+「标签推送事件」

```json
{"event_type":"codeup-push","client_payload":{"ref":"<本次推送的分支或 tag 名>"}}
```

**② 合并请求门禁** — 勾「合并请求事件」

```json
{"event_type":"codeup-mr","client_payload":{"ref":"<合并请求的源分支名>"}}
```

`<...>` 处填 Codeup Webhook 模板提供的变量占位符（控制台在该输入框旁有「可用变量」列表）。
**workflow 侧不解析 payload 的 JSON 结构** —— 它只从 `client_payload.ref` 取一个 ref 名，
再用 `git ls-remote` 自己解析成 commit。所以占位符叫什么名字、body 长什么样都不影响。

**PAT 权限**：`repository_dispatch` 只需要对该仓库的 **Contents: Read and write**
（GitHub 的 API 把 dispatch 归在 contents 写权限下）。**不要**给 `workflow`、`packages`、
`admin` 等任何多余 scope —— 这个 PAT 是本次迁移新增的唯一长期凭据。

> 如果 Codeup 的 Webhook 不支持自定义 Header，退路有两条（都验证过思路，未实测）：
> ① 在 rankhub.cc 上放一个 10 行的转发服务（收 Codeup webhook → 调 dispatch）；
> ② 用 `rankhub-release.yml` 顶部注释里那两行 `schedule:` 开 15 分钟轮询（默认关闭）。
> **不要**把 PAT 放进 URL query（会进 Codeup 的日志）。

### 1.5 保护本仓库的默认分支

`validate-workflows.yml` 的护栏只有在「改 `.github/` 要走 PR」时才有意义。
建议 `main` 开分支保护：禁直推 + 必须 PR。若确实要直推，至少开着 push 触发的那一版护栏。

---

## 2. 首次验证顺序（按这个顺序做，每步都能单独解释失败）

1. **手动跑 pr-gate**（Actions → rankhub-pr-gate → Run workflow → ref 填 `main`）
   * 先看 `解析源分支` job：能过 = deploy key + known_hosts 正确。
   * 再看 `准备基线` 的日志：出现 `已取回 origin/main` = 基线可用。
   * 三个 job 都绿 = 取码、Node/pnpm、契约、护栏全部就位。
2. **手动跑 release，ref 填 `main`**
   * `变更检测` job 的日志里应能看到 `plan.json`；若出现「找不到发布 tag 基线」→ 全量构建
     （那是**安全侧**降级，说明 clone 没拿到 tags，去查 `fetch-full-history`）。
   * 构建**只有选中的组**会起 job。想先小步验，可先对一个只改了 supervisor 的 commit 跑。
   * 关注耗时与是否 OOM（见 §3）。
3. **打一个发布 tag**（`git tag 2026.09.18.1 && git push origin 2026.09.18.1`），确认
   `rankhub-release:<version>` 制品产出，且 `release-manifest.json` 里 5 个 ref 都含 digest。
4. **真机取件**：目标机 `bash scripts/deploy/apply-release.sh --version <version> --dry-run`。

---

## 3. 已知风险与首次跑的观察点

### 3.1 跨境推镜像（本次迁移的最大风险，文档 §0.1 记过）

GitHub 托管 runner 在境外，镜像要跨境推到腾讯云 TCR。这是当初从 GHA 迁到云效的**核心原因**。
首次跑必须记录：

| 观察点 | 期望 | 超了怎么办 |
| --- | --- | --- |
| 单个镜像 push 耗时 | 与云效同量级 | 明显劣化 → 走 §4 换自建 runner |
| `bake` 是否因网络超时重试 | 无重试 | 加 `--set *.network=host`？先看日志再定 |

### 3.2 `NESTIA_BUILD_PARALLELISM=4` 在 4C16G runner 上

云效构建机是 **8C16G**，4 并行是照它算出来的（`(16-2)/3.5`）。GHA 托管 runner 是 **4C16G**，
核数减半但内存相同 —— 如果 backend 构建出现 `FATAL ERROR: Reached heap limit`（exit 134），
把 `rankhub-release.yml` 里 build 步骤的 `NESTIA_BUILD_PARALLELISM` 从 `4` 改成 `2`，
并把结论写进那行注释（云效版也是这么一步步实测出来的）。

### 3.3 GHA 缓存 10 GB/仓库

Docker 缓存后端是 `type=gha`，仓库级上限 10 GB，LRU 驱逐。5 个 target 各一个 scope。
如果发现缓存频繁未命中（日志里 `importing cache manifest` 之后仍然全量构建），
优先给 `backend` 保留 `mode=max`，其余 target 降成 `mode=min`。

### 3.4 公开仓库的 job 日志

本仓库是公开的，**任何人都能看 Actions 日志**。
所以：不要把任何 secret 打成日志，也不要在 workflow 里 `echo` 环境变量。
`TCR_*` 与 `CODEUP_SSH_KEY` 都只以 secret 形式注入，`docker login` 走
`docker/login-action`（它自己会遮蔽密码）。

---

## 4. 切换到国内自建 runner（一条命令）

当 §3.1 的账算不过来时：

1. 准备一台常驻机器（4C8G 起），装 Docker + buildx（docker-container driver）。
2. 在该机器上注册 repo-level self-hosted runner，标签自定，例如 `rankhub-cn`。
3. 仓库 Variables 里把 `CI_RUNNER` 改成 `rankhub-cn`。
   —— 所有 job 的 `runs-on: ${{ vars.CI_RUNNER || 'ubuntu-24.04' }}` 会立刻切过去，
   **不改任何 workflow 文件**（`validate-workflows.yml` 会拦住有人写死字面量）。

注意自建 runner 的代价：机器的补丁、磁盘回收、Docker 凭据都变成你的责任；
`docker/login-action` 在自建 runner 上会往机器的 `~/.docker/config.json` 写凭据（除非用
`actions/checkout` 那样的隔离），多项目共用一台 runner 时要留意。

---

## 5. 回滚回云效

云效侧的两条流水线**没有删除**，只是不再被推送触发。回滚：

1. Codeup → 对应流水线 → 关闭「代码源触发」，或直接把 Webhook 停用；
2. （可选）删除 §1.4 的两个 GitHub Webhook；
3. 撤销 §1.1 的 `CODEUP_SSH_KEY`（删掉 Codeup 里的部署公钥）与 §1.4 的 PAT。

云效侧流水线跑的是**云效控制台里存的那份 YAML**，与仓库里的 `.yunxiao/*.yml` 副本无关
（那个副本现在只作留档，顶部有说明）。
