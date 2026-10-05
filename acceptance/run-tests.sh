#!/bin/sh
# =====================================================================
# 驗收測試執行入口 (single source for「如何跑驗收測試」)
# pre-commit hook 會呼叫本檔。
#
# 結構：每一段（各語言 / 各子系統）用 run_section 登記，
#   **獨立偵測工具、獨立跳過**——一段缺工具不會連帶略過其他段。
#   最後一行彙總：全部通過 / 已執行部分通過＋⚠️ 跳過（非通過）清單 / 失敗。
#
# 規則：任一段失敗 → exit 1（pre-commit 擋下）；
#       只有跳過、無失敗 → exit 0（不擋 commit），但明示「跳過 ≠ 通過」。
#
# 技術棧定案後（見 ADR、ops/environment.md 工具鏈就緒清單），
# 在下方「測試段」區塊取消註解或新增 run_section。
# =====================================================================

PASSED=""
SKIPPED=""
FAILED=""

# run_section <名稱> <偵測指令：工具是否存在> <測試指令>
run_section() {
  name="$1"; detect="$2"; cmd="$3"
  if ! sh -c "$detect" >/dev/null 2>&1; then
    echo "⏭  [$name] 跳過：偵測不到工具鏈（$detect）"
    SKIPPED="$SKIPPED $name"
    return 0
  fi
  echo "▶  [$name] 執行：$cmd"
  if sh -c "$cmd"; then
    PASSED="$PASSED $name"
  else
    echo "❌ [$name] 失敗"
    FAILED="$FAILED $name"
  fi
}

# ===================== 測試段（依技術棧啟用 / 新增） =====================
# 例：韌體可攜邏輯 host 自測（見 CLAUDE.md §5 可攜邏輯優先）
# run_section "firmware-host" "command -v gcc"    "make -C src/firmware host-selftest"
# 例：PC 端 Python
# run_section "pc-python"     "command -v python" "python -m pytest src/pc/tests -q"
# 例：Gherkin 驗收
# run_section "gherkin"       "command -v behave" "behave acceptance/software"
# ========================================================================

# ----- 彙總 -----
if [ -z "$PASSED$SKIPPED$FAILED" ]; then
  echo "=================================================================="
  echo "⚠️  同步防護尚未生效：還沒有任何測試段（run_section）被啟用。"
  echo "    目前 pre-commit 對所有 commit 一律放行——"
  echo "    這不代表程式碼真的符合契約，只代表還沒有測試可跑。"
  echo "    技術棧定案後，請在本檔「測試段」區塊啟用對應的 run_section，"
  echo "    防護才會真正擋下『文件與程式碼漂移』。"
  echo "=================================================================="
  exit 0
fi

echo "------------------------------------------------------------------"
if [ -n "$FAILED" ]; then
  echo "❌ 失敗：$FAILED"
  [ -n "$SKIPPED" ] && echo "⚠️  另有跳過（非通過）：$SKIPPED"
  exit 1
fi
if [ -z "$PASSED" ]; then
  echo "⚠️  沒有任何段實際執行——全部跳過（非通過）：$SKIPPED"
elif [ -n "$SKIPPED" ]; then
  echo "✅ 已執行部分通過：$PASSED"
  echo "⚠️  跳過（非通過）：$SKIPPED"
else
  echo "✅ 全部通過：$PASSED"
fi
exit 0
