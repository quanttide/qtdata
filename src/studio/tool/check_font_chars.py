#!/usr/bin/env python3
"""字体字符门禁：源码与 seed 中的**将被渲染的字符**必须都在自带字体子集内。

背景：studio 自带 Noto Sans SC 子集（fonts/*.ttf，含界面 emoji 字形），文字渲染
不依赖 fonts.gstatic.com。新增文案若含子集外字符，国外 CDN 不通的机器上该字符
显示为空——本脚本在本地与 CI（quality-gates）拦住这种情况。

判据口径：只看 Dart 字符串字面量与 seed JSON 的字符串内容（注释不渲染、不计入）。

用法：python3 tool/check_font_chars.py   # src/studio 下执行，字符缺失时 exit 1
"""

import glob
import json
import os
import re
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT_FILES = sorted(glob.glob(os.path.join(ROOT, "fonts", "*.ttf")))

# 字符来源：将被渲染的文本
DART_FILES = (
    glob.glob(os.path.join(ROOT, "lib", "**", "*.dart"), recursive=True)
    + glob.glob(os.path.join(ROOT, "test", "**", "*.dart"), recursive=True)
    + glob.glob(os.path.join(ROOT, "integration_test", "**", "*.dart"), recursive=True)
)
SEED_JSON = os.path.join(ROOT, "assets", "data", "seed_projects.json")


def parse_cmap_codepoints(path: str) -> set:
    """读 TTF cmap，返回覆盖的码点集合（format 4 + 12，多子表取并集）。"""
    data = open(path, "rb").read()
    (num_tables,) = struct.unpack(">H", data[4:6])
    cmap_off = None
    for i in range(num_tables):
        rec = data[12 + 16 * i : 12 + 16 * i + 16]
        if rec[0:4] == b"cmap":
            cmap_off = struct.unpack(">I", rec[8:12])[0]
    if cmap_off is None:
        raise ValueError(f"{path}: no cmap table")

    codes = set()
    (_, n_sub) = struct.unpack(">HH", data[cmap_off : cmap_off + 4])
    for i in range(n_sub):
        rec = data[cmap_off + 4 + 8 * i : cmap_off + 4 + 8 * i + 8]
        (_plat, _enc, off) = struct.unpack(">HHI", rec)
        sub = cmap_off + off
        (fmt,) = struct.unpack(">H", data[sub : sub + 2])
        if fmt == 4:
            (seg_x2,) = struct.unpack(">H", data[sub + 6 : sub + 8])
            seg = seg_x2 // 2
            ends = struct.unpack(f">{seg}H", data[sub + 14 : sub + 14 + seg_x2])
            starts = struct.unpack(
                f">{seg}H",
                data[sub + 16 + seg_x2 : sub + 16 + 2 * seg_x2],
            )
            for s, e in zip(starts, ends):
                if s == 0xFFFF and e == 0xFFFF:
                    continue
                codes.update(range(s, e + 1))
        elif fmt == 12:
            (n_groups,) = struct.unpack(
                ">I", data[sub + 12 : sub + 16]
            )
            for g in range(n_groups):
                base = sub + 16 + 12 * g
                (start, end, _glyph) = struct.unpack(
                    ">III", data[base : base + 12]
                )
                codes.update(range(start, end + 1))
        # 其余子表格式（6/14 等）不影响判定：4+12 已覆盖 BMP 与 emoji
    return codes


def dart_rendered_chars(source: str) -> set:
    """提取 Dart 单行字符串字面量的内容字符；注释与代码不计。"""
    chars = set()
    # 先摘出多行字符串（''' / \"\"\"），再处理单行
    for m in re.finditer(r"'''.*?'''|\"\"\".*?\"\"\"", source, re.S):
        chars.update(m.group(0)[3:-3])
        source = source.replace(m.group(0), "")
    for m in re.finditer(
        r"'(?:\\.|[^'\\\n])*'|\"(?:\\.|[^\"\\\n])*\"", source
    ):
        chars.update(m.group(0)[1:-1])
    return chars


def seed_chars() -> set:
    chars = set()

    def walk(node):
        if isinstance(node, str):
            chars.update(node)
        elif isinstance(node, dict):
            for k, v in node.items():
                chars.update(k)
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(json.load(open(SEED_JSON, encoding="utf-8")))
    return chars


def main() -> int:
    needed = seed_chars()
    for f in DART_FILES:
        needed |= dart_rendered_chars(open(f, encoding="utf-8").read())
    needed -= set("\n\r\t ")  # 空白由排版承担，不归字体管

    if not FONT_FILES:
        print("错误: fonts/*.ttf 不存在", file=sys.stderr)
        return 1

    failed = False
    for font in FONT_FILES:
        covered = parse_cmap_codepoints(font)
        missing = sorted(c for c in needed if ord(c) not in covered)
        name = os.path.basename(font)
        if missing:
            failed = True
            shown = " ".join(
                f"{c!r}(U+{ord(c):04X})" for c in missing[:40]
            )
            more = "" if len(missing) <= 40 else f" ...共 {len(missing)} 个"
            print(
                f"✗ {name}: 缺 {len(missing)} 个字符 {shown}{more}",
                file=sys.stderr,
            )
        else:
            print(f"✓ {name}: {len(needed)} 个字符全覆盖")

    if failed:
        print(
            "\n新文案含自带字体子集外的字符。按 CONTRIBUTING「自带字体」："
            "用 fontTools 重新子集化并同步四档字重。",
            file=sys.stderr,
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
