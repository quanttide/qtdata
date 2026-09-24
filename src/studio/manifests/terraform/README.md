# manifests/terraform — studio 交付底座（IaC v1）

范围**对齐家族惯例**（qtcloud / qtclass：OSS 入码，CDN / DNS / 证书控制台配置、事实记录在本文件）。
判据：`terraform plan` 与线上一致——**已达成：No changes**（2026-09-24，三件套全部 import 后零 diff）。

## 入码资源（OSS 三件套）

| 资源 | 说明 |
|---|---|
| `alicloud_oss_bucket.studio` | 桶 `qtdata-studio` + 静态网站托管（`index.html` 默认页、`404.html` 错误页——**根路径就是靠它经 CDN 回源落地的**） |
| `alicloud_oss_bucket_public_access_block.studio` | `block_public_access = false`（2023 后新桶默认开启会废掉 public-read，qtcloud README 同款踩坑） |
| `alicloud_oss_bucket_acl.studio` | `public-read`（CDN 公网回源 + 分发） |

## 用法

```bash
cd src/studio/manifests/terraform
export ALICLOUD_ACCESS_KEY=... ALICLOUD_SECRET_KEY=...   # 不入库；本机可取自 ~/.ossutilconfig
terraform init      # GitHub 不通的环境见下方「离线镜像」
terraform plan      # 期望：No changes
```

首次接管线上（已完成，记录供重建状态参考）：

```bash
terraform import alicloud_oss_bucket.studio qtdata-studio
terraform import alicloud_oss_bucket_public_access_block.studio qtdata-studio
terraform import alicloud_oss_bucket_acl.studio qtdata-studio
```

**离线镜像（GitHub releases 不通时）**：把插件缓存里解包的 provider 放进
`filesystem_mirror` 目录布局（`<mirror>/registry.terraform.io/aliyun/alicloud/<版本>/linux_amd64/`），
用 `TF_CLI_CONFIG_FILE` 指向含该 mirror 的配置即可（本机 1.288.0 实测可行；
注意 `~/.terraformrc` 现将 aliyun/alicloud 固定到 mirrors.aliyun.com 的 network mirror，该镜像对本 provider 返回 404，待修）。

**远端状态**：家族惯例 OSS backend，切换方法在 `providers.tf` 注释里（v1 先本地状态跑通判据）。

## CDN / DNS / 证书现状（家族惯例：控制台配置，此处记录事实）

| 项 | 现状 |
|---|---|
| CDN 域名 | `studio.data.quanttide.com`（正式入口）与 `data.quanttide.com`（过渡态，同桶同源）；CNAME 均 `*.{domain}.w.kunlunaq.com` |
| SPA 深链改写 | ✅ 已配（2026-09-24，API `BatchSetCdnDomainConfig`，家族 static-site 模块同款函数）：`back_to_origin_url_rewrite`，`source_url=^/projects/.*` → `target_url=/index.html`，`flag=break`；ConfigId 520829476141057 / 520829476141056。新增顶层客户端路由时同步此规则 |
| 证书 | 单域名证书 `studio.data.quanttide.com`（CertId 27443886，upload 型，续期手工/脚本）；**按家族惯例私钥不入 TF**，`*.quanttide.com` 泛域名走 acme.sh |
| DNS | zone `quanttide.com` 两条 CNAME：`studio.data`（RecordId 2103021428936637440）、`data`（RecordId 2084611140239472640），TTL 600；改指/下线时动这里 |
| 缓存策略 | workflow 侧分离：静态长缓存；index.html / flutter_bootstrap.js / manifest.json / assets/fonts/ / main.dart.js 单独 no-cache |

## 已知缺口（延续家族边界，非本仓欠账）

- CDN 域名资源（源站、证书、缓存规则）未入码——证书私钥不入库是家族策略；私钥入 Vault 后可补 `alicloud_cdn_domain_new`
- 根路径兜底依赖桶 website + CDN 回源配置，CDN 侧细节在控制台
