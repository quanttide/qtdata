# 阿里云凭证通过环境变量注入（不在代码中写死）：
#   export ALICLOUD_ACCESS_KEY=...
#   export ALICLOUD_SECRET_KEY=...
provider "alicloud" {
  region = var.region
}

# 远程状态（家族惯例：本机与 CI 共用）。v1 先本地状态跑通判据；
# 切远端时去掉注释并 init -backend-config：
# terraform {
#   backend "oss" {
#     # bucket = "<状态桶>"
#     # key    = "qtdata/terraform.tfstate"
#     # region = "cn-hangzhou"
#   }
# }
