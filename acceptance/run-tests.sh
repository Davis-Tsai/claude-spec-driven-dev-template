#!/bin/sh
# =====================================================================
# 驗收測試執行入口 (single source for「如何跑驗收測試」)
# pre-commit hook 會呼叫本檔。
#
# 技術棧定案後（見 charter/open-questions.md、ADR），把下面換成實際指令，
# 並確保：測試全過 → exit 0；有失敗 → exit 非 0（pre-commit 才擋得下）。
# 例：  pytest acceptance/        (Python)
#       npm test                  (Node)
#       behave acceptance/software (Gherkin/behave)
#
# 工具鏈未安裝時（見 ops/environment.md 工具鏈就緒清單）：
#   優雅跳過並 exit 0（不擋 commit），但輸出務必明示「跳過 ≠ 通過」，
#   切勿讓綠燈誤導；工具鏈就緒後才會真正執行測試。
# =====================================================================

echo "=================================================================="
echo "⚠️  同步防護尚未生效：acceptance 測試指令還沒設定。"
echo "    目前 pre-commit 對所有 commit 一律放行——"
echo "    這不代表程式碼真的符合契約，只代表還沒有測試可跑。"
echo "    技術棧定案後，請把實際測試指令填進 acceptance/run-tests.sh，"
echo "    防護才會真正擋下『文件與程式碼漂移』。"
echo "=================================================================="

# 目前無測試 → 放行（回傳 0），避免早期階段擋住 commit。
exit 0
