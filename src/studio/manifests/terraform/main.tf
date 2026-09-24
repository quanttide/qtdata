# studio 交付底座（IaC，家族范围对齐 qtcloud/qtclass）：
#   OSS 三件套入码；CDN / DNS / 证书按家族惯例控制台配置、事实记录在 README.md。
#
# 与 qtcloud-studio 的差异：本桶**不开静态网站托管**（线上即无）——
# 根路径由 CDN 侧机制兜底，见 README「CDN 现状」。

resource "alicloud_oss_bucket" "studio" {
  bucket = "qtdata-studio"

  # 静态网站托管（线上实测配置：index.html 默认页 + 404.html 错误页）——
  # CDN 回源靠它把根路径落到 index.html，也是 web 入口的兜底。
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

# 2023 后新桶默认开启"阻止公共访问"，会使 public-read 失效（AccessDenied），
# 需显式关闭（qtcloud README 同款踩坑）。
resource "alicloud_oss_bucket_public_access_block" "studio" {
  bucket              = alicloud_oss_bucket.studio.bucket
  block_public_access = false
}

# 公共读：CDN 公网回源 + 客户端分发
resource "alicloud_oss_bucket_acl" "studio" {
  bucket = alicloud_oss_bucket.studio.bucket
  acl    = "public-read"
}
