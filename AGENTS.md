# AGENTS

## 工作纪律

- **先文档，后代码**。方案在文档里达成共识再动手，不擅自实现。
- **只做用户明确要求的**。不预判需求，不添加未要求的文件、测试、依赖。
- **专注当前问题**。不发散到无关的优化、重构、设计。
- **回答简洁**。不解释背景、理由、替代方案，除非被问到。
- **提交粒度小**。一个改动一个提交，提交信息说明意图。

## 测试体系

按 `tests/README.md` 的约定，不越级。

## 仓库结构

见 `README.md` 仓库结构部分。

## 文档索引

| 文档 | 用途 |
|------|------|
| `ROADMAP.md` | 项目路线图：数据页面、资产页面 |
| `tests/ROADMAP.md` | E2E 测试路线图 |
| `tests/screens/ROADMAP.md` | 页面层路线图（Project、Data、Asset 三页面） |
| `src/studio/ROADMAP.md` | Studio 客户端路线图（qtdata-process、qtdata-asset） |
| `src/provider/ROADMAP.md` | Provider 服务端路线图（流程 API、资产 API） |
| `tests/README.md` | 测试体系约定（三层：conftest / utils / usecases） |


